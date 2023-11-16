/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import {getFirestore, Timestamp} from "firebase-admin/firestore";
import {initializeApp} from "firebase-admin/app";

initializeApp();

function getRandomElement(arr: string[]) {
  return arr[Math.floor(Math.random() * arr.length)];
}

exports.dailyCleanup = functions.pubsub
    .schedule("every 24 hours").onRun(async () => {
      const firestore = getFirestore();
      const roomsCollection = firestore.collection("rooms");

      const dateCheck = new Date(Date.now() - 24 * 60 * 60 * 1000);
      const query = roomsCollection
          .where("lastInteraction", "<", Timestamp.fromDate(dateCheck));
      const snapshot = await query.get();

      const batch = firestore.batch();

      snapshot.forEach((doc) => {
        batch.delete(doc.ref);
      });

      return await batch.commit();
    });

exports.getQuestions = functions.https.onCall(async (request) => {
  const firestore = getFirestore();
  const roomsCollection = firestore.collection("rooms");
  const statsCollection = firestore.collection("stats");

  const roomSnapshot = await roomsCollection
      .where("code", "==", request.code).get();

  if (!roomSnapshot.empty) {
    roomSnapshot.forEach(async (roomDoc) => {
      const roomData = roomDoc.data();
      let questionsCollectionName;

      if (roomData.language.startsWith("pt")) {
        questionsCollectionName = "questionsPor";
      } else if (roomData.language.startsWith("en")) {
        questionsCollectionName = "questionsEng";
      } else if (roomData.language.startsWith("es")) {
        questionsCollectionName = "questionsSpa";
      } else {
        questionsCollectionName = "questionsEng";
      }

      const questionsCollection = firestore.collection(questionsCollectionName);
      const statsSnapshot = await statsCollection
          .doc(questionsCollectionName)
          .get();
      const stats = statsSnapshot.data();
      if (stats) {
        let idsForMode;
        if (roomData.mode === "random") {
          idsForMode = [
            ...stats["easy"].ids,
            ...stats["moderate"].ids,
            ...stats["difficult"].ids,
          ];
        } else {
          idsForMode = stats[roomData.mode].ids;
        }

        const idsToGet = [];
        for (let i = 0; i < roomData.numberOfQuestions; i++) {
          idsToGet.push(parseInt(getRandomElement(idsForMode)));
        }
        const questionsSnapshot = await questionsCollection
            .where("id", "in", idsToGet)
            .get();
        if (!questionsSnapshot.empty) {
          const questionsList: object[] = [];
          questionsSnapshot.forEach((questionDoc) => {
            questionsList.push(questionDoc.data());
          });
          roomDoc.ref.set({
            ...roomData,
            questions: questionsList,
            status: "active",
          });
        }
      }
    });
  }
});
