import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp(functions.config().firebase); 
import * as cors from 'cors';
const posts = require('./modules/routes/v1/posts/posts');
const userProfile = require('./modules/routes/v1/user/user_profile');
const blockFunctions = require('./modules/routes/v1/social/block/block');
const followFunctions =  require('./modules/routes/v1/social/follow/follow');
const reviewFunctions = require('./modules/routes/v1/review/review');
const cartFunctions = require('./modules/routes/v1/cart/cart');
const timelineFunctions = require('./modules/routes/v1/timeline/timeline');
const commentFunctions = require('./modules/routes/v1/posts/comments');
const likeFunctions = require('./modules/routes/v1/posts/likes');
const orderFunctions = require('./modules/routes/v1/order/order');
const searchFunctions = require('./modules/routes/v1/search/search');
const adminOnly = require('./modules/routes/v1/admin_only/admin_only');
const versionCheck = require('./modules/routes/v2/version_check');
const notificationFunctions = require('./modules/routes/v1/notifications/notifications');
const reportFunctions = require('./modules/routes/v1/social/report/report');
const stripeWebhook = require('./modules/routes/v1/webhooks/stripe_webhook');
const paymentFunctions = require('./modules/routes/v1/payment/payment');
import * as express from 'express';
import { FakeDataPopulator } from './services/fakeDataPopulator';
import logger from './services/logger';


export const firestore = admin.firestore();
import * as triggerFunctions from './modules/module';

export const authMiddleware = async (req, res, next) => {
  try {
    const idToken = req.headers.authorization;
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    req.user = decodedToken;
    next();
  } catch (error) {
    console.error('Error while verifying Firebase ID token:', error);
    res.status(401).send('Unauthorized');
  }
};

// functionslog.logger.ger.info('running');
firestore.settings({ timestampInSnapshots: true });



const populator = new FakeDataPopulator(firestore);

const app = express();
exports.firebasePopulator = functions.https.onCall(async (req,res)=>{
  await populator.generateFakeUsers();
});
app.post('/populateFirebase'), async (req, res) => {
  populator.generateFakeUsers();
}
app.use(cors({origin: true}));
app.use((req, res, next) => {
  var methodNameAfterAPI = req.originalUrl.split('api/').pop();
  logger.info(`${req.method} ${methodNameAfterAPI}`);
  next();
});

app.use(stripeWebhook);
app.use(authMiddleware);
// app load check
app.get('/',(req, res) => {
  return res.status(200).send('app loaded succesfully');
});

// all API endpoints need to be exported and imported here
app.use('/v1', posts);
app.use('/v1', userProfile);
app.use('/v1', blockFunctions);
app.use('/v1', followFunctions);
app.use('/v1', reviewFunctions);
app.use('/v1', cartFunctions);
app.use('/v1', timelineFunctions);
app.use('/v1', likeFunctions);
app.use('/v1', commentFunctions);
app.use('/v1', orderFunctions);
app.use('/v1', adminOnly);
app.use('/v1', searchFunctions);
app.use('/v1', notificationFunctions);
app.use('/v1', reportFunctions);
app.use('/v1', paymentFunctions);
app.use('/v2', versionCheck);





exports.app = functions.https.onRequest(app);

exports.cartisan = triggerFunctions;
