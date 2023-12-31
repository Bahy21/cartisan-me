// 
import { Address } from "../../../../models/address";
import { UserModel } from "../../../../models/user_model";
import { addressFromMap, postFromDoc, userFromDoc, userFromMap } from "../../../../services/functions";
import * as db from "../../../../services/database";
import { CollectionReference, DocumentReference, DocumentSnapshot } from "firebase-admin/firestore";
import { PostModel } from "../../../../models/post_model";
import * as express from "express";
import logger from "../../../../services/logger";
import { log } from "firebase-functions/logger";
const router = express.Router();

// create user
router.post("/api/user/createUser/:userId", async (req, res) => {
    try {
      
      const userId = req.params.userId;
      const newUser = new UserModel({
        id: userId,
        username: req.body.username,
        url: req.body.url,
        email: req.body.email,
      });
      newUser.profileName = req.body.profileName ?? "";
      newUser.unreadMessageCount = req.body.unreadMessageCount ?? 0;
      newUser.taxPercentage = req.body.taxPercentage ?? 0;
      newUser.bio = req.body.bio ?? "";
      newUser.shippingCost = req.body.shippingCost ?? 0;
      newUser.deliveryCost = req.body.deliveryCost ?? 0;
      newUser.freeShipping = req.body.freeShipping ?? 0;
      newUser.freeDelivery = req.body.freeDelivery ?? 0;
      newUser.activeShipping = req.body.activeShipping ?? false;
      newUser.pickup = req.body.pickup ?? false;
      newUser.isDeliveryAvailable = req.body.isDeliveryAvailable ?? false;
      newUser.sellerID = req.body.sellerID ?? "";
      newUser.buyerID = req.body.buyerID ?? "";
      newUser.defaultAddress = req.body.defaultAddress==null ?  null : addressFromMap(req.body.defaultAddress);
      newUser.country = req.body.country ?? "";
      newUser.state = req.body.state ?? "";
      newUser.city = req.body.city ?? "";
      newUser.isSeller = req.body.isSeller ?? false;
      newUser.customerId = req.body.customerId ?? "";
      newUser.uniqueStoreName = req.body.uniqueStoreName ?? "";
      await db.userCollection.doc(userId).set(newUser.toMap());
      await db.userFollowingCollection(userId).doc(userId).set({userId: true})
      return res.status(200).send({status: "Success", data: `Successfully created user ${userId}`});
    } catch (error) {
      log(error);
      return res.status(500).send({status: "Failed", msg: error.message});
    }
});
  
// get user
router.get("/api/user/getUser/:userId", async (req, res) => {
  try {
    const userId: string = req.params.userId;
    const userDoc: DocumentReference = db.userCollection.doc(userId);
    const userDocSnap: DocumentSnapshot  = await userDoc.get();
    // check if user exists
    if (!userDocSnap.exists){
      return res.status(500).send({status: "Failed", msg: `User ${userId} does not exist`});
    }
    const user: UserModel = userFromDoc(userDocSnap);
    return res.status(200).send({status: `Success in fetching user ${userId}`, data: user.toMap()});
  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
  }
});

// get user posts
router.get("/api/user/getAllPosts/:userId", async (req, res) => {
  try {
    const userId: string = req.params.userId;
    const lastPostId: string = req.query.lastPostId.toString();
    let userPostsCollection;
    if (lastPostId == null || lastPostId == ""){
      userPostsCollection = db.postsCollection.where("ownerId", "==", userId).orderBy("timestamp","desc").limit(9);
    } else{
      const startAt = await db.postsCollection.doc(lastPostId).get();
      userPostsCollection = db.postsCollection.where("ownerId", "==", userId).orderBy("timestamp", "desc").startAfter(startAt).limit(9);
    }
    let posts:PostModel[] = <PostModel[]>[];
    const postCollection = await userPostsCollection.get();
    postCollection.docs.map((doc:DocumentSnapshot)=>{
      posts.push(postFromDoc(doc));
    });
    
    return res.status(200).send({status: "Success", data: posts});
  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
  }
});

// new address
router.put("/api/user/addAddress/:userId", async (req, res) => {
  try {
    const userId = req.params.userId;
    const address:Address = addressFromMap(req.body);
    const addressDoc: CollectionReference = db.allUserAddresses(userId);
    const addresssId = addressDoc.doc().id;
    address.addressID = addresssId;
    await addressDoc.doc().set(address.toMap());
    return res.status(200).send({status: "Success", data: `Successfully added address for user ${userId}`});
  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
  }
});

// get all addresses
router.get("/api/user/getAllAddresses/:userId", async (req, res) => {
  try {
    const userId = req.params.userId;
    const addressDoc: CollectionReference = db.allUserAddresses(userId);
    const addresssDocs = await addressDoc.get();
    let addresses:Address[] = <Address[]>[];
    addresssDocs.docs.map((doc)=>{
      addresses.push(addressFromMap(doc.data() as Map<String, any>));
    });
    return res.status(200).send({status: "Success", data: addresses});
  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
  }
});

// update address
router.put("/api/user/updateAddress/:userId/:addressId", async (req, res) => {
  try {
    const userId = req.params.userId;
    const addressId = req.params.addressId;
    const address:Address = addressFromMap(req.body);
    const addressDoc: DocumentReference = db.allUserAddresses(userId).doc(addressId);
    await addressDoc.update(address.toMap());
    return res.status(200).send({status: "Success", data: `Successfully added address for user ${userId}`});
  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
  }
});

// delete address
router.delete("/api/user/deleteAddress/:userId/:addressId", async (req, res) => {
  try {
    const userId = req.params.userId;
    const addressId = req.params.addressId;
    const addressDoc: DocumentReference = db.allUserAddresses(userId).doc(addressId);
    await addressDoc.delete();
    return res.status(200).send({status: "Success", data: `Successfully added address for user ${userId}`});
  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
  }
});

// update area
router.put("/api/user/updateArea/:userId", async (req, res) => {
  try {
    const userId = req.params.userId;
    const city: string = req.body.city ?? "";
    const state: string = req.body.state ?? "";
    const country: string = req.body.country ?? "";
    const userDoc: DocumentReference = db.userCollection.doc(userId);
    await userDoc.update({
      'city': city,
      'state': state,
      'country': country,
    })
    return res.status(200).send({status: "Success", data: `Successfully added address for user ${userId}`});
  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
  }
});

// update delivery info
router.put("/api/user/updateDeliveryInfo/:userId", async (req, res) => {
  try {
    const userId = req.params.userId;
    const userDoc: DocumentReference = db.userCollection.doc(userId);
    const user = userFromDoc(await userDoc.get());
    const shippingCost: number = req.body.shippingCost ?? user.shippingCost;
    const deliveryCost: number = req.body.deliveryCost ?? user.deliveryCost;
    const freeShipping: number = req.body.freeShipping ?? user.freeShipping;
    const freeDelivery: number = req.body.freeDelivery ?? user.freeDelivery;
    const activeShipping: boolean = req.body.activeShipping ?? user.activeShipping;
    const pickup: boolean = req.body.pickup ?? user.pickup;
    const isDeliveryAvailable: boolean = req.body.isDeliveryAvailable ?? user.isDeliveryAvailable;
    await userDoc.update({
      'shippingCost': shippingCost,
      'deliveryCost': deliveryCost,
      'freeShipping': freeShipping,
      'freeDelivery': freeDelivery,
      'activeShipping': activeShipping,
      'pickup': pickup,
      'isDeliveryAvailable': isDeliveryAvailable,
    })
    return res.status(200).send({status: "Success", data: `Successfully updated delivery info for ${userId}`});
  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
  }
});

// update user info
router.put("/api/user/updateUser/:userId", async (req, res) => {
  try {
    const userId = req.params.userId;
    const userDoc: DocumentReference = db.userCollection.doc(userId);
    const updatedUser = userFromMap(req.body);
    userDoc.update(updatedUser.toMap());
    return res.status(200).send({status: "Success", data: `Successfully updated delivery info for ${userId}`});
  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
  }
});


// get user post count
router.get("/api/user/getPostCount/:userId", async (req, res) => {
  try {
    
    const query = db.postsCollection.where('ownerId', '==', req.params.userId).count();
    const queryResult = await query.get();
    const postCount = queryResult.data().count;
    return res.status(200).send({ status: "Success", data: postCount });
  } catch (error) {
    log(error);
    return res.status(500).send({ status: "Failed", msg: error.message });
  }
});

module.exports = router;