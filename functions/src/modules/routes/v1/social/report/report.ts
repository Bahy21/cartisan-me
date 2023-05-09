import { log } from "firebase-functions/logger";
import * as db from "../../../../../services/database";
import { ReportModel } from "../../../../../models/report_model";

import * as express from "express";
const router = express.Router();

// report user
router.put("/api/social/reportUser/:userId", async (req, res)=>{
    try {
      const userId = req.params.userId;
      const docId = req.body.docId;
      const result = req.body.result;
      const reportId = req.body.reportId;
      const report = new ReportModel({postId: '',
      isGroup: false,
      messageId: '',
      flaggedBy: userId,
      reportId: docId,
      reportedFor: result,
      reportedUsersId: reportId});
      await db.userReportsCollection.doc().set(report.toMap());
      return res.status(200).send({status: "Success", data: "Report Sent"});
    } catch (error) {
      log(error);
      return res.status(500).send({status: "Failed", msg: error.message});
    }
  });

module.exports = router;