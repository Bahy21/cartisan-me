import { log } from "firebase-functions/logger";
import * as db from "../../../../services/database";
import { commentFromDoc } from "../../../../services/functions";
import { CommentModel } from "../../../../models/comment_model";
import { QuerySnapshot } from "firebase-admin/firestore";
import * as express from "express";
const router = express.Router();

router.get("/api/post/comments/getComments/:postId", async (req, res) => {
    try {
        const postId: string = req.params.postId;
        const lastCommentId: string = req.body.lastCommentId;
        const commentsRef = db.commentsCollection(postId); 
        let commentList:CommentModel[] =<CommentModel[]>[]
        let queryDocs: QuerySnapshot;
        if(lastCommentId == null){
            queryDocs = await commentsRef.orderBy("timestamp", "desc").limit(10).get()
        } else {
            const startAt = await commentsRef.doc(lastCommentId).get();
            queryDocs = await commentsRef.orderBy("timestamp","desc").startAfter(startAt).limit(10).get();
        }
        queryDocs.docs.map((doc)=>{
            commentList.push(commentFromDoc(doc));
        });
        return res.status(200).send({status: "Success", data: commentList});
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});

router.post("/api/post/comments/newComment/:postId", async (req, res) => {
    try {
        const postId: string = req.params.postId;
        const userId: string = req.body.userId;
        const comment: string = req.body.comment;
        const username: string = req.body.username;
        const url: string = req.body.url;
        const commentDocRef = db.commentsCollection(postId).doc();
        var commentId=commentDocRef.id;
        const newComment = new CommentModel({username: username, userId: userId, comment: comment, url: url, timestamp: Date.now(), commentId: commentId});
      
        newComment.commentId = commentId;
        await commentDocRef.set(newComment);
        return res.status(200).send({status: "Success", data: `Comment ${newComment.commentId} added to ${postId} successfully`});
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});

router.delete("/api/post/comments/deleteComment/:postId/:commentId", async (req, res) => {
    try {
        const postId: string = req.params.postId;
        const commentId: string = req.params.commentId;
        const commentDoc = db.commentsCollection(postId).doc(commentId);
        const comment = await commentDoc.get();
        if(!comment.exists){
            return res.status(500).send({status: "Failed", msg: `Comment ${commentId} does not exist`});
        }
        await commentDoc.delete();
        return res.status(200).send({status: "Success", data: `Comment ${commentId} successfully deleted`});
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});

module.exports = router;