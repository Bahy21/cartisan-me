import * as functions from "firebase-functions";
import * as admin from 'firebase-admin';
import logger from "../../../../../services/logger";

exports.sendNotificationToIndividual = functions.https.onCall((data, _) =>
  sendNotification(data)
);
export async function sendNotification(request: {
  uid: string;
  alertHeading: any;
  alertMessage: any;
  alertID: any;
}) {
  //   functions.logger.info("Hello logs!", {structuredData: true});
  //   response.send("Hello from Firebase!");
  const tokensdoc = await admin
    .firestore()
    .collection("users")
    .doc(request.uid)
    .get();

  // "alertID": alertID,
  // "alertMessage": alertMessage,
  // "alertHeading": alertHeading,
  const body = request.alertMessage;
  let title = request.alertHeading;

  // console.logger.info(request.alertHeading);
  // console.logger.info(request.alertMessage);
  // console.logger.info(request.body.alertHeading);
  const payload = {
    notification: {
      body: body,
      clickAction: "FLUTTER_NOTIFICATION_CLICK",
      title: title,
      // "imageUrl": "https://my-cdn.com/extreme-weather.png",
      sound: "default",
    },
    data: {
      alertID: request.alertID,
    },
  };


  try {
    admin
      .messaging()
      .sendToDevice(
        (tokensdoc as FirebaseFirestore.DocumentData).data()
          .androidNotificationToken,
        payload
      );
    return true;
  } catch (e) {
    logger.info(e);
    return false;
  }
}
