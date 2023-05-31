
import * as db from "../../../../services/database";
import { DocumentSnapshot, FieldValue } from "firebase-admin/firestore";
import { PostModel } from "../../../../models/post_model";
import { postFromDoc, reviewFromDoc, reviewFromDocData } from "../../../../services/functions";
import { ReviewModel } from "../../../../models/review_model";
import { firestore } from "../../../..";
import * as express from "express";
import { log } from "firebase-functions/logger";
import logger from "../../../../services/logger";
const router = express.Router();


// post review
router.post("/api/review/postReview/:postId", async(req,res)=>{
    try {
      const postId = req.params.postId;
      const postDocRef = db.postsCollection.doc(postId);
      const postModelSnap:DocumentSnapshot = await postDocRef.get();
      const postModel:PostModel = postFromDoc(postModelSnap);
      const reviewerID:string = req.body.reviewerID;
      const reviewId:string = req.body.reviewId;
      const reviewText:string = req.body.reviewText;
      const rating:number = req.body.rating;
      const reviewerName:string = req.body.reviewerName;
      const review = new ReviewModel({reviewerId: reviewerID, reviewText: reviewText, rating: rating, reviewerName: reviewerName, reviewId: ""});
      const docId = db.reviewCollection(postId).doc().id;
      review.reviewId = docId;
      const batch = firestore.batch();
      batch.set(db.reviewCollection(postId).doc(docId), review.toMap());
      batch.set(
        db.reviewCollection(postId).doc(docId), 
        {'timestamp': FieldValue.serverTimestamp()}, 
        {merge: true}
      );
  
      batch.update(postDocRef,{
        "rating": ((postModel.rating == null || Number.isNaN(postModel.rating)) ? 0 : postModel.rating + rating)/2,
        "reviewedBy": FieldValue.arrayUnion(reviewerID),
        "reviewCount": postModel.reviewCount ?? 0 + 1
      });
      await batch.commit();
      return res.status(200).send({status: "Success", data: `Review ${reviewId} succesfully posted to post ${postId}`});
    } catch (error) {
      log(error);
      return res.status(500).send({status: "Failed", msg: error.message});
    }
  });
// get 1 review
router.get("/api/review/getOneReview/:postId/:reviewId", async(req,res)=>{
  try {
    const reviewId = req.params.reviewId;
    const postId = req.params.postId;
    const reviewDoc = await db.reviewCollection(postId).doc(reviewId).get();
    const review = reviewFromDoc(reviewDoc);
    return res.status(200).send({status: "Success", data: review.toMap()});
  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
  }
});

// get all reviews paginated
router.get("/api/review/getAllReviews/:postId/:limit", async(req,res)=>{
  try {
    const postId = req.params.postId;
    const limit = parseInt(req.params.limit);
    const lastSentReviewId = req.query.lastSentReviewId;
    const reviews = <ReviewModel[]>[]
    if(lastSentReviewId == null || lastSentReviewId == undefined || lastSentReviewId.toString() == '')  {
      const reviewDoc = await db.reviewCollection(postId).orderBy('timestamp','desc').limit(limit).get();
      for(const review of reviewDoc.docs){
        reviews.push(reviewFromDocData(review.data()));
      }
    } else {
      const reviewDoc = await db.reviewCollection(postId).orderBy('timestamp','desc').limit(limit).get();
      for(const review of reviewDoc.docs){
        reviews.push(reviewFromDocData(review.data()));
      }
    }
    return res.status(200).send({status: "Success", data: reviews.map(review => review.toMap())});
  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
  }
});

module.exports = router;