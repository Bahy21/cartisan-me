import { log } from "firebase-functions/logger";
import * as db from "../../../../services/database";
import { cartItemFromDoc, cartItemFromPost, findItemWithOption, postFromDoc } from "../../../../services/functions";
import { DocumentReference } from "firebase-admin/firestore";
import { PostModel } from "../../../../models/post_model";
import { CartItemModel } from "../../../../models/cart_item_model";
import * as express from "express";
const router = express.Router();

// add to cart
router.put("/api/user/addToCart/:userId/:postId", async(req,res)=>{
    try {
      const MAX_CART_ITEMS = 10;
      const userId: string = req.params.userId;
      const postId: string = req.params.postId;
      let selectedVariant: string = req.body.selectedVariant;
      const postRef: DocumentReference = db.postsCollection.doc(postId);
      const cartRef = db.userCartCollection(userId);
      const cartItems = await cartRef.get();
      if(cartItems.size == MAX_CART_ITEMS){
        return res.status(500).send({status: "Failure", data: "Maximum cart size reached"});
      }
      // parse into usable cart item list
      let userCart:CartItemModel[] = <CartItemModel[]>[];
      cartItems.forEach(async (cartItem) => {
        userCart.push(cartItemFromDoc(cartItem));
      });
      const postModel: PostModel = postFromDoc(await postRef.get());
      if(selectedVariant == null){
        selectedVariant = postModel.selectedVariant;
      }
      // check if item already exists in cart
      const itemIndex = findItemWithOption(postModel.postId, selectedVariant, userCart);
      log(`itemIndex ${itemIndex}`);
      // if found returns index else null
      if(itemIndex == null){   
        const newCartId:string = cartRef.doc().id;
        const cartItem:CartItemModel = cartItemFromPost(postModel);
        cartItem.cartItemId = newCartId;
        await cartRef.doc(newCartId).set(cartItem.toMap());
      } else {
        userCart[itemIndex].quantity += 1;
        log(`user cartItem ${userCart[itemIndex].toString()}`);
        userCart[itemIndex].toMap()
        cartRef.doc(userCart[itemIndex].cartItemId).update({
          "quantity": userCart[itemIndex].quantity
        });
      }
      return res.status(200).send({status: "Success", msg: `Product ${postId} added to cart`});
    } catch (error) {
      log(error);
      return res.status(500).send({status: "Failed", msg: error.message});
    }
  });
  
// delete from cart 
router.delete("/api/user/deleteFromCart/:userId/:itemId", async(req,res)=>{
  try {
    const userId: string = req.params.userId;
    const itemId: string = req.params.itemId;
    const cartItemRef = db.userCartCollection(userId).doc(itemId);
    const cartItem = await cartItemRef.get();
    if(cartItem.exists){
      await cartItemRef.delete()
    } else {
      return res.status(500).send({status: "Failed", msg: `Product ${itemId} not found in cart`});
    }
    return res.status(200).send({status: "Success", msg: `Product ${itemId} deleted from cart`});
  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
  }
});

// clear cart
router.delete("/api/user/clearCart/:userId", async(req,res)=>{
  try {
    const userId: string = req.params.userId;
    const cartRef = db.userCartCollection(userId);
    await new Promise((resolve, reject)=>{deleteQueryBatch(db, cartRef, resolve).catch(reject);});
    return res.status(200).send({status: "Success", msg: `Cart for ${userId} cleared`});
  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
}});

// get posts from cart
router.get("api/user/getPostsFromCart/:userId", async (req, res) => {
  try {
    const userId: string = req.params.userId;
    const cartRef = db.userCartCollection(userId);
    const cartItems = await cartRef.get();
    let postsFromCart: PostModel[] = <PostModel[]>[];
    cartItems.forEach(async (cartItem)=>{
      const postRef: DocumentReference = db.postsCollection.doc(cartItem.data().postId);
      const postModel: PostModel = postFromDoc(await postRef.get());
      postsFromCart.push(postModel);
    });
    return res.status(200).send({status: "Success", data: postsFromCart});
  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
  }
});

// get cart items
router.get("api/user/getCart/:userId", async(req,res)=>{
  try {
    const userId: string = req.params.userId;
    const cartRef = db.userCartCollection(userId);
    const cartItems = await cartRef.get();
    let itemsFromCart: CartItemModel[] = <CartItemModel[]>[];
    cartItems.forEach(async (cartItem)=>{
      const item: CartItemModel = cartItemFromDoc(await cartItem.ref.get());
      itemsFromCart.push(item);
    });
    return res.status(200).send({status: "Success", data: itemsFromCart});
  } catch (error) {
    log(error);
    return res.status(500).send({status: "Failed", msg: error.message});
  }
});

async function deleteQueryBatch(db, query, resolve) {
  const snapshot = await query.get();

  const batchSize = snapshot.size;
  if (batchSize === 0) {
    // When there are no documents left, we are done
    resolve();
    return;
  }

  // Delete documents in a batch
  const batch = db.batch();
  snapshot.docs.forEach((doc) => {
    batch.delete(doc.ref);
  });
  await batch.commit();

  // Recurse on the next process tick, to avoid
  // exploding the stack.
  process.nextTick(() => {
    deleteQueryBatch(db, query, resolve);
  });
}

module.exports = router;