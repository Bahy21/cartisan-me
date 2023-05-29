
import { getUserFromPost, postFromDoc } from "../../../../services/functions";
import * as db from "../../../../services/database";
import { CollectionReference, QuerySnapshot } from "firebase-admin/firestore";
import * as express from "express";
import { PostResponse } from "../../../../models/post_response";
import logger from "../../../../services/logger";
import { log } from "firebase-functions/logger";
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
      queryDocs  = await postRef.orderBy("timestamp","desc").where('archived',"==",false).limit(count).get();
    } else {
      const startAt = await postRef.doc(lastPostId).get();
      queryDocs  = await postRef.orderBy("timestamp","desc").startAt(startAt).where('archived',"==",false).limit(count).get();
    }
    let blockList:string[] = <string[]>[];
    await db
      .userBlockedUsersCollection(userId)
      .get()
      .then(
        (data)=>{
          let docs = data.docs;
          docs.map((doc)=>{
            blockList.push(doc.ref.id);
          });
        });

    let resultdocs = queryDocs.docs.filter((doc)=> !blockList.includes(doc.id));
    
    const postList = resultdocs.map((doc)=> postFromDoc(doc));
    const responseResult = <PostResponse[]>[];
    for (const post of postList){
      const owner = await getUserFromPost(post.ownerId);
      responseResult.push(new PostResponse({post: post, user: owner}));
    } 
    return res.status(200).send({status: "Success", result: responseResult});
  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
  }
});
  


module.exports = router;