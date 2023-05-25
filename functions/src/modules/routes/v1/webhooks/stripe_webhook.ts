// 
import { onAccountUpdated, onPaymentFailed, onPaymentSucceeded } from "../payment/helper";
import express = require("express");
import { stripeWebhookReportsReference } from "../../../../services/database";
import logger from "../../../../services/logger";
const router = express.Router();


router.post("/api/payment/stripe/webhook", async (req, res) => {
    try {
      let sig = req.headers["stripe-signature"];
  
      let event = req.body;
      await stripeWebhookReportsReference.add(event);
      if (
        event.type == "account.updated" &&
        (event.data.object as any).details_submitted
      ) {
        await onAccountUpdated(event);
      } else if (req.body.type == "payment_intent.succeeded") {
        await onPaymentSucceeded(event);
      } else if (req.body.type == "payment_intent.requires_payment_method") {
        await onPaymentFailed(event);
      }
    
      return res.status(200).send();
  
    } catch (error) {
        logger.info(error);
        return res.status(500).send({status: "Failed", msg: error.message});
    }
  });


  
module.exports = router;
