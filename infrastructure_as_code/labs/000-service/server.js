const http = require("http");

const port = process.env.PORT || 3000;


const server = http.createServer((req, res) => {
    const send = ((res) => (status, body) => {
        res.statusCode = status;
        res.setHeader("Content-Type", "application/json");
        res.write(JSON.stringify(body));
        res.end();
    })(res);

    if (req.method !== "GET") {
        return send(405, { error: "Method not allowed" });
    }

    if (req.url === "/health") {
        return send(200, { status: "ok" });
    }

    if (req.url === "/") {
        return send(200, {
            message: "Welcome to the service",
            config: {
                port: port,
                name: process.env.NAME || "",
                image: process.env.IMAGE || "",
                project_id: process.env.PROJECT_ID || "",
            }
         });
    }
    return send(405, { error: "Method not allowed" });
})

server.listen(port, () => {
    console.log(`Server listening on port ${port}`);
});
process.on('SIGINT', process.exit);