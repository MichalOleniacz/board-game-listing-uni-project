# ui/Dockerfile

FROM node:20-alpine AS builder
WORKDIR /app

# Copy only what's needed for dependency install
COPY package*.json ./
COPY vite.config.js ./

# Install dependencies first to leverage Docker cache
RUN npm install

# Now copy everything else (source code, html, etc.)
COPY . .

# Build production files
RUN npm run build

# Stage 2: Serve with NGINX
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
