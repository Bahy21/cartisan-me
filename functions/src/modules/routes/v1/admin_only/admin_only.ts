import * as express from "express";
import * as admin from "firebase-admin";
import { log } from "firebase-functions/logger";
const router = express.Router();

router.get("/adminOnly",isAuthorized,(req, res) => {
    return res.status(200).send("admin access checked succesfully");
});


export async function isAuthorized(req: express.Request, res: express.Response, next: Function) {
    const {authorization} = req.headers;
    const split = authorization.split("Bearer ");
    const token = split[1];
    try {
        const decodedToken = await admin.auth().verifyIdToken(token);
        const {role} = decodedToken;
        if(role !== "admin"){
            return res.status(401).send({status: "Failed", msg: "Unauthorized"});
        }
        return next();
    } catch (error) {
        log(error);
        return res.status(401).send({status: "Failed", msg: "Unauthorized"});
    }
 }


module.exports = router;


