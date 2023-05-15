import { Address } from "../../../../models/address";
import { UserModel } from "../../../../models/user_model";
import * as db from "../../../../services/database";
import * as functions from "firebase-functions";
import { Request, Response } from "express";
import { log } from "firebase-functions/logger";
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