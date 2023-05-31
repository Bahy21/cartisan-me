
import { postFromDoc } from "../../../../services/functions";
import * as db from "../../../../services/database";
import { CollectionReference, QuerySnapshot } from "firebase-admin/firestore";
import * as express from "express";
import { SearchResult } from "../../../../models/search_result";
import logger from "../../../../services/logger";
import { log } from "firebase-functions/logger";
const router = express.Router();

// fetch timeline posts
router.get("/api/search/fetchPosts/:userId/:count", async(req,res)=>{
  try {
    
    const userId: string = req.params.userId;
    const count: number = parseInt(req.params.count);
    const lastPostId = req.query.lastPostId;
    const postRef: CollectionReference = db.postsCollection;
    let queryDocs: QuerySnapshot;
    if (lastPostId == null || lastPostId == undefined || lastPostId == ""){
      queryDocs  = await postRef.where('archived',"==",false).orderBy("timestamp","desc").limit(count).get();
    } else {
      const startAt = await postRef.doc(lastPostId.toString()).get();
      const startPost = postFromDoc(startAt);
        queryDocs  = await postRef.where('archived',"==",false).orderBy("timestamp","desc").startAfter(startPost.timestamp).limit(count).get();
    }
    let blockList:string[] = <string[]>[];
    const data = await db.userBlockedUsersCollection(userId).get();
    for(const doc of data.docs){
      blockList.push(doc.ref.id);
    }

    let resultDocs = queryDocs.docs.filter((doc)=> !blockList.includes(doc.data().ownerId));
    
    const postList = resultDocs.map((doc)=> postFromDoc(doc));
    const searchResults = postList.map((post)=> new SearchResult({postId: post.postId, imageUrl: post.images[0]}));
    const result = Array.from(searchResults);
    return res.status(200).send({status: "Success", result});

  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
  }
});
  


module.exports = router;