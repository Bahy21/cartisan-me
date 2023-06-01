
import { getUser, postFromDoc } from "../../../../services/functions";
import * as db from "../../../../services/database";
import { CollectionReference, QuerySnapshot } from "firebase-admin/firestore";
import * as express from "express";
import { PostResponse } from "../../../../models/post_response";
import logger from "../../../../services/logger";
import { log } from "firebase-functions/logger";
import { user } from "firebase-functions/v1/auth";
import { likesCollection } from "../../../../services/database";
const router = express.Router();

// fetch timeline posts
router.get("/api/timeline/fetchPosts/:userId/:count", async(req,res)=>{
  try {
   
    const userId: string = req.params.userId;
    const count: number = parseInt(req.params.count);
    let lastPostId = req.query.lastPostId;
    if(lastPostId == null || lastPostId == ""){
      lastPostId = '';
    } else {
      lastPostId = lastPostId.toString();
    }
    const postRef: CollectionReference = db.postsCollection;
    let queryDocs: QuerySnapshot;
    if (lastPostId == null || lastPostId == ''){
      queryDocs  = await postRef.where('archived',"==",false).orderBy("timestamp","desc").limit(count).get();
    } else {
      const startAt = await postRef.doc(lastPostId).get();
      queryDocs  = await postRef.where('archived',"==",false).orderBy("timestamp","desc").startAt(startAt).limit(count).get();
    }
    let blockList:string[] = <string[]>[];
    const data = await db.userBlockedUsersCollection(userId).get();
    for(const doc of data.docs){
      blockList.push(doc.ref.id);
    }
    let resultDocs = queryDocs.docs.filter((doc)=> !blockList.includes(doc.data().ownerId));
    const postList = resultDocs.map((doc)=> postFromDoc(doc));
    let likes = {};
    for (const post of postList ){
      const liked = await likesCollection(post.postId).doc(userId).get();
      likes[post.postId] = liked.exists; 
    }
    
    const responseResult = <PostResponse[]>[];
    for (const post of postList){
      const owner = await getUser(post.ownerId);
      responseResult.push(new PostResponse({post: post, user: owner}));
    } 
    return res.status(200).send({status: "Success", result: responseResult,likes: likes});
  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
  }
});
  


module.exports = router;