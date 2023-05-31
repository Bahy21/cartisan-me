
import * as db from "../../../../../services/database";
import * as express from "express";
import logger from "../../../../../services/logger";
import { log } from "firebase-functions/logger";
import { UserModel } from "../../../../../models/user_model";
import { getUser, userFromDoc } from "../../../../../services/functions";
import { DocumentReference, DocumentSnapshot, QuerySnapshot } from "firebase-admin/firestore";
import { userCollection } from "../../../../../services/database";
const router = express.Router();

// block user
router.put("/api/social/blockUser/:blockerId/:blockedId", async(req,res) => {
    try {
      const blockerId: string = req.params.blockerId;
      const blockedId: string = req.params.blockedId;
      await db.userBlockedUsersCollection(blockerId).doc(blockedId).set({
        blocked: true,
        timestamp: Date.now()
      })
      return res.status(200).send({status: "Success", data: `User ${blockedId} successfully blocked by ${blockerId}`});
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
      return res.status(200).send({status: "Success", data: `User ${blockedId} successfully unblocked by ${blockerId}`});
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
router.get("/api/social/getBlockList/:userId/:limit", async(req,res)=>{
    try {
      let blockList:UserModel[] = <UserModel[]>[];
      const userId:string = req.params.userId;
      const limit: number = parseInt(req.params.limit);
      const lastBlockedUser:any = req.query.lastBlockedUser;
      if(lastBlockedUser != null && lastBlockedUser != undefined && lastBlockedUser.toString() != ""){
        const lastBlockedUserDoc = await db.userBlockedUsersCollection(userId).doc(lastBlockedUser).get();
        const blockedUsers = await db.userBlockedUsersCollection(userId).orderBy('timestamp', 'desc').startAfter(lastBlockedUserDoc).limit(limit).get();
        for(const blockedUser of blockedUsers.docs){
          const newUser = await getUser(blockedUser.ref.id);
          
          if(newUser != null && newUser != undefined){
            return res.status(500).send({status: "Error", data: `no user of id ${blockedUser.ref.id} found`});
          }
          blockList.push(newUser);
        }
      } else {
        const blockedUsers = await db.userBlockedUsersCollection(userId).orderBy('timestamp', 'desc').limit(limit).get();
        for(const blockedUser of blockedUsers.docs){
          const userDoc: DocumentReference = userCollection.doc(blockedUser.ref.id);
          const userDocSnap: DocumentSnapshot  = await userDoc.get();
          const user: UserModel = userFromDoc(userDocSnap);
          blockList.push(user);
        }
      }
      
      return res.status(200).send({status: "Success", data: blockList.map((user) => user.toMap())});
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
   });

module.exports = router;