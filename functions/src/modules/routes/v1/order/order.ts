import { log } from "firebase-functions/logger";
import * as db from "../../../../services/database";
import {  cartItemFromMap, getOrderItemStatusFromString, orderFromDoc, orderItemFromCartItem, userFromDoc } from "../../../../services/functions";
import { CollectionReference, DocumentReference } from "firebase-admin/firestore";
import { OrderItemModel } from "../../../../models/order_item_model";
import { OrderModel } from "../../../../models/order_model";
import * as express from "express";
import { CartItemModel } from "../../../../models/cart_item_model";
import { OrderItemStatus } from "../../../../models/enums";
import { firestore } from "../../../..";
const router = express.Router();

router.post("/api/order/newOrder/:userId", async (req, res) => {
    try {
        const userId: string = req.params.userId;
        const cartRef:CollectionReference = db.userCartCollection(userId);
        let cart = <CartItemModel[]>[];
        let cartItemDocSnapshots = <DocumentReference[]>[];
        // get cart query snapshot
        const cartQuerySnapshot = await cartRef.get();
        // get cart items
        for(const cartItem of cartQuerySnapshot.docs){
            cart.push(cartItemFromMap(cartItem.data() as Map<string,any>));
            cartItemDocSnapshots.push(cartItem.ref);
        }

        let sellerList: string[] = <string[]>[];
        let orders:OrderItemModel[] = <OrderItemModel[]>[];
        // map cart items to order items and seller list
        for(const cartItem of cart){
            const sellerDocRef = db.userCollection.doc(cartItem.sellerId);
            const seller = userFromDoc(await sellerDocRef.get());
            const orderItem = orderItemFromCartItem(cartItem, seller);
            orders.push(orderItem);
            sellerList.push(cartItem.sellerId);
        }
        if(orders.length == 0 || sellerList.length == 0){
            return res.status(500).send({status: "Failed", msg: "No items in cart"});
        }
        // find cart total
        let total: number = 0;
        for(const orderItem of orders){
            total += orderItem.grossTotalInCents;
        }
        const newOrder = new OrderModel({
            orderId: "",
            buyerId: userId,
            total: total/100,
            orderItems: orders,
            timestamp: Date.now(),
            involvedSellersList: sellerList,
            totalInCents: total,
            orderStatus: OrderItemStatus.pending
        });
        const orderDocReference: DocumentReference = db.ordersCollection.doc();
        newOrder.orderId = orderDocReference.id;
        log(`new order ${newOrder.toString()}`);
        await orderDocReference.set(newOrder.toMap());
        // delete cartRef collection
        const batch = firestore.batch();
        for(const cartItemSnapshot of cartItemDocSnapshots){
            await cartItemSnapshot.delete();
        }
        await batch.commit();
        return res.status(200).send({status: "Success", msg: `Order ${newOrder.orderId} added successfully`});
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }

});


router.put("/api/order/updateOrderStatus/:orderId", async (req, res) => {
    try {
        const orderId: string = req.params.orderId;
        const newStatus = req.body.status;
        const orderDocRef = db.ordersCollection.doc(orderId);
        const newStatusEnum = getOrderItemStatusFromString(newStatus);
        await orderDocRef.update({orderStatus: newStatusEnum});
        return res.status(200).send({status: "Success", msg: `Order ${orderId} has been updated to ${newStatusEnum}`})
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});

router.put("/api/order/updateOrderItemStatus/:orderId", async (req, res) => {
    try {
        const orderId: string = req.params.orderId;
        const newStatus:string = req.body.status;
        const orderItemIdToBeChanged :string= req.body.orderItemId;
        const newStatusEnum = getOrderItemStatusFromString(newStatus);
        const orderDocRef = db.ordersCollection.doc(orderId);
        const order = orderFromDoc(await orderDocRef.get());
        const index = order.orderItems.findIndex((orderItem)=>orderItem.orderItemID==orderItemIdToBeChanged);
        if(index == -1){
            throw Error(`No order of ID ${orderItemIdToBeChanged} found`);
        } else {
            order.orderItems[index].status = newStatusEnum;
            orderDocRef.update({"orderItems":order.orderItems});
        }
        return res.status(200).send({status: "Success", msg: `Item ${orderItemIdToBeChanged} in Order ${orderId} has been updated to ${newStatusEnum}`})
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});

router.get("/api/order/getOrder/:orderId", async (req, res) => {
    try {
        const orderId: string = req.params.orderId;
        const orderDocRef = db.ordersCollection.doc(orderId);
        const order = orderFromDoc(await orderDocRef.get());
        return res.status(200).send({status: "Success", data: order.toMap()})
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});

router.delete("/api/order/deleteOrder/:orderId", async (req, res) => {
    try {
        const orderId: string = req.params.orderId;
        const orderDocRef = db.ordersCollection.doc(orderId);
        await orderDocRef.delete();
        return res.status(200).send({status: "Success", msg: `Order ${orderId} has been successfully deleted`})
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});

module.exports = router;
