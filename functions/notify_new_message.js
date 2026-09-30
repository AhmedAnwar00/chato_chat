const PREVIEW_LIMIT = 120;
const TITLE_LIMIT = 100;
const SEND_BATCH_LIMIT = 500;

const INVALID_TOKEN_CODES = new Set([
  "messaging/invalid-argument",
  "messaging/invalid-registration-token",
  "messaging/registration-token-not-registered",
]);

async function notifyNewMessage({
  messageId,
  message,
  firestore,
  messaging,
  logger = console,
}) {
  const parsed = parseMessage(message);
  if (!parsed) {
    return;
  }

  const snapshot = await firestore.collection("users").get();
  const senderName = readSenderName(snapshot, parsed.senderId);
  const recipients = readRecipients(snapshot, parsed.senderId);
  if (recipients.length === 0) {
    return;
  }

  const notification = {
    title: notificationTitle(senderName, parsed.senderId),
    body: messagePreview(parsed.body),
  };
  const data = { senderId: parsed.senderId };
  const id = readText(messageId);
  if (id) {
    data.messageId = id;
  }
  if (senderName) {
    data.senderName = senderName;
  }

  let retryableFailure = false;
  for (let index = 0; index < recipients.length; index += SEND_BATCH_LIMIT) {
    const batch = recipients.slice(index, index + SEND_BATCH_LIMIT);
    const response = await messaging.sendEach(
      batch.map((recipient) => ({
        token: recipient.token,
        notification,
        data,
      })),
    );
    response.responses.forEach((result, resultIndex) => {
      if (result.success) {
        return;
      }
      const uid = batch[resultIndex].uid;
      const code = errorCode(result.error);
      if (INVALID_TOKEN_CODES.has(code)) {
        logger.error("Skipped an unusable FCM token", { uid, code });
        return;
      }
      retryableFailure = true;
      logger.error("FCM send failed", { uid, code });
    });
  }

  if (retryableFailure) {
    throw new Error("FCM send failed");
  }
}

function parseMessage(message) {
  if (!message || typeof message !== "object" || Array.isArray(message)) {
    return null;
  }
  const senderId = readText(message.senderId);
  const body = readText(message.body);
  if (!senderId || !body) {
    return null;
  }
  return { senderId, body };
}

function readSenderName(snapshot, senderId) {
  for (const doc of snapshot.docs) {
    if (doc.id === senderId) {
      return readText(doc.get("name"));
    }
  }
  return null;
}

function readRecipients(snapshot, senderId) {
  const recipients = [];
  for (const doc of snapshot.docs) {
    if (doc.id === senderId) {
      continue;
    }
    const token = readText(doc.get("fcmToken"));
    if (!token) {
      continue;
    }
    recipients.push({ uid: doc.id, token });
  }
  return recipients;
}

function notificationTitle(senderName, senderId) {
  return clip(senderName ?? senderId, TITLE_LIMIT);
}

function messagePreview(body) {
  return clip(body.replace(/\s+/g, " "), PREVIEW_LIMIT);
}

function clip(value, limit) {
  if (value.length <= limit) {
    return value;
  }
  return `${value.slice(0, limit - 3)}...`;
}

function readText(value) {
  if (typeof value !== "string") {
    return null;
  }
  const trimmed = value.trim();
  return trimmed.length > 0 ? trimmed : null;
}

function errorCode(error) {
  if (error && typeof error.code === "string") {
    return error.code;
  }
  return "";
}

module.exports = {
  notifyNewMessage,
};
