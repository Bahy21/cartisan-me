import { log } from "firebase-functions/logger";
import { postFromDoc } from "../../../../services/functions";
import * as db from "../../../../services/database";
import { CollectionReference, QuerySnapshot } from "firebase-admin/firestore";
import * as express from "express";
const router = express.Router();

// fetch timeline posts
router.get("/api/timeline/fetchPosts/:userId/:count", async(req,res)=>{
  try {
    
    const userId: string = req.params.userId;
    const count: number = parseInt(req.params.count);
    const lastPostId: string = req.body.lastPostId;
    const postRef: CollectionReference = db.postsCollection;
    let queryDocs: QuerySnapshot;
    if (lastPostId == null){
      queryDocs  = await postRef.orderBy("timestamp","desc").limit(count).get();
    } else {
      const startAt = await postRef.doc(lastPostId).get();
        queryDocs  = await postRef.orderBy("timestamp","desc").startAfter(startAt).limit(count).get();
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
    const result = Array.from(postList);
    return res.status(200).send({status: "Success", result});

  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
  }
});
  


module.exports = router;