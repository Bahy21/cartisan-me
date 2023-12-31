
import * as db from "../../../../services/database";
import { deliveryOptionFromIndex, getUser, postFromDoc, userFromDoc } from "../../../../services/functions";
import { PostModel } from "../../../../models/post_model";
import * as express from "express";
import { DocumentReference, DocumentSnapshot } from "firebase-admin/firestore";
import { UserModel } from "../../../../models/user_model";
import logger from "../../../../services/logger";
import { log } from "firebase-functions/logger";
const router = express.Router();


// get post
router.get("/api/post/getPost/:postId", async (req, res) => {
  try {
    let docref = await db.postsCollection.doc(req.params.postId);
    const doc = await docref.get();
    if (doc.exists) {
      const post = postFromDoc(doc);
      const owner = await getUser(post.ownerId);
      return res.status(200).send({ status: "Success", data: {'post':post.toMap(), 'owner':owner.toMap() } });
    } else {
      return res.status(500).send({ status: "Failed", msg: `Document ${req.params.postId} does not exist` });
    }
  } catch (error) {
    log(error);
    return res.status(500).send({ status: "Failed", msg: error.message });
  }
});

// create post
router.post("/api/newPost/:userId", async (req, res) => {
  try {
    const userId: string = req.params.userId;
    const postId: string = db.postsCollection.doc().id;
    if (Object.keys(req.body).length === 0) {
      return res.status(500).send({ status: "Failed", msg: "Empty body" });
    }
    const post = new PostModel({
      postId: postId,
      ownerId: userId,
      username: req.body.username as string ?? "",
      description: req.body.description as string ?? "",
      productName: req.body.productName as string ?? "",
      brand: req.body.brand as string ?? "",
      variants: req.body.variants as string[] ?? <string[]>[],
      price: req.body.price as number ?? 0,
      location: req.body.location as string ?? "",
      rating: req.body.rating as number ?? 0,
      reviewCount: req.body.reviewCount as number ?? 0,
      images: req.body.images as string[] ?? <string[]>[],
      selectedVariant: req.body.selectedVariant as string ?? "",
      deliveryOptions: req.body.deliveryOptions == null ? null : deliveryOptionFromIndex(req.body.deliveryOptions as number),
      quantity: req.body.delivery as number ?? 0,
      isProductInStock: req.body.isProductInStock ?? true,
      archived: req.body.archived ?? false,
      sellCount: req.body.sellCount as number ?? 0,
      commentCount: req.body.commentCount as number ?? 0,
      likesCount: req.body.likesCount as number ?? 0,
      timestamp: Date.now(),
    });
    await db.postsCollection.doc(postId).set(post.toMap());
    return res.status(200).send({ status: "Success", data: `post written with ID: ${postId}` });
  } catch (error) {
    log(error);
    return res.status(500).send({ status: "Failed", msg: error.message });
  }
});

// create post
router.post("/api/updatePost/:postId", async (req, res) => {
  try {
    const postId: string = req.params.postId;
    if (Object.keys(req.body).length === 0) {
      return res.status(500).send({ status: "Failed", msg: "Empty body" });
    }
    const post =  {
      postId: postId,
      description: req.body.description as string,
      productName: req.body.productName as string,
      brand: req.body.brand as string,
      variants: req.body.variants as string[],
      price: req.body.price as number,
      location: req.body.location as string ,
      images: req.body.images as string[],
    };
    await db.postsCollection.doc(postId).update(post);
    return res.status(200).send({ status: "Success", data: `post updated with ID: ${postId}` });
  } catch (error) {
    log(error);
    return res.status(500).send({ status: "Failed", msg: error.message });
  }
});


// archive post
router.delete("/api/post/archivePost/:postId", async (req, res) => {
  try {
    const postId = req.params.postId
    let docref = await db.postsCollection.doc(postId);
    const doc = await docref.get();
    if (doc.exists) {
      await db.postsCollection.doc(postId).update({'archived': true},);
      return res.status(200).send({ status: "success", msg: `Document ${postId} successfully deleted` });
    } else {
      return res.status(500).send({ status: "Failed", msg: `Document ${req.params.postId} does not exist` });
    }
  } catch (error) {
    log(error);
    return res.status(500).send({ status: "Failed", msg: error.message });
  }
});
// unarchive post
router.put("/api/post/unarchivePost/:postId", async (req, res) => {
  try {
    const postId = req.params.postId
    let docref = await db.postsCollection.doc(postId);
    const doc = await docref.get();
    if (doc.exists) {
      await db.postsCollection.doc(postId).update({'archived': false},);
      return res.status(200).send({ status: "success", msg: `Document ${postId} successfully deleted` });
    } else {
      return res.status(500).send({ status: "Failed", msg: `Document ${req.params.postId} does not exist` });
    }
  } catch (error) {
    log(error);
    return res.status(500).send({ status: "Failed", msg: error.message });
  }
});



module.exports = router;