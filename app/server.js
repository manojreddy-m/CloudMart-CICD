const http = require("node:http");
const fs = require("node:fs");
const path = require("node:path");

const PORT = Number(process.env.PORT || 3000);
const publicDir = path.join(__dirname, "public");

const mimeTypes = {
  ".html": "text/html; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".js": "text/javascript; charset=utf-8"
};

const server = http.createServer((req, res) => {
  const pathname = new URL(
    req.url,
    `http://${req.headers.host || "localhost"}`
  ).pathname;

  if (pathname === "/health") {
    res.writeHead(200, { "Content-Type": "application/json" });
    return res.end(JSON.stringify({ status: "ok", app: "CloudMart" }));
  }

  const routes = {
    "/": "index.html",
    "/style.css": "style.css",
    "/app.js": "app.js"
  };

  const filename = routes[pathname];

  if (!filename) {
    res.writeHead(404);
    return res.end("Not Found");
  }

  const filePath = path.join(publicDir, filename);

  fs.readFile(filePath, (err, content) => {
    if (err) {
      res.writeHead(500);
      return res.end("Internal Server Error");
    }

    res.writeHead(200, {
      "Content-Type": mimeTypes[path.extname(filename)]
    });
    res.end(content);
  });
});

server.listen(PORT, "0.0.0.0", () => {
  console.log(`CloudMart listening on port ${PORT}`);
});

module.exports = server;
