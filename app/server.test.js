const test = require("node:test");
const assert = require("node:assert/strict");

test("CloudMart health endpoint returns OK", async () => {
  const server = require("./server");

  await new Promise((resolve) => {
    if (server.listening) return resolve();
    server.once("listening", resolve);
  });

  const address = server.address();
  const response = await fetch(`http://127.0.0.1:${address.port}/health`);
  const body = await response.json();

  assert.equal(response.status, 200);
  assert.equal(body.status, "ok");
  assert.equal(body.app, "CloudMart");

  await new Promise((resolve, reject) => {
    server.close((err) => err ? reject(err) : resolve());
  });
});
