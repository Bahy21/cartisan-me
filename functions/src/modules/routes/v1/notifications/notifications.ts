import { log } from "firebase-functions/logger";
import * as db from "../../../../services/database";
import { QuerySnapshot } from "firebase-admin/firestore";
import * as express from "express";
const router = express.Router();

router.get("/api/notifications/getNotifications/:userId", async (req, res) => {
    try {
        const userId: string = req.params.userId;
        const lastNotificationId: string = req.body.lastNotificationId;
        const notificationsRef = db.userNotificationCollection(userId); 
        let queryDocs: QuerySnapshot;
        if(lastNotificationId == null){
            queryDocs = await notificationsRef.orderBy("timestamp", "desc").limit(10).get()
        } else {
            const startAt = await notificationsRef.doc(lastNotificationId).get();
            queryDocs = await notificationsRef.orderBy("timestamp","desc").startAfter(startAt).limit(10).get();
        }
        let queryDocsData = [];
        for(const queryDoc of queryDocs.docs){
            queryDocsData.push(queryDoc.data());
        }
        return res.status(200).send({status: "Success", data: queryDocsData});
    } catch (error) {
        log(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});
