
import * as db from "../../../../../services/database";
import { ReportModel } from "../../../../../models/report_model";

import * as express from "express";
import logger from "../../../../../services/logger";
import { log } from "firebase-functions/logger";
const router = express.Router();

// report user
router.post("/api/social/reportUser/:userId", async (req, res)=>{
    try {
      const userId = req.params.userId;
      const reportedFor = req.body.reportedFor;
      const reportedId = req.body.reportedId;
      const report = new ReportModel({postId: '',
      isGroup: false,
      messageId: '',
      flaggedBy: userId,
      reportId: '',
      reportedFor: reportedFor,
      reportedUsersId: reportedId});
      const reportId = db.userReportsCollection.doc().id;
      report.reportId = reportId;
      await db.userReportsCollection.doc(reportId).set(report.toMap());
      return res.status(200).send({status: "Success", data: "Report Sent"});
    } catch (error) {
      log(error);
      return res.status(500).send({status: "Failed", msg: error.message});
    }
  });
  router.post("/api/post/reportPost/:postId", async (req, res)=>{
    try {
      const userId = req.params.postId;
      const reportedFor = req.body.reportedFor;
      const postId = req.body.postId;
      const reportUserId = req.body.reportUserId;
      const report = new ReportModel({postId: postId,
      isGroup: false,
      messageId: '',
      flaggedBy: userId,
      reportId: '',
      reportedFor: reportedFor,
      reportedUsersId: reportUserId});
      const reportId = db.userReportsCollection.doc().id;
      report.reportId = reportId;
      await db.userReportsCollection.doc(reportId).set(report.toMap());
      return res.status(200).send({status: "Success", data: "Report Sent"});
    } catch (error) {
      log(error);
      return res.status(500).send({status: "Failed", msg: error.message});
    }
  });


module.exports = router;