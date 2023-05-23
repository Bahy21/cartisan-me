
import * as db from "../../../../services/database";
import { QuerySnapshot } from "firebase-admin/firestore";
import * as express from "express";
import {firestore} from "../../../..";
import logger from "../../../../services/logger";
const router = express.Router();

router.get("/api/notifications/getNotifications/:userId/:count", async (req, res) => {
    try {
        const userId: string = req.params.userId;
        const count: number = parseInt(req.params.count);
        const lastNotificationId = req.query.lastNotificationId;
        const notificationsRef = db.userNotificationCollection(userId); 
        let queryDocs: QuerySnapshot;
        if(lastNotificationId == null || lastNotificationId == undefined || lastNotificationId == ""){
            queryDocs = await notificationsRef.orderBy("timestamp", "desc").limit(count).get()
        } else {
            const startAt = await notificationsRef.doc(lastNotificationId.toString()).get();
            queryDocs = await notificationsRef.orderBy("timestamp","desc").startAfter(startAt).limit(count).get();
        }
        let queryDocsData = [];
        for(const queryDoc of queryDocs.docs){
            queryDocsData.push(queryDoc.data());
        }
        return res.status(200).send({status: "Success", data: queryDocsData});
    } catch (error) {
        logger.info(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});

router.delete("/api/notifications/clearNotifications/:userId", async (req, res) => {
    try {
        const userId: string = req.params.userId;
        const notificationsRef = db.userNotificationCollection(userId); 
        const queryDocs = await notificationsRef.get();
        let queryDocsData = [];
        const batch = firestore.batch();
        for(const queryDoc of queryDocs.docs){
            await queryDoc.ref.delete();
        }
        await batch.commit();
        return res.status(200).send({status: "Success", data: queryDocsData});
    } catch (error) {
        logger.info(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
});


module.exports = router;