import { log } from "firebase-functions/logger";
import * as db from "../../../../../services/database";
import { DocumentSnapshot, QuerySnapshot } from "firebase-admin/firestore";
import * as express from "express";
const router = express.Router();


// follow User
router.put("/api/social/followUser/:userId/:followId", async(req,res) => {
    try {
      const userId: string = req.params.userId;
      const followId: string = req.params.followId;
  
      await db.userFollowingCollection(userId).doc(followId).set({timestamp: Date.now()});
      await db.userFollowersCollection(followId).doc(userId).set({timestamp: Date.now()});   
      return res.status(200).send({status: "Success", data: `User ${userId} succesfully following ${followId}`});
    } catch (error) {
      log(error);
      return res.status(500).send({status: "Failed", msg: error.message});
    }
  });
  
  // is following
  router.get("/api/social/isFollowing/:userId/:followId", async(req,res) => {
    try {
      const userId: string = req.params.userId;
      const followId: string = req.params.followId;
      const followerDoc = await db.userFollowingCollection(userId).doc(followId).get();
      if(followerDoc.exists){
        return res.status(200).send({status: "Success", data: true});
      } else {
        return res.status(500).send({status: "Failure", data: false});
      }
    } catch (error) {
      log(error);
      return res.status(500).send({status: "Failed", msg: error.message});
    }
  });
  
  // unfollow User
  router.delete("/api/social/unfollowUser/:userId/:followId", async(req,res) => {
    try {
      const userId: string = req.params.userId;
      const followId: string = req.params.followId;
      const followingDoc:DocumentSnapshot = await db.userFollowingCollection(userId).doc(followId).get();
      const followerDoc: DocumentSnapshot = await db.userFollowersCollection(followId).doc(userId).get();
      if(followerDoc.exists && followingDoc.exists){
        followerDoc.ref.delete();
        followingDoc.ref.delete();
        return res.status(200).send({status: "Success", data: `User ${userId} succesfully unfollowed ${followId}`});
      } else {
        return res.status(500).send({status: "Failed", msg: "Unsuccesful, check IDs"});
      }
    } catch (error) {
      log(error);
      return res.status(500).send({status: "Failed", msg: error.message});
    }
  });
  
  
  // get followers
  router.get("/api/social/getFollowing/:userId", async (req, res) => {
    try {
      const userId: string = req.params.userId;
      const lastSentFollowerId: string = req.body.lastSentFollowerId;
      let followers: string[] = <string[]>[];
      let followerDocs: QuerySnapshot;
      if (lastSentFollowerId == null){
        followerDocs = await db.userFollowingCollection(userId).startAfter(lastSentFollowerId).limit(10).get();
      } else {
        const lastFollowerSentDoc = await db.userFollowingCollection(userId).doc(lastSentFollowerId).get();
        followerDocs = await db.userFollowingCollection(userId).startAfter(lastFollowerSentDoc).limit(10).get();
      }
      followerDocs.forEach((followerDoc) => {
        followers.push(followerDoc.id);
      })
      return res.status(200).send({status: "Success", data: followers});
    } catch (error) {
      log(error);
      return res.status(500).send({status: "Failed", msg: error.message});
    }
  });
  
  // get followers
  router.get("/api/social/getFollowers/:userId", async (req, res) => {
    try {
      const userId: string = req.params.userId;
      const lastSentFollwerId: string = req.body.lastSentFollowerId;
      let followers: string[] = <string[]>[];
      let followingDocs: QuerySnapshot;
      if (lastSentFollwerId == null){
        followingDocs = await db.userFollowersCollection(userId).startAfter(lastSentFollwerId).limit(10).get();
      } else {
        const lastFollowingSentDoc = await db.userFollowingCollection(userId).doc(lastSentFollwerId).get();
        followingDocs = await db.userFollowingCollection(userId).startAfter(lastFollowingSentDoc).limit(10).get();
      }
      followingDocs.forEach((followerDoc) => {
        followers.push(followerDoc.id);
      });
      return res.status(200).send({status: "Success", data: followers});
    } catch (error) {
      log(error);
      return res.status(500).send({status: "Failed", msg: error.message});
    }
  });


module.exports = router;