import admin = require("firebase-admin");

const db = admin.firestore();

export const userCollection = db.collection("users");
export const allUserAddresses = (userId: string) => userCollection.doc(userId).collection("addresses");
export const userBlockedUsersCollection = (userId: string) => userCollection.doc(userId).collection("blockedUsers");
export const userFollowingCollection = (userId: string) => userCollection.doc(userId).collection("userFollowing");
export const userFollowersCollection = (userId: string) => userCollection.doc(userId).collection("userFollowers");
export const userCartCollection = (userId: string) => userCollection.doc(userId).collection("cart");
export const userNotificationCollection = (userId: string) => userCollection.doc(userId).collection("notifications");

export const postsCollection = db.collection("posts");
export const reviewCollection = (postId:string) => postsCollection.doc(postId).collection("reviews");
export const likesCollection = (postId:string) => postsCollection.doc(postId).collection("likes");
export const commentsCollection = (postId:string) => postsCollection.doc(postId).collection("comments");


// export const notificationsCollection = db.collection("notifications");
export const ordersCollection = db.collection("orders");
export const activeCartCollectionGroup = db.collectionGroup("cart");
export const userReportsCollection = db.collection("userReport");

export const errorReportReference = db.collection("errorReports");

export const addCardtoUser = () => console.error("Not  implemeted yet");
