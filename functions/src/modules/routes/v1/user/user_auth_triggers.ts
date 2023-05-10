import { Address } from "../../../../models/address";
import { UserModel } from "../../../../models/user_model";
import * as db from "../../../../services/database";
import * as functions from "firebase-functions";
import { Request, Response } from "express";
import { log } from "firebase-functions/logger";
exports.createUserFireStore = functions.auth.user().onCreate(async (user) =>  {
    try {
    const userId = user.uid;
    const newUser = new UserModel({
      id: userId,
      username: user.displayName?? "",
      url: user.photoURL ?? "",
      email: user.email?? "",
    });
    newUser.profileName =user.displayName ?? "";
      newUser.unreadMessageCount = 0;
      newUser.taxPercentage =  0;
      newUser.bio =  "";
      newUser.shippingCost = 0;
      newUser.deliveryCost =  0;
      newUser.freeShipping =  0;
      newUser.freeDelivery =  0;
      newUser.activeShipping =  false;
      newUser.pickup =  false;
      newUser.isDeliveryAvailable = false;
      newUser.sellerID =  "";
      newUser.buyerID =  "";
      const defAddress = new Address({
        userID: user.uid,
        addressID: '',
        addressLine1: '',
        addressLine2: '',
        addressLine3: '',
        postalCode: '',
        contactNumber: '',
        fullname: '',
        city: "",
        state: "California"});
      newUser.defaultAddress = defAddress;
      newUser.country =  "";
      newUser.state = defAddress.state;
      newUser.city =  defAddress.city;
      newUser.isSeller =  false;
      newUser.customerId = "";
      newUser.uniqueStoreName =  "";
      const userDoc = await db.userCollection.doc(userId).get()
      if(userDoc.exists){
        await userDoc.ref.update(newUser.toMap());
      } else {
        await userDoc.ref.set(newUser.toMap());
      }
      await db.userFollowingCollection(userId).doc(userId).set({timestamp: Date.now()})
    } catch (error) {
      log(error);
      await db.errorReportReference.add({error: JSON.stringify(error), date: Date.now()});
    }
  });
exports.deleteUserFireStore = functions.auth.user().onDelete(async (user) =>  {
  try {
    const userId = user.uid;
    await db.userCollection.doc(userId).update(
      {
        "markAsDeleted": true,
      }
    );
  } catch (error) {
    log(error);
    await db.errorReportReference.add({error: JSON.stringify(error), date: Date.now()});
  }
});




export function isAuthorized(opts: { hasRole: Array<'admin' | 'user'>, allowSameUser?: boolean }) {
  return (req: Request, res: Response, next: Function) => {
      const { role, uid } = res.locals
      const { id } = req.params

      if (opts.allowSameUser && id && uid === id)
          return next();

      if (!role)
          return res.status(403).send();

      if (opts.hasRole.includes(role))
          return next();

      return res.status(403).send();
  }
}