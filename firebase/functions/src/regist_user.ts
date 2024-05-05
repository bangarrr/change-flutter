import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {FieldValue} from "firebase-admin/firestore";

export const registUser = functions
  .region("asia-northeast1")
  .https.onRequest(async (req, res) => {
    const {username, gender} = req.body.data;
    const firestore = admin.firestore();

    // todo: form validation

    const userID = await firestore.runTransaction(async (tx) => {
      const newUserDoc = firestore.collection("users").doc();
      const userSettingDoc = firestore.collection("settings").doc("user");
      const nextUserId = (await userSettingDoc.get()).data()?.count ?? 0;

      tx.create(newUserDoc, {username, gender, id: nextUserId});
      tx.update(userSettingDoc, {count: FieldValue.increment(1)});

      return newUserDoc.id;
    });

    res.status(200).send({
      data: {userID},
    });
  });
