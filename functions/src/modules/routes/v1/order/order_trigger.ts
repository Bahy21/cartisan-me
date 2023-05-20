import { OrderModel } from "../../../../models/order_model";
import * as db from "../../../../services/database";
import * as functions from "firebase-functions";
import { orderFromDoc, userFromDoc } from "../../../../services/functions";
import { log } from "firebase-functions/logger";
import * as admin from 'firebase-admin';
import { sendPushPushNotification } from "../social/follow/following_triggers";
import { NotificationModel } from "../../../../models/notification_model";
import { NotificationType } from "../../../../models/enums";

exports.onNewOrderCreated = functions
    .firestore
    .document("orders/{orderId}")
    .onCreate(async (snap, context) => {
        try {
            const orderId = context.params.orderId;
            const orderDoc = db.ordersCollection.doc(orderId);
            const orderSnapshot = await orderDoc.get();
            
            const order = orderFromDoc(orderSnapshot);
            const sellerIds: string[] = order.involvedSellersList;
            const buyerId = order.buyerId;
            const senderId = buyerId;
            const senderReference = db.userCollection.doc(senderId);
            const senderDoc = await senderReference.get();
            const sender = userFromDoc(senderDoc);
            for(const seller of sellerIds){
                const receiverReference = db.userCollection.doc(seller);
                const receiverDoc = await receiverReference.get();
                const receiver = userFromDoc(receiverDoc);
                const newNotification = new NotificationModel({
                    notificationId: '',
                    ownerId: sender.id,
                    userId: receiver.id,
                    timestamp: Date.now(),
                    username: sender.profileName,
                    type: NotificationType.message,
                    userProfileImg: sender.url,
                });
                const notificationId = db.userNotificationCollection(seller).doc().id;
        
                newNotification.notificationId = notificationId;        
                await db.userNotificationCollection(seller).doc(notificationId).set(newNotification.toMap());
                await sendPushPushNotification({
                    receiverDoc: receiverReference,
                    alertHeading: "New Order",
                    alertMessage: "You have a new order",
                });
            } 
        } catch (error) {
            log('error in messaging trigger', error);  
        }

    });
