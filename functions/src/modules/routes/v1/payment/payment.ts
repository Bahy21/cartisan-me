import { log } from "firebase-functions/logger";
import * as db from "../../../../services/database";
import {  addressFromMap, cartItemFromMap, getOrderItemStatusFromString, userFromDoc } from "../../../../services/functions";
import { CollectionReference, DocumentReference } from "firebase-admin/firestore";
import { OrderItemModel } from "../../../../models/order_item_model";
import { OrderModel } from "../../../../models/order_model";
import * as express from "express";
import { CartItemModel } from "../../../../models/cart_item_model";
import { DeliveryOptions, OrderItemStatus } from "../../../../models/enums";
import { stripe, stripeApiVersion, stripeSecretKey } from "../../../../utils/config";
import { firestore } from "../../../..";
import Stripe from "stripe";
import { getOrCreateCustomer, getOrderById, getStripePaymentInfo, getTransactionByOrderId, updateOrCreateTranasction, updateOrderItemStatus, updateOrderStatus, updateTransactionStatus } from "./helper";
import { TransactionStatus } from "../../../../models/transaction_model";
import * as admin from "firebase-admin";
const cartisanStripeAccount = "acct_1Hga2kLRbI5gjrlU";
const router = express.Router();

router.get("/api/payment/stripe/getDashboardLink", async (req, res) => {
    try {
        const sellerId = req.query.sellerId;
        if(sellerId == null){
            return res.status(500).send({status: "Failed", msg: "sellerId is required"});
        }
        const sellerIdString = sellerId.toString();
        const value = await stripe.accounts.createLoginLink(sellerIdString);
        return res.status(200).send({status: "Success", data: value});
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});
router.get("/api/payment/stripe/checkIfStripeSetupIsComplete", async (req, res) => {
    try {
        const accountID = req.query.sellerId as any;
        if(accountID == null){
            return res.status(500).send({status: "Failed", msg: "sellerId is required"});
        }
        const value = await stripe.accounts.retrieveCapability(
            accountID,
            "card_payments"
        );
        if(value.status == "active"){
            return res.status(200).send({status: "Success", data: true});
        } else{
            return res.status(300).send({status: "Success", data: false});
        }
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});


router.post("/api/payment/stripe/createAccount", async (req, res) => {
    try {
        const emailFromQuery = req.query.email;
        const businessTypeFromQuery = req.query.business_type;
        const product_descriptionFromQuery = req.query.product_description;
        if(emailFromQuery == null || businessTypeFromQuery == null){
            return res.status(500).send({status: "Failed", msg: "email and business type is required"});
        }
        const email = emailFromQuery as any;
        const business_type = businessTypeFromQuery as any;
        const product_description = product_descriptionFromQuery as any;
        const account = await stripe.accounts.create({
            type: "express",
            business_type: business_type,
            email: email,
            business_profile: {
              product_description: product_description ?? "",
            },
            capabilities: {
              card_payments: { requested: true },
              transfers: { requested: true },
            },
          });
          const accountLink = await stripe.accountLinks.create({
            account: account.id,
            refresh_url: "https://cartisan.app/stripe/retry",
            return_url: "https://cartisan.app/stripe/success",
            type: "account_onboarding",
          });
        return res.status(200).send({status: "Success", data: accountLink});
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});


router.delete("/api/payment/stripe/deleteSellerAccount", async (req, res) => {
    try {
        const sellerId = req.query.sellerId;
        const userID = req.query.userId;
        if(sellerId == null || userID == null){
            return res.status(500).send({status: "Failed", msg: "sellerId and userId is required"});
        }
        const sellerID = sellerId as any;
        const userIdString = userID.toString();
        await stripe.accounts.del(sellerID);
        await db.userCollection.doc(userIdString).update({sellerID: ""});
        return res.status(200).send({status: "Success", data: "Not implemented yet"});
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});

router.delete("/api/payment/stripe/cancelItemAndRefund", async (req, res) => {
    try {
        const orderId = req.query.orderId;
        const orderItemId = req.query.orderItemId;
        const order = await getOrderById(orderId);
        const transaction = await getTransactionByOrderId(orderId);
        if (order && transaction) {
          const orderItem: OrderItemModel = await updateOrderItemStatus(
            order,
            orderItemId,
            OrderItemStatus.cancelled
          );
          const { feePercentage } = await getStripePaymentInfo(
            transaction.paymentDetail.id
          );
          const stripeFee = Math.round(orderItem.grossTotalInCents * feePercentage);
          const transfer = transaction.transfers.find(
            (transfer) => transfer.destination === orderItem.sellerStripeId
          );
      
          if (orderItem.sellerStripeId != cartisanStripeAccount) {
            // Reverse the transfer for the seller
            await stripe.transfers.createReversal(transfer.id, {
              amount: transfer.amount,
            });
            // Charge the seller the stripe fee
            await stripe.charges.create({
              amount: stripeFee,
              currency: "usd",
              source: orderItem.sellerStripeId,
            });
          }
      
          // Refund the customer the full amount
          await stripe.refunds.create({
            charge: transaction.chargeId,
            amount: transaction.amountInCents,
          });
      
          await updateOrderItemStatus(order, orderItemId, OrderItemStatus.refunded);
          await updateTransactionStatus(
            transaction.id,
            TransactionStatus.REFUNDED.valueOf()
          );
        }
        return res.status(200).send({status: "Success", data: "Successfully cancelled item and refunded"});
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});

router.post("/api/payment/stripe/createPaymentIntent", async(req,res) =>{
    try {
        const orderIDFromQuery = req.query.orderId;
        const currency = req.query.currency as any;
        const appFeeInCents = req.query.appFeeInCents as any;
        if (orderIDFromQuery==null) {
            return res.status(500).send({status: "Failed", msg: "Missing order ID"});
        }
        const orderID = orderIDFromQuery.toString();
        const order = (
            await admin.firestore().collection("orders").doc(orderID).get()
          ).data();
        
          const buyer = (
            await admin.firestore().collection("users").doc(order.buyerId).get()
          ).data();
        
          let customer: Stripe.Customer = await getOrCreateCustomer(buyer);
        
          const ephemeralKey = await stripe.ephemeralKeys.create(
            { customer: customer.id },
            { apiVersion: stripeApiVersion }
          );
        
          const paymentIntent = await stripe.paymentIntents.create({
            customer: customer.id,
            payment_method_types: ["card"],
            amount: parseInt(`${order.totalInCents}`),
            currency: currency ?? "usd",
            application_fee_amount: appFeeInCents,
            transfer_group: orderID,
            metadata: {
              buyerID: order.buyerId,
              orderID: orderID,
            },
            shipping: {
              name: "default",
              address: {
                state: order.address.state,
                city: order.address.city,
                line1: order.address.addressLine1,
                postal_code: order.address.postalCode,
                country: order.address.country,
              },
            },
          });
        
          await updateOrCreateTranasction(order, paymentIntent, {'currency': currency ?? "usd"});
        
          await updateOrderStatus(order, OrderItemStatus.awaitingPayment.valueOf());
          const output = {
            client_secret: paymentIntent.client_secret,
            ephemeralKey: ephemeralKey.secret,
            customer: customer.id,
          }; 
          return res.status(200).send({status: "Success", result: output});
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});