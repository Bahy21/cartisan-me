import { log } from "firebase-functions/logger";
import * as db from "../../../../services/database";
import { userFromDoc } from "../../../../services/functions";
import * as express from "express";
const router = express.Router();


router.put("/api/post/likePost/:userId/:postId", async (req, res) => {
    try {
        const userId = req.params.userId;
        const postId = req.params.postId;
        const likesRef = db.likesCollection(postId); 
        await likesRef.doc(userId).set({"timestamp": Date.now()});
        return res.status(200).send({status: "Success", msg: `${userId} liked ${postId}`}); 
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});
  
router.delete("/api/post/unlikePost/:userId/:postId", async (req, res) => {
    try {
        const userId = req.params.userId;
        const postId = req.params.postId;
        const likesRef = db.likesCollection(postId); 
        await likesRef.doc(userId).delete();
        return res.status(200).send({status: "Success", msg: `${userId} unliked ${postId}`}); 
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});
router.get("/api/post/isLiked/:userId/:postId", async (req, res) => {
    try {
        const userId = req.params.userId;
        const postId = req.params.postId;
        const likesRef = db.likesCollection(postId); 
        const doc = await likesRef.doc(userId).get();
        if(doc.exists){
            return res.status(200).send({status: "Success", liked: true});
        } else {
            return res.status(200).send({status: "Success", liked: false});
        }
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});
router.get("/api/post/getLikes/:postId", async (req, res) => {
    try {
        const postId:string = req.params.postId;
        const lastLikedUserId:string = req.body.lastLikedUserId;
        const likesRef = db.likesCollection(postId); 
        let docs;
        if(lastLikedUserId == null){
            docs = await likesRef.orderBy("timestamp", "desc").where("liked", "==", true).limit(10).get();
        } else {
            const startAt = await likesRef.doc(lastLikedUserId).get();
            docs = await likesRef.orderBy("timestamp", "desc").where("liked", "==", true).startAfter(startAt).limit(10).get();
        }
        let likesList:string[] = <string[]>[]
        docs.docs.map((doc)=>{
            likesList.push(doc.id);
        });
        let usersWhoLiked;
        likesList.map(async (userId)=>{
            const userRef = db.userCollection.doc(userId);
            const userDoc = await userRef.get();
            if(userDoc.exists){
                usersWhoLiked.push(userFromDoc(userDoc).toMap());
            }});
        
        return res.status(200).send({status: "Success", data: usersWhoLiked});
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});


module.exports = router;