import { Hono } from "hono";
import { logger } from "hono/logger";
import { serveStatic } from "hono/deno";
import { rateLimiter } from "hono-rate-limiter";

const app = new Hono();

app.use(logger());
app.use(rateLimiter({
  windowMs: 60_000,
  limit: 1000,
  standardHeaders: "draft-7",
  keyGenerator: (c) =>
    c.req.header("x-forwarded-for")?.split(",")[0].trim() ?? "unknown",
}));

app.use("/icons/*", serveStatic({ root: "./" }));
app.use("/*", serveStatic({ root: "./specs" }));

Deno.serve(app.fetch);
