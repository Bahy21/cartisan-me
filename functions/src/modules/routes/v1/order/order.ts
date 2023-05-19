import { log } from "firebase-functions/logger";
import * as db from "../../../../services/database";
import {  addressFromMap, cartItemFromMap, getOrderItemStatusFromString, userFromDoc } from "../../../../services/functions";
import { CollectionReference, DocumentReference } from "firebase-admin/firestore";
import { OrderItemModel } from "../../../../models/order_item_model";
import { OrderModel } from "../../../../models/order_model";
import * as express from "express";
import { CartItemModel } from "../../../../models/cart_item_model";
import { DeliveryOptions, OrderItemStatus } from "../../../../models/enums";
import { firestore } from "../../../..";
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
        const currentUser = userFromDoc(await db.userCollection.doc(userId).get());
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
            orderItemList.push(newOrderItem);
        }
        let totalAmountInCents = 0;
        for (const orderItem of orderItemList) {
            totalAmountInCents += orderItem.grossTotalInCents;
        }

        const order = new OrderModel({
            orderId: orderId,
            buyerId: currentUser.id,
            involvedSellersList: cartItems.map((cartItem) => cartItem.sellerId),
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
        await db.ordersCollection.doc(orderId).set(order.toMap());
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
        return res.status(200).send({status: "Success", msg: `Order ${order.orderId} added successfully`});
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

// router.put("/api/order/updateOrderItemStatus/:orderId", async (req, res) => {
//     try {
//         const orderId: string = req.params.orderId;
//         const newStatus:string = req.body.status;
//         const orderItemIdToBeChanged :string= req.body.orderItemId;
//         const newStatusEnum = getOrderItemStatusFromString(newStatus);
//         const orderDocRef = db.ordersCollection.doc(orderId);
//         const order = orderFromDoc(await orderDocRef.get());
//         const index = order.orderItems.findIndex((orderItem)=>orderItem.orderItemID==orderItemIdToBeChanged);
//         if(index == -1){
//             throw Error(`No order of ID ${orderItemIdToBeChanged} found`);
//         } else {
//             order.orderItems[index].status = newStatusEnum;
//             orderDocRef.update({"orderItems":order.orderItems});
//         }
//         return res.status(200).send({status: "Success", msg: `Item ${orderItemIdToBeChanged} in Order ${orderId} has been updated to ${newStatusEnum}`})
//     } catch (error) {
//         log(error);
//         return res.status(500).send({status: "Failed", msg: error.message});
//     }
// });

// router.get("/api/order/getOrder/:orderId", async (req, res) => {
//     try {
//         const orderId: string = req.params.orderId;
//         const orderDocRef = db.ordersCollection.doc(orderId);
//         const order = orderFromDoc(await orderDocRef.get());
//         return res.status(200).send({status: "Success", data: order.toMap()})
//     } catch (error) {
//         log(error);
//         return res.status(500).send({status: "Failed", msg: error.message});
//     }
// });

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


export function getDeliveryCostInCents(deliveryOptions, user, subtotal) {
    console.log(deliveryOptions);
    console.log("Delivery " + user.deliveryCost);
    console.log("Shippin " + user.shippingCost);
  
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
