import { log } from "firebase-functions/logger";
import * as db from "../../../../../services/database";
import * as express from "express";
const router = express.Router();

// block user
router.put("/api/social/blockUser/:blockerId/:blockedId", async(req,res) => {
    try {
      const blockerId: string = req.params.blockerId;
      const blockedId: string = req.params.blockedId;
      await db.userBlockedUsersCollection(blockerId).doc(blockedId).set({
        blocked: true,
        timsestamp: Date.now()
      })
      return res.status(200).send({status: "Success", data: `User ${blockedId} succesfully blocked by ${blockerId}`});
    } catch (error) {
      log(error);
      return res.status(500).send({status: "Failed", msg: error.message});
    }
  });
  
  // unblock user
  router.delete("/api/social/unblockUser/:blockerId/:blockedId", async(req,res) => {
    try {
      const blockerId: string = req.params.blockerId;
      const blockedId: string = req.params.blockedId;
      await db.userBlockedUsersCollection(blockerId).doc(blockedId).delete();
      return res.status(200).send({status: "Success", data: `User ${blockedId} succesfully unblocked by ${blockerId}`});
    } catch (error) {
      log(error);
      return res.status(500).send({status: "Failed", msg: error.message});
    }
  });
  
  // is user blocked
  router.get("/api/social/isBlocked/:blockerId/:blockedId", async(req,res) => {
    try {
      const blockerId: string = req.params.blockerId;
      const blockedId: string = req.params.blockedId;
      const blocked1 = await db.userBlockedUsersCollection(blockerId).doc(blockedId).get();
      if(blocked1.exists){
        return res.status(200).send({status: true, data: `User ${blockedId} is blocked by ${blockerId}`});
      } else {
        return res.status(500).send({status: false, data: `User ${blockedId} is not blocked by ${blockerId}`});
      }
    } catch (error) {
      log(error);
      return res.status(500).send({status: "Failed", msg: error.message});
    }
  });

// get block list
router.get("/api/social/getBlockList/:userId", async(req,res)=>{
    try {
      let blockList:string[] = <string[]>[];
      const userId:string = req.params.userId;
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
      return res.status(200).send({status: "Success", data: blockList});
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
   });

module.exports = router;