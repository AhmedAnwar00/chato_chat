const { onValueCreated } = require("firebase-functions/v2/database");
const { logger } = require("firebase-functions");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");
const { notifyNewMessage } = require("./notify_new_message");

initializeApp();

exports.notifyOnNewMessage = onValueCreated(
  {
    ref: "/messages/{messageId}",
    instance: "my-chatoo-chat-default-rtdb",
    region: "us-central1",
  },
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      return;
    }
    await notifyNewMessage({
      messageId: event.params.messageId,
      message: snapshot.val(),
      firestore: getFirestore(),
      messaging: getMessaging(),
      logger,
    });
  },
);
