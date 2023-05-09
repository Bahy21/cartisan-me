import { firestore } from "../../../..";
import * as db from "../../../../services/database";
import * as functions from "firebase-functions";

exports.onDeletePost = functions
    .firestore
    .document("posts/{postId}")
    .onDelete(async (snap, context) => {
        const postId = context.params.postId;
        const batch = firestore.batch();
        const allToBeRemoved = await db.activeCartCollectionGroup.where("postId", "==", postId).get();
        allToBeRemoved.forEach(async (cartItem) =>{
            await cartItem.ref.delete();
        });
        const likesCollectionRef = db.likesCollection(postId);
        const likesGotten = await likesCollectionRef.get();
        for(const likeGotten of likesGotten.docs){
            await likeGotten.ref.delete();
        }
        const commentsCollectionRef = db.commentsCollection(postId);
        const commentsGotten = await commentsCollectionRef.get();
        for(const commentGotten of commentsGotten.docs){
            await commentGotten.ref.delete();
        }
        const reviewsCollectionRef = db.reviewCollection(postId);
        const reviewsGotten = await reviewsCollectionRef.get();
        for(const reviewGotten of reviewsGotten.docs){
            await reviewGotten.ref.delete();
        }
        await batch.commit();

    });
exports.onPostLiked = functions
    .firestore
    .document("posts/{postId}/likes/{userId}")
    .onCreate(async (snap, context) => {
        const postId = context.params.postId;
        const postRef = db.postsCollection.doc(postId);
        const post = await postRef.get();
        const likesCount = post.get("likesCount");
        await postRef.update({"likesCount": likesCount + 1});
});
exports.onPostUnliked = functions
    .firestore
    .document("posts/{postId}/likes/{userId}")
    .onDelete(async (snap, context) => {
        const postId = context.params.postId;
        const postRef = db.postsCollection.doc(postId);
        const post = await postRef.get();
        const likesCount = post.get("likesCount");
        await postRef.update({"likesCount": likesCount - 1});
    });
exports.onPostCommented = functions
    .firestore
    .document("posts/{postId}/comments/{userId}")
    .onCreate(async (snap, context) => {
        const postId = context.params.postId;
        const postRef = db.postsCollection.doc(postId);
        const post = await postRef.get();
        const commentCount = post.get("commentCount");
        await postRef.update({"commentCount": commentCount + 1});
    });
exports.onPostCommentDeleted = functions
    .firestore
    .document("posts/{postId}/comments/{userId}")
    .onDelete(async (snap, context) => {
        const postId = context.params.postId;
        const postRef = db.postsCollection.doc(postId);
        const post = await postRef.get();
        const commentCount = post.get("commentCount");
        await postRef.update({"commentCount": commentCount - 1});
    });
exports.onPostReviewAdded = functions
    .firestore
    .document("posts/{postId}/reviews/{userId}")
    .onDelete(async (snap, context) => {
        const postId = context.params.postId;
        const postRef = db.postsCollection.doc(postId);
        const post = await postRef.get();
        const reviewCount = post.get("reviewCount");
        await postRef.update({"reviewCount": reviewCount + 1});
    });