# ── Stage 1: Build ────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production

# ── Stage 2: Run ──────────────────────────────
FROM node:20-alpine AS runner

WORKDIR /app

# Copy only production node_modules from builder
COPY --from=builder /app/node_modules ./node_modules

COPY . .

EXPOSE 3000

CMD ["node", "index.js"]