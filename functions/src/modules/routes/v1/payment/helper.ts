import admin = require("firebase-admin");
import * as functions from "firebase-functions";
import { stripe, stripeApiVersion } from "../../../../utils/config";
import Stripe from "stripe";
import { OrderModel } from "../../../../models/order_model";
import { OrderItemStatus } from "../../../../models/enums";
import { OrderItemModel } from "../../../../models/order_item_model";
import * as db from "../../../../services/database";
import { Transaction, TransactionStatus } from "../../../../models/transaction_model";
import logger from "../../../../services/logger";
import { transactionFromDocData } from "../../../../services/functions";
const cartisanStripeAccount = "acct_1Hga2kLRbI5gjrlU";
export async function updateTransactionStatus(
    id: string,
    status: number,
    updates?: {}
  ) {
    await admin
      .firestore()
      .collection("transactions")
      .doc(id)
      .update({
        status: status,
        ...updates,
      });
  }
  
  export async function getStripePaymentInfo(paymentIntentId: string) {
    const paymentIntent = await stripe.paymentIntents.retrieve(paymentIntentId, {
      expand: ["charges.data.balance_transaction"],
    });
    const fee = (
      paymentIntent.charges.data[0]
        .balance_transaction as Stripe.BalanceTransaction
    ).fee;
    const feePercentage = fee / paymentIntent.amount;
    return {
      feePercentage,
      chargeId: paymentIntent.charges.data[0].id,
      recieptUrl: paymentIntent.charges.data[0].receipt_url,
    };
  }
  
  export async function updateOrderItemStatus(
    order: OrderModel,
    orderItemId: any,
    status: OrderItemStatus
  ) {
    const orderItem: OrderItemModel = order.orderItems.find(
      (item) => item.orderItemID === orderItemId
    );
    if (!orderItem) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "Order item not found"
      );
    }
    orderItem.status = status.valueOf();
    await admin.firestore().collection("orders").doc(order.orderId).update({
      orderItems: order.orderItems,
    });
    return orderItem;
  }
  
  export async function getTransactionByOrderId(orderId: any) {
    const result = await admin
      .firestore()
      .collection("transactions")
      .where("orderId", "==", orderId)
      .get();
    if (!result.docs.length) {
      return null;
    }
    return transactionFromDocData(result.docs[0].data());
  }
  
  export async function getOrderById(orderId: any) {
    return (
      await admin.firestore().collection("orders").doc(orderId).get()
    ).data() as OrderModel;
  }
  
  export async function updateOrderStatus(
    order: FirebaseFirestore.DocumentData,
    orderStatus: number,
    update?: {}
  ) {
    order.orderItems.forEach((orderItem: OrderItemModel) => {
      orderItem.status = orderStatus;
    });
  
    logger.info("updating..");
  
    const data = {
      orderItems: order.orderItems,
      ...update,
    };
    logger.info(JSON.stringify(data));
    try {
      await admin.firestore().collection("orders").doc(order.orderId).set(data,{merge:true});
      logger.info("updated");
    } catch (e) {
     logger.info(e);
    }
  
  }
  
  export async function updateOrCreateTranasction(
    order: FirebaseFirestore.DocumentData,
    paymentIntent: Stripe.Response<Stripe.PaymentIntent>,
    data: any
  ) {
    let transaction = await getTransactionByOrderId(order.orderId);
    if (!transaction) {
      transaction = {
        paymentDetail: paymentIntent,
        buyerId: order.buyerId,
        orderId: order.orderId,
        amountInCents: order.totalInCents,
        id: admin.firestore().collection("transactions").doc().id,
        createdAt: Date.now(),
        currency: data.currency ?? "usd",
        paymentMethod: "stripe",
        status: TransactionStatus.PENDING,
      };
      await admin
        .firestore()
        .collection("transactions")
        .doc(transaction.id)
        .set(transaction);
    } else {
      await admin
        .firestore()
        .collection("transactions")
        .doc(transaction.id)
        .update({
          paymentDetail: paymentIntent,
        });
    }
  }
  
  export async function getOrCreateCustomer(buyer: FirebaseFirestore.DocumentData) {
    const customers = await stripe.customers.list({ email: buyer.email });
    let customer: Stripe.Customer;
    if (customers.data.length) {
      logger.info("found customer");
      customer = customers.data[0];
    } else {
      customer = await stripe.customers.create({
        email: buyer.email,
        description: buyer.profileName,
        address: {
          country: buyer.country,
          line1: buyer.addressLine1,
          line2: buyer.addressLine2,
          city: buyer.city,
          state: buyer.state,
        },
      });
    }
    return customer;
  }
  
  export async function onPaymentFailed(event: Stripe.Event) {
    const data = event.data.object as any;
    const transaction = await getTransactionByOrderId(data.transfer_group);
    if (transaction) {
      await updateTransactionStatus(
        transaction.id,
        TransactionStatus.FAILED.valueOf()
      );
    }
  }
  
  export async function onPaymentSucceeded(event: Stripe.Event) {
    const data = event.data.object as any;
    const order = await getOrderById(data.transfer_group);
    if (order.isPaid) {
      return;
    }
    const { feePercentage, chargeId, recieptUrl } = await getStripePaymentInfo(
      data.id
    );
    const transfers = [];
    //Iterate for each order item and send the seller a transfer
    for (const orderItem of order.orderItems) {
     
      const stripeFee = Math.round(orderItem.grossTotalInCents * feePercentage);
      const payable = parseInt(
        `${orderItem.grossTotalInCents - orderItem.appFeeInCents - stripeFee}`
      );
      logger.info(`Paying out ${payable} to ${orderItem.sellerStripeId}`);
      if (orderItem.sellerStripeId != cartisanStripeAccount) {
        const transfer = await stripe.transfers.create({
          amount: payable,
          currency: order.currency ?? "usd",
          destination: orderItem.sellerStripeId,
          source_transaction: chargeId,
          transfer_group: data.transfer_group,
        });
        transfers.push(transfer);
      }
    }
    await updateOrderStatus(
      order,
      OrderItemStatus.awaitingFulfillment.valueOf(),
      {
        isPaid: true,
      }
    );
    const transaction = await getTransactionByOrderId(data.transfer_group);
    if (transaction) {
      await updateTransactionStatus(
        transaction.id,
        TransactionStatus.SUCCESS.valueOf(),
        { receiptUrl: recieptUrl, chargeId: chargeId, transfers: transfers }
      );
    }
  }
  
  export async function onAccountUpdated(event: Stripe.Event) {
    const accountId = (event.data.object as any).id;
    const email = (event.data.object as any).email;
    const currentUser = await admin
      .firestore()
      .collection("users")
      .where("email", "==", email)
      .get();
    if (currentUser.docs.length) {
      await currentUser.docs[0].ref.update({
        sellerID: accountId,
      });
    }
  }
  