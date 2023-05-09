import { log } from "firebase-functions/logger";
import * as db from "../../../../services/database";
import { DocumentSnapshot, FieldValue } from "firebase-admin/firestore";
import { PostModel } from "../../../../models/post_model";
import { postFromDoc } from "../../../../services/functions";
import { ReviewModel } from "../../../../models/review_model";
import { firestore } from "../../../..";
import * as express from "express";
const router = express.Router();


// post review
router.post("/api/review/postReview/:postId", async(req,res)=>{
    try {
      const postId = req.params.postId;
      const postDocRef = db.postsCollection.doc(postId);
      const postModelSnap:DocumentSnapshot = await postDocRef.get();
      const postModel:PostModel = postFromDoc(postModelSnap);
      const reviewerID:string = req.body.reviewerID ?? "";
      const reviewId:string = req.body.reviewId ?? "";
      const reviewText:string = req.body.reviewText ?? "";
      const rating:number = req.body.rating ?? 0;
      const reviewerName:string = req.body.reviewerName ?? "";
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

module.exports = router;