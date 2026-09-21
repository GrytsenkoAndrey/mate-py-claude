FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# ── Base tools ──
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        gnupg \
        git \
        build-essential \
    && rm -rf /var/lib/apt/lists/*

# ── Node.js 22 ──
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ── User ──
RUN groupadd -g 1000 tcc && useradd -u 1000 -g tcc -m tcc && su tcc

# ── Claude Code + Codex ──
ARG CLAUDE_CODE_VERSION=latest
ARG CODEX_VERSION=latest
RUN npm install -g @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION} @openai/codex@${CODEX_VERSION} \
    && CLAUDE_BIN="$(command -v claude)" \
    && CODEX_BIN="$(command -v codex)" \
    && NPM_GLOBAL_DIR="$(npm root -g)" \
    && chown -R tcc:tcc "$NPM_GLOBAL_DIR" \
    && chown tcc:tcc "$CLAUDE_BIN" "$CODEX_BIN"

# ── App ──
WORKDIR /app

COPY --chown=tcc:tcc package*.json ./
RUN npm install

COPY --chown=tcc:tcc . .

USER tcc

EXPOSE 3000

CMD ["npm", "run", "dev"]
