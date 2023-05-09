import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
const serviceAccount = require("../../service-account.json");
admin.initializeApp({credential: admin.credential.cert(serviceAccount)}); 
import * as cors from "cors";
const posts = require("./modules/routes/posts/posts");
const userProfile = require("./modules/routes/v1/user/user_profile");
const blockFunctions = require("./modules/routes/v1/social/block/block");
const followFunctions =  require("./modules/routes/v1/social/follow/follow");
const reviewFunctions = require("./modules/routes/v1/review/review");
const cartFunctions = require("./modules/routes/v1/cart/cart");
const timelineFunctions = require("./modules/routes/v1/timeline/timeline");
const commentFunctions = require("./modules/routes/v1/posts/comments");
const orderFunctions = require("./modules/routes/v1/order/order");
const adminOnly = require("./modules/routes/v1/admin_only/admin_only");
const versionCheck = require("./modules/routes/v2/version_check");
import * as express from "express";
import { FakeDataPopulator } from './services/fakeDataPopulator';

export const firestore = admin.firestore();
import * as triggerFunctions from "./modules/module";

export const authMiddleware = async (req, res, next) => {
  try {
    const idToken = req.headers.authorization.split("Bearer ")[1];
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    req.user = decodedToken;
    next();
  } catch (error) {
    console.error("Error while verifying Firebase ID token:", error);
    res.status(401).send("Unauthorized");
  }
};

functions.logger.log("running");
firestore.settings({ timestampInSnapshots: true });


if(process.env.FUNCTIONS_EMULATOR){
  functions.logger.log("Running emulators Locally");
  const populator = new FakeDataPopulator(firestore);
  populator.generateFakeUsers();
}
const app = express();


app.use(cors({origin: true}));
// app.use(authMiddleware);
// app load check
app.get("/",(req, res) => {
  return res.status(200).send("app loaded succesfully");
});

// all API endpoints need to be exported and imported here
app.use("/v1", posts);
app.use("/v1", userProfile);
app.use("/v1", blockFunctions);
app.use("/v1", followFunctions);
app.use("/v1", reviewFunctions);
app.use("/v1", cartFunctions);
app.use("/v1", timelineFunctions);
app.use("/v1", commentFunctions);
app.use("/v1", orderFunctions);
app.use("/v1", adminOnly);
app.use("/v2", versionCheck);





exports.app = functions.https.onRequest(app);

exports.cartisan = triggerFunctions;
