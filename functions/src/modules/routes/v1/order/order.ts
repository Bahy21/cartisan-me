// 
import * as db from "../../../../services/database";
import {  addressFromMap, cartItemFromMap, getOrderItemStatusFromString, orderFromDoc, userFromDoc } from "../../../../services/functions";
import { CollectionReference, DocumentReference } from "firebase-admin/firestore";
import { OrderItemModel } from "../../../../models/order_item_model";
import { OrderModel } from "../../../../models/order_model";
import * as express from "express";
import { CartItemModel } from "../../../../models/cart_item_model";
import { DeliveryOptions, OrderItemStatus } from "../../../../models/enums";
import { firestore } from "../../../..";
import logger from "../../../../services/logger";
import { log } from "firebase-functions/logger";
const router = express.Router();
////////////////////////////
//UNCHANGED BUSINESS LOGIC//
////////////////////////////
const app_fee_percent = 0.02;
const serviceFeeInCents = 100;
////////////////////////////
//UNCHANGED BUSINESS LOGIC//
////////////////////////////


router.post("/api/order/newOrder/:userId", async (req, res) => {
    try {
        const userId: string = req.params.userId;
        const address = addressFromMap(req.body.address);
        const currency = req.body.currency ?? 'USD';
        const userCartRef = db.userCartCollection(userId);
        const userCartQuerySnapshot = await userCartRef.get();
        if(userCartQuerySnapshot.empty){
            return res.status(500).send({status: "Failed", msg: "No items in cart"});
        }
        const cartItems = <CartItemModel[]>[];
        for(const cartItem of userCartQuerySnapshot.docs){
            cartItems.push(cartItemFromMap(cartItem.data() as Map<string,any>));
        }
        const docData = await db.userCollection.doc(userId).get();
        const currentUser = userFromDoc(docData);
        currentUser.sellerID = docData.get("sellerID");
        const orderId = db.ordersCollection.doc().id;
        const orderItemList = <OrderItemModel[]>[];
        for(const cartItem of cartItems){
            const sellerId = cartItem.sellerId;
            const seller = userFromDoc(await db.userCollection.doc(sellerId).get());
            ////////////////////////////
            //UNCHANGED BUSINESS LOGIC//
            ////////////////////////////
            const costBeforeTaxInCents = cartItem.priceInCents * cartItem.quantity;
            const taxApplicable = seller.state && seller.taxPercentage;
            const sellerFeeInCents = costBeforeTaxInCents * app_fee_percent;
            const appFeeInCents = serviceFeeInCents + sellerFeeInCents;
            const taxFactor = taxApplicable ? seller.taxPercentage / 100 : 0;
            const taxAmountInCents = parseInt(`${costBeforeTaxInCents * taxFactor}`);
            const deliveryCostInCents = getDeliveryCostInCents(
            cartItem.deliveryOptions,
            seller,
            costBeforeTaxInCents/100
            );

            const grossTotalInCents =
            costBeforeTaxInCents +
            deliveryCostInCents +
            taxAmountInCents +
            serviceFeeInCents;
            ////////////////////////////
            //UNCHANGED BUSINESS LOGIC//
            ////////////////////////////
            const newOrderItem = new OrderItemModel({
                deliveryOption: cartItem.deliveryOptions,
                orderItemID: orderId,
                productId: cartItem.postId,
                productOption: cartItem.selectedVariant,
                quantity: cartItem.quantity,
                serviceFeeInCents: serviceFeeInCents,
                sellerId: cartItem.sellerId,
                state: seller.state,
                status: 0,
                currency: "USD",
                price: cartItem.priceInCents/100,
                tax: taxAmountInCents / 100,
                appFeeInCents: appFeeInCents,
                costBeforeTaxInCents: costBeforeTaxInCents,
                deliveryCostInCents: deliveryCostInCents,
                grossTotalInCents: grossTotalInCents,
                
            });
            newOrderItem.sellerStripeId = seller.sellerID;
            orderItemList.push(newOrderItem);
        }
        let totalAmountInCents = 0;
        for (const orderItem of orderItemList) {
            totalAmountInCents += orderItem.grossTotalInCents;
        }
        const involvedSellersList = <string[]>[] 
        orderItemList.map((orderItems) => involvedSellersList.push(orderItems.sellerStripeId));
        const order = new OrderModel({
            orderId: orderId,
            buyerId: currentUser.id,
            involvedSellersList: involvedSellersList,
            orderItems: orderItemList,
            timestamp: Date.now(),
            total: totalAmountInCents / 100,
            totalInCents: totalAmountInCents,
            orderStatus: OrderItemStatus.pending,
            currency: currency,
            isPaid: false,
            address: address,
            shippingAddress: address,
        });
        logger.info(order);
        log(order.toMap());
        await db.ordersCollection.doc(orderId).set(order.toMap(), {merge: true});
        let cartItemDocSnapshots = <DocumentReference[]>[];
       
        // get cart items
        for(const cartItem of userCartQuerySnapshot.docs){

            cartItemDocSnapshots.push(cartItem.ref);
        }        
         // delete cartRef collection
        const batch = firestore.batch();
        for(const cartItemSnapshot of cartItemDocSnapshots){
            await cartItemSnapshot.delete();
        }
        await batch.commit();
        return res.status(200).send({status: "Success", data: order.toMap()});
    } catch (error) {
        logger.info(error);
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
        logger.info(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});

router.put("/api/order/updateOrderItemStatus/:orderId", async (req, res) => {
    try {
        const orderId: string = req.params.orderId;
        const newStatus:string = req.body.status;
        const orderItemIdToBeChanged :string= req.body.orderItemId;
        if(!newStatus || !orderItemIdToBeChanged || newStatus == '' || orderItemIdToBeChanged == ''){
            throw Error(`Invalid paramteres passed newStatus: ${newStatus} orderItemIdToBeChanged: ${orderItemIdToBeChanged}`);
        }
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
        logger.info(error);
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
        logger.info(error);
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
        logger.info(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});

router.get("/api/order/getPurchasedOrders/:userId", async (req, res) => {
    try {
        const userId: string = req.params.userId;
        const orderDocRef = db.ordersCollection.where("buyerId","==",userId).where('isPaid', '==', true);
        const orderQuerySnapshot = await orderDocRef.get();
        const orderList = <OrderModel[]>[];
        for (const orderDoc of orderQuerySnapshot.docs){
            orderList.push(orderFromDoc(orderDoc));
        }
        return res.status(200).send({status: "Success", data: orderList.map((order)=>order.toMap())})
    } catch (error) {
        log(error);
        logger.info(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});
router.get("/api/order/getSoldOrders/:userId", async (req, res) => {
    try {
        const userId: string = req.params.userId;
        const orderDocRef = db.ordersCollection.where('sellers','array-contains',userId).where('isPaid', '==', true);
        const orderQuerySnapshot = await orderDocRef.get();
        const orderList = <OrderModel[]>[];
        for (const orderDoc of orderQuerySnapshot.docs){
            log(orderDoc.data());
            orderList.push(orderFromDoc(orderDoc));
        }
        return res.status(200).send({status: "Success", data: orderList.map((order)=>order.toMap())})
    } catch (error) {
        log(error);
        logger.info(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});

export function getDeliveryCostInCents(deliveryOptions, user, subtotal) {
    logger.info(deliveryOptions);
    logger.info("Delivery " + user.deliveryCost);
    logger.info("Shippin " + user.shippingCost);
  
    switch (deliveryOptions) {
      case DeliveryOptions.pickup.valueOf():
        return 0;
      case DeliveryOptions.shipping.valueOf():
        if (user.freeShipping < subtotal) {
          return 0;
        }
        return user.shippingCost*100;
      case DeliveryOptions.delivery.valueOf():
        if (user.freeDelivery < subtotal) {
          return 0;
        }
        return user.deliveryCost*100;
      default:
        return 0;
    }
  }
  


module.exports = router;
