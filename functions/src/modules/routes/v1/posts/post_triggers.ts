import { firestore } from "../../../..";
import * as db from "../../../../services/database";
import * as functions from "firebase-functions";
import { userFromDoc } from "../../../../services/functions";
import { NotificationType } from "../../../../models/enums";
import { NotificationModel } from "../../../../models/notification_model";
import { postsCollection } from "../../../../services/database";

exports.onArchivePost = functions
    .firestore
    .document("posts/{postId}")
    .onUpdate(async (snap, context) => {
        if(snap.after.data()!.archived === false){
            return;
        }
        const postId = context.params.postId;
        const batch = firestore.batch();
        const allToBeRemoved = await db.activeCartCollectionGroup.where("postId", "==", postId).get();
        allToBeRemoved.forEach(async (cartItem) =>{
            await cartItem.ref.delete();
        });
        await batch.commit();

    });
exports.onPostLiked = functions
    .firestore
    .document("posts/{postId}/likes/{userId}")
    .onCreate(async (snap, context) => {
        const postId = context.params.postId;
        const postRef = db.postsCollection.doc(postId);
        const post = await postRef.get();
        const likesCount = post.data().likesCount;
        await postRef.update({"likesCount": likesCount + 1});
        const userWhoLikedId = context.params.userId;
        const notifId = `${userWhoLikedId}_${postId}_like`
        const notifRef = await db.userNotificationCollection(userWhoLikedId).doc(notifId).get();
        if(notifRef.exists){
            return;
        }
        const userWhoLiked = userFromDoc(await db.userCollection.doc(userWhoLikedId).get());

        const newNotification = new NotificationModel({
            notificationId: notifId,
            ownerId: post.data().ownerId,
            userId: userWhoLiked.id,
            timestamp: Date.now(),
            username: userWhoLiked.username,
            type: NotificationType.like,
            userProfileImg: userWhoLiked.url ?? '',
        });
        newNotification.postId = postId;
        await db.userNotificationCollection(userWhoLiked.id).add(newNotification.toMap());

});
exports.onPostUnliked = functions
    .firestore
    .document("posts/{postId}/likes/{userId}")
    .onDelete(async (snap, context) => {
        const postId = context.params.postId;
        const postRef = db.postsCollection.doc(postId);
        const post = await postRef.get();
        const likesCount = post.data().likesCount;
        await postRef.update({"likesCount": likesCount == 0 ? 0 :likesCount - 1});
    });
exports.onPostCommented = functions
    .firestore
    .document("posts/{postId}/comments/{userId}")
    .onCreate(async (snap, context) => {
        const postId = context.params.postId;
        const postRef = db.postsCollection.doc(postId);
        const post = await postRef.get();
        const commentCount = post.data().commentCount;
        await postRef.update({"commentCount": commentCount + 1});
    });
exports.onPostCommentDeleted = functions
    .firestore
    .document("posts/{postId}/comments/{userId}")
    .onDelete(async (snap, context) => {
        const postId = context.params.postId;
        const postRef = db.postsCollection.doc(postId);
        const post = await postRef.get();
        const commentCount = post.data().commentCount;
        await postRef.update({"commentCount": commentCount == 0 ? 0 :commentCount - 1});
    });
exports.onPostReviewAdded = functions
    .firestore
    .document("posts/{postId}/reviews/{reviewId}")
    .onCreate(async (snap, context) => {
        const postId = context.params.postId;
        const postRef = postsCollection.doc(postId);
        const post = await postRef.get();
        const reviewCount = post.data().reviewCount;
        await postRef.update({"reviewCount": reviewCount + 1});
        const reviewId = context.params.reviewId;
        const reviewMap = snap.data();
        const userWhoReviewedId = reviewMap.reviewerId;
        const userWhoReviewed = userFromDoc(await db.userCollection.doc(userWhoReviewedId).get());
        const postOwnerId = post.data().ownerId;
        const newNotification = new NotificationModel({
            notificationId: '',
            ownerId: postOwnerId,
            userId: reviewMap.reviewerId,
            timestamp: Date.now(),
            username: userWhoReviewed.username,
            type: NotificationType.review,
            userProfileImg: userWhoReviewed.url ?? '',
        });
        newNotification.postId = postId;
        newNotification.reviewId = reviewId;
        await db.userNotificationCollection(postOwnerId).add(newNotification.toMap());
        
    });