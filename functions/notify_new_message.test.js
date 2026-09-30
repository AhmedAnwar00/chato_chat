const assert = require("node:assert/strict");
const test = require("node:test");
const { notifyNewMessage } = require("./notify_new_message");

test("sends the sender name and message preview to other users", async () => {
  const messaging = fakeMessaging();
  await notifyNewMessage({
    messageId: "msg-1",
    message: {
      body: "hello there",
      timeLabel: "15:18",
      senderId: "sender",
      createdAt: 1,
    },
    firestore: fakeFirestore({
      sender: { name: "Ada", fcmToken: "sender-token" },
      friend: { name: "Grace", fcmToken: "friend-token" },
      quiet: { name: "No Token" },
    }),
    messaging,
    logger: silentLogger(),
  });

  assert.equal(messaging.batches.length, 1);
  assert.deepEqual(messaging.batches[0], [
    {
      token: "friend-token",
      notification: { title: "Ada", body: "hello there" },
      data: {
        senderId: "sender",
        messageId: "msg-1",
        senderName: "Ada",
      },
    },
  ]);
});

test("uses the sender id when the profile has no name", async () => {
  const messaging = fakeMessaging();
  await notifyNewMessage({
    messageId: "msg-2",
    message: { body: "ping", senderId: "sender" },
    firestore: fakeFirestore({
      sender: { fcmToken: "sender-token" },
      friend: { fcmToken: "friend-token" },
    }),
    messaging,
    logger: silentLogger(),
  });

  assert.equal(messaging.batches[0][0].notification.title, "sender");
  assert.equal(messaging.batches[0][0].data.senderName, undefined);
});

test("skips a message that has no sender or body", async () => {
  const messaging = fakeMessaging();
  const firestore = fakeFirestore({
    friend: { name: "Grace", fcmToken: "friend-token" },
  });

  await notifyNewMessage({
    messageId: "msg-3",
    message: { body: "   ", senderId: "sender" },
    firestore,
    messaging,
    logger: silentLogger(),
  });
  await notifyNewMessage({
    messageId: "msg-4",
    message: { body: "hello", senderId: null },
    firestore,
    messaging,
    logger: silentLogger(),
  });
  await notifyNewMessage({
    messageId: "msg-5",
    message: "hello",
    firestore,
    messaging,
    logger: silentLogger(),
  });

  assert.equal(messaging.batches.length, 0);
});

test("shortens a long message preview", async () => {
  const messaging = fakeMessaging();
  const body = `  ${"word ".repeat(40)}`;
  await notifyNewMessage({
    messageId: "msg-6",
    message: { body, senderId: "sender" },
    firestore: fakeFirestore({
      friend: { name: "Grace", fcmToken: "friend-token" },
    }),
    messaging,
    logger: silentLogger(),
  });

  const preview = messaging.batches[0][0].notification.body;
  assert.equal(preview.length, 120);
  assert.equal(preview.endsWith("..."), true);
  assert.equal(preview.includes("  "), false);
});

test("does not fail the trigger for an unusable token", async () => {
  const errors = [];
  const messaging = fakeMessaging([
    {
      success: false,
      error: { code: "messaging/registration-token-not-registered" },
    },
  ]);

  await notifyNewMessage({
    messageId: "msg-7",
    message: { body: "hello", senderId: "sender" },
    firestore: fakeFirestore({
      friend: { name: "Grace", fcmToken: "stale-token" },
    }),
    messaging,
    logger: {
      error(message, fields) {
        errors.push({ message, fields });
      },
    },
  });

  assert.equal(errors.length, 1);
  assert.equal(errors[0].fields.uid, "friend");
  assert.equal(JSON.stringify(errors[0]).includes("stale-token"), false);
});

test("fails when FCM returns a retryable error", async () => {
  const messaging = fakeMessaging([
    { success: false, error: { code: "messaging/internal-error" } },
  ]);

  await assert.rejects(
    notifyNewMessage({
      messageId: "msg-8",
      message: { body: "hello", senderId: "sender" },
      firestore: fakeFirestore({
        friend: { name: "Grace", fcmToken: "friend-token" },
      }),
      messaging,
      logger: silentLogger(),
    }),
    /FCM send failed/,
  );
});

function fakeFirestore(users) {
  return {
    collection(name) {
      assert.equal(name, "users");
      return {
        async get() {
          return {
            docs: Object.entries(users).map(([id, data]) => ({
              id,
              get(field) {
                return data[field];
              },
            })),
          };
        },
      };
    },
  };
}

function fakeMessaging(responses) {
  const messaging = {
    batches: [],
    async sendEach(messages) {
      messaging.batches.push(messages);
      const results =
        responses ?? messages.map(() => ({ success: true }));
      return { responses: results };
    },
  };
  return messaging;
}

function silentLogger() {
  return { error() {} };
}
