import { NotificationType } from "../../../../models/enums";
import { NotificationModel } from "../../../../models/notification_model";
import * as db from "../../../../services/database";
import * as functions from "firebase-functions";
import { userFromDoc } from "../../../../services/functions";
import { log } from "firebase-functions/logger";
import * as admin from 'firebase-admin';
import { sendPushPushNotification } from "../social/follow/following_triggers";

exports.onNewChatRoomCreated = functions
    .firestore
    .document("chatRooms/{chatRoomId}")
    .onCreate(async (snap, context) => {
        try {
            const chatRoomId = context.params.chatRoomId;
            const chatRoomDoc = db.chatRoomCollection.doc(chatRoomId);
            const chatRoomSnapshot = await chatRoomDoc.get();
            const chatRoom = chatRoomSnapshot.data();
            const userIds: string[] = chatRoom.participants;
            const createdBy = chatRoom.createdBy;
            const receiverId = userIds.filter(id => id != createdBy)[0];
            log('receiverId for notification', receiverId);
            const senderId = createdBy;
            const senderReference = db.userCollection.doc(senderId);
            const receiverReference = db.userCollection.doc(receiverId);
            const senderDoc = await senderReference.get();
            const receiverDoc = await receiverReference.get();
            const sender = userFromDoc(senderDoc);
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
            const notificationId = db.userNotificationCollection(receiverId).doc().id;
    
            newNotification.notificationId = notificationId;        
            await db.userNotificationCollection(receiverId).doc(notificationId).set(newNotification.toMap());
            await sendPushPushNotification({
                receiverDoc: receiverReference,
                alertHeading: "New Chat",
                alertMessage: "You have a new chat",
            });
        } catch (error) {
            log('error in messaging trigger', error);  
        }
    });