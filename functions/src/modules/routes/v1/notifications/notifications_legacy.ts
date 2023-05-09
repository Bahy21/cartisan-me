import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as db from "../../../../services/database";
import { log } from "firebase-functions/logger";
import { NotificationModel } from "../../../../models/notification_model";

exports.sendNotificationToIndividual = functions.https.onCall((data, _) =>
  sendNotification(data)
);
export async function sendNotification(request: {
  uid: string;
  alertHeading: any;
  alertMessage: any;
  alertID: any;
  userId: any;
  username: any;
  notificationType: any;
  userProfileImg: any;
}) {
  const tokensdoc = await admin
    .firestore()
    .collection("users")
    .doc(request.uid)
    .get();
  const body = request.alertMessage;
  let title = request.alertHeading;

  const payload = {
    token: (tokensdoc as FirebaseFirestore.DocumentData)
      .data()
      .androidNotificationToken,
    notification: {
      body: body,
      clickAction: "FLUTTER_NOTIFICATION_CLICK",
      title: title,
      sound: "default",
    },
    data: {
      alertID: request.alertID,
    },
  };
  const newNotif = new NotificationModel({
    ownerId: request.uid,
    userId: request.userId,
    timestamp: Date.now(),
    username: request.username,
    type: request.notificationType,
    userProfileImg: request.userProfileImg,
  });
  try {
    db.userNotificationCollection(request.uid).doc().set(newNotif.toMap());
  } catch (error) {
    log(error);
    return false;
  }
  try {
    admin
      .messaging()
      .send(
        payload
      );
    return true;
  } catch (e) {
    console.log(e);
    return false;
  }
}
exports.sendNotificationToList = functions.https.onCall(
  async (request, response) => {
    let body;
    let title;
    title = request.alertHeading;
    body = request.alertMessage;
    const payload = {
        token: request.uid,
        notification: {
            body: body,
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
            title: title,
            sound: "default",
        },
        data: {
            alertID: request.alertID,
        },
    };
    try {
      const newNotif = new NotificationModel({
        ownerId: request.uid,
        userId: request.userId,
        timestamp: Date.now(),
        username: request.username,
        type: request.notificationType,
        userProfileImg: request.userProfileImg,
      });
      db.userNotificationCollection(request.uid).doc().set(newNotif.toMap());
    } catch (error) {
      log(error);
      return false;
    }
    try {
      admin.messaging().send(payload);
      return true;
    } catch (e) {
      console.log(e);
      return false;
    }
  }
);

