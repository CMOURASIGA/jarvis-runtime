FROM node:22-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    bash \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g openclaw@latest

WORKDIR /app

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 8080

CMD ["/app/start.sh"]
