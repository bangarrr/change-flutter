import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {firestore} from "firebase-admin/lib/firestore/firestore-namespace";
import Firestore = firestore.Firestore;

export const createNewMessage = functions
  .region("asia-northeast1")
  .https.onCall(async (data, context) => {
    const firestore = admin.firestore();
    const {message} = data;
    const uid = context.auth?.uid;

    if (!uid) {
      throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
    }

    if (typeof message !== "string") {
      throw new functions.https.HttpsError("invalid-argument", "Message body must be a string");
    }

    /* ランダムにユーザーを選ぶ */
    const userCount = (await firestore.doc("settings/user").get()).data()?.count ?? 0;
    const randomSelectedUserID = Math.floor(Math.random() * userCount);
    const targetUser = await firestore.collection("users").where("id", "==", randomSelectedUserID).get();
    if (targetUser.empty) return {status: "ok"};

    const targetUserUid = targetUser.docs[0].id;
    if (uid === targetUserUid) return {status: "ok"};

    if (await isRoomExists(uid, targetUserUid, firestore)) return {status: "ok"};

    await firestore.runTransaction(async (tx) => {
      const roomDocRef = firestore.collection("rooms").doc();
      tx.create(roomDocRef, {
        members: [uid, targetUserUid],
        open: false,
      });

      const eventDocRef = firestore.collection(`${roomDocRef.path}/events`).doc();
      tx.create(eventDocRef, {
        body: message,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    });

    return {status: "ok"};
  });

const isRoomExists = async (userUID1: string, userUID2: string, firestore: Firestore) => {
  const q = firestore
    .collection("rooms")
    .where("members", "in", [[userUID1, userUID2], [userUID2, userUID1]]);
  const searched = await q.get();

  return !searched.empty;
};
