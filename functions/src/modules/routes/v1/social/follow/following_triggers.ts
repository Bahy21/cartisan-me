import { NotificationType } from "../../../../../models/enums";
import { NotificationModel } from "../../../../../models/notification_model";
import * as db from "../../../../../services/database";
import * as functions from "firebase-functions";
import { userFromDoc } from "../../../../../services/functions";

import * as admin from 'firebase-admin';
import logger from "../../../../../services/logger";
exports.onNewFollower = functions
    .firestore
    .document("users/{userId}/userFollowers/{followerId}")
    .onCreate(async (snap, context) => {
        const userId = context.params.userId;
        const followerId = context.params.followerId;
        logger.info(`${followerId} is now following ${userId}`)
        const userDoc = db.userCollection.doc(userId);
        const followerDoc = db.userCollection.doc(followerId);
        await userDoc.update({"followerCount": admin.firestore.FieldValue.increment(1)});
        await followerDoc.update({"followingCount": admin.firestore.FieldValue.increment(1)});
        await sendToNotifications(followerDoc, userId);
        await sendPushPushNotification({
            receiverDoc: userDoc,
            alertHeading: "New Follower",
            alertMessage: "You have a new follower",
        });
    });


async function sendToNotifications( 
    followerDoc :FirebaseFirestore.DocumentReference<FirebaseFirestore.DocumentData>, 
    followedId:string,){
   try {
    var userSnapshot=await followerDoc.get();
    const follower = userFromDoc(userSnapshot);
    const newNotification = new NotificationModel({
        notificationId: '',
        ownerId: userSnapshot.id,
        userId: followedId,
        timestamp: Date.now(),
        username: follower.profileName,
        type: NotificationType.follow,
        userProfileImg: follower.url,
    });
    const notificationId = db.userNotificationCollection(followedId).doc().id;
    newNotification.notificationId = notificationId;
    await db.userNotificationCollection(followedId).doc(notificationId).set(newNotification.toMap());
   
   } catch (error) {
    logger.info('error', error);
   }
    
 } 
 
 export async function sendPushPushNotification(
    {receiverDoc, alertHeading, alertMessage}:
    {
        receiverDoc :FirebaseFirestore.DocumentReference<FirebaseFirestore.DocumentData>;
        alertHeading: string;
        alertMessage: string;
    }){
        try {
        const tokensdoc = await receiverDoc.get();
        const body = alertMessage;
        let title = alertHeading;
        const message = {
            token: (tokensdoc as FirebaseFirestore.DocumentData)
                .data()
                .androidNotificationToken,
            data: {
                body: body,
                clickAction: "FLUTTER_NOTIFICATION_CLICK",
                title: title,
                sound: "default",
            },
            };
            logger.info('message', message);
            await admin.messaging().send(message).then((response) => {
                logger.info('Successfully sent message:', response);
            });
            } catch (e) {
            logger.info(e);
            }
    }
exports.onUnfollowing = functions
    .firestore
    .document("users/{userId}/userFollowers/{followerId}")
    .onDelete(async (snap, context) => {
        const userId = context.params.userId;
        const followerId = context.params.followerId;
        const userDoc = db.userCollection.doc(userId);
        const followerDoc = db.userCollection.doc(followerId);
        const userDocData = await userDoc.get();
        const followerDocData = await followerDoc.get();
        const followerCount = userDocData.data().followerCount;
        const followingCount = followerDocData.data().followingCount;
        await userDoc.update({"followerCount": followerCount == 0 ? 0 : admin.firestore.FieldValue.increment(-1)});
        await followerDoc.update({"followingCount": followingCount == 0 ? 0 : admin.firestore.FieldValue.increment(-1)});
        
    });