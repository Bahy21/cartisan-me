import * as db from "../../../../../services/database";
import * as functions from "firebase-functions";
const admin = require("firebase-admin");
exports.onNewFollower = functions
    .firestore
    .document("users/{userId}/userFollowers/{followerId}")
    .onCreate(async (snap, context) => {
        const userId = context.params.userId;
        const followerId = context.params.followerId;
        const userDoc = db.userCollection.doc(userId);
        const followerDoc = db.userCollection.doc(followerId);
        userDoc.update({"followersCount": admin.firestore.FieldValue.increment(1)});
        followerDoc.update({"followingCount": admin.firestore.FieldValue.increment(1)});
        
    });
exports.onUnfollowing = functions
    .firestore
    .document("users/{userId}/userFollowers/{followerId}")
    .onDelete(async (snap, context) => {
        const userId = context.params.userId;
        const followerId = context.params.followerId;
        const userDoc = db.userCollection.doc(userId);
        const followerDoc = db.userCollection.doc(followerId);
        userDoc.update({"followersCount": admin.firestore.FieldValue.increment(-1)});
        followerDoc.update({"followingCount": admin.firestore.FieldValue.increment(-1)});
        
    });