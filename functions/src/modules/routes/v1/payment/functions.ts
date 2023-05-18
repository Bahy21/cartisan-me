import admin = require("firebase-admin");
import * as functions from "firebase-functions";

import Stripe from "stripe";
import { stripe, stripeApiVersion } from "../../../../utils/config";
import { OrderItemStatus } from "../../../../models/enums";
import { OrderItemModel } from "../../../../models/order_item_model";
import { Transaction, TransactionStatus } from "../../../../models/transaction_model";
import { OrderModel } from "../../../../models/order_model";
const cartisanStripeAccount = "acct_1Hga2kLRbI5gjrlU";
//Allows seller to connect stripe express account
exports.connectStripeExpressAccount = functions.https.onCall(
  async (data, context) => {
    const account = await stripe.accounts.create({
      type: "express",
      business_type: data.business_type,
      email: data.email,
      business_profile: {
        product_description: data.product_description ?? "",
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
    return accountLink;
  }
);

// Dashboard Link for Seller"s Stripe
exports.getDashboardLink = functions.https.onCall(async (data, context) => {
  try {
    const value = await stripe.accounts.createLoginLink(data.sellerID);
    return value;
  } catch (error) {
    console.log("Error Creating Dashboard Link", error);
    return null;
  }
});

exports.webhook = functions.https.onRequest(async (req, res) => {
  let sig = req.headers["stripe-signature"];

  let event = req.body;


// let event=req.body;
//   await admin.firestore().collection("stripeEvents").add(event);
//   await admin.firestore().collection("orders").doc(event.data.object.transfer_group).set({StripeEvent:event.type},{merge:true}); 
// >>>>>>> e0972b536b34608877a5b3300f6b4082fd5d99f0
  // let event = stripe.webhooks.constructEvent(
  //   req.rawBody,
  //   sig,
  //   process.env.STRIPE_SIGNING_SECRET
  // );
  // if (!event) {
  //   return;
  // }
  // if(req.body. !==process.env.STRIPE_SIGNING_SECRET){
  //   // return ;
  //   // Verify the request against our endpointSecret

  // }

  if (
    event.type == "account.updated" &&
    (event.data.object as any).details_submitted
  ) {
    await onAccountUpdated(event);
  } else if (req.body.type == "payment_intent.succeeded") {
    await onPaymentSucceeded(event);
  } else if (req.body.type == "payment_intent.requires_payment_method") {
    await onPaymentFailed(event);
  }
  res.status(200).send();
});

exports.createPaymentIntent = functions.https.onCall(async (data, context) => {
  const order = (
    await admin.firestore().collection("orders").doc(data.orderID).get()
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
    currency: data.currency ?? "usd",
    application_fee_amount: data.appFeeInCents,
    transfer_group: data.orderID,
    metadata: {
      buyerID: order.buyerId,
      orderID: data.orderID,
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

  await updateOrCreateTranasction(order, paymentIntent, data);

  await updateOrderStatus(order, OrderItemStatus.awaitingPayment.valueOf());

  return {
    client_secret: paymentIntent.client_secret,
    ephemeralKey: ephemeralKey.secret,
    customer: customer.id,
  };
});

exports.getCapability = functions.https.onCall(async (data, context) => {
  try {
    const value = await stripe.accounts.retrieveCapability(
      data.accountID,
      "card_payments"
    );
    console.log(value);
    return value;
  } catch (error) {
    console.log("Error Creating Dashboard Link", error);
    return null;
  }
});

exports.deleteConnectAccount = functions.https.onCall(async (data, context) => {
  await stripe.accounts.del(data.sellerID);
  const currentUser = await admin
    .firestore()
    .collection("users")
    .doc(data.userID)
    .get();
  if (currentUser.exists) {
    await currentUser.ref.update({
      sellerID: null,
    });
  }
});

exports.cancelItemAndRefund = functions.https.onCall(async (data, context) => {
  const orderId = data.orderId;
  const orderItemId = data.orderItemId;
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
});

async function updateTransactionStatus(
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

async function getStripePaymentInfo(paymentIntentId: string) {
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

async function updateOrderItemStatus(
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
      "OrderModel item not found"
    );
  }
  orderItem.status = status.valueOf();
  await admin.firestore().collection("orders").doc(order.orderId).update({
    orderItems: order.orderItems,
  });
  return orderItem;
}

async function getTransactionByOrderId(orderId: any) {
  const result = await admin
    .firestore()
    .collection("transactions")
    .where("orderId", "==", orderId)
    .get();
  if (!result.docs.length) {
    return null;
  }
  return result.docs[0].data() as Transaction;
}

async function getOrderById(orderId: any) {
  return (
    await admin.firestore().collection("orders").doc(orderId).get()
  ).data() as OrderModel;
}

async function updateOrderStatus(
  order: FirebaseFirestore.DocumentData,
  orderStatus: number,
  update?: {}
) {
  order.orderItems.forEach((orderItem: OrderItemModel) => {
    orderItem.status = orderStatus;
  });

  console.log("updating..");

  const data = {
    orderItems: order.orderItems,
    ...update,
  };
  console.log(JSON.stringify(data));
  try {
    await admin.firestore().collection("orders").doc(order.orderId).set(data,{merge:true});
    console.log("updated");
  } catch (e) {
    console.log(e);
  }

}

async function updateOrCreateTranasction(
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

async function getOrCreateCustomer(buyer: FirebaseFirestore.DocumentData) {
  const customers = await stripe.customers.list({ email: buyer.email });
  let customer: Stripe.Customer;
  if (customers.data.length) {
    console.log("found customer");
    customer = customers.data[0];
  } else {
    customer = await stripe.customers.create({
      email: buyer.email,
      description: buyer.profileName,
      address: {
        country: buyer.country,
        line1: buyer.address,
        line2: buyer.address2,
        city: buyer.city,
        state: buyer.state,
      },
    });
  }
  return customer;
}

async function onPaymentFailed(event: Stripe.Event) {
  const data = event.data.object as any;
  const transaction = await getTransactionByOrderId(data.transfer_group);
  if (transaction) {
    await updateTransactionStatus(
      transaction.id,
      TransactionStatus.FAILED.valueOf()
    );
  }
}

async function onPaymentSucceeded(event: Stripe.Event) {
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

async function onAccountUpdated(event: Stripe.Event) {
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
