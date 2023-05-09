import * as express from "express";

const router = express.Router();

router.get("/",(req, res) => {
    return res.status(200).send("v2 of app loaded succesfully");
});

module.exports = router;