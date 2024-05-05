import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const createLoginToken = functions
  .region("asia-northeast1")
  .https.onRequest(async (req, res) => {
    const {userID} = req.body.data;

    if (typeof userID !== "string") {
      res.status(400).send("Bad Request");
      return;
    }

    const token = await admin.auth().createCustomToken(userID);

    res.status(200).send({
      data: {token},
    });
  });
