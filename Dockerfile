FROM denoland/deno:alpine-2.8.2 AS deps
WORKDIR /app
COPY deno.json deno.lock main.ts ./
RUN deno cache main.ts

FROM denoland/deno:alpine-2.8.2 AS runtime
WORKDIR /app
COPY --from=deps /deno-dir /deno-dir
COPY deno.json deno.lock main.ts ./
COPY icons ./icons

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s \
  CMD wget --spider --tries=1 http://127.0.0.1:8000/index.json || exit 1

CMD ["deno", "run", "--allow-net", "--allow-read", "main.ts"]
