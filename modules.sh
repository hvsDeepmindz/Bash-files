#!/bin/bash

npm install react-redux react-icons react-router-dom @reduxjs/toolkit tailwindcss @tailwindcss/vite react-helmet-async antd framer-motion

if ! grep -q "@tailwindcss/vite" vite.config.js; then
  sed -i '1s/^/import tailwindcss from "@tailwindcss\/vite";\n/' vite.config.js 2>/dev/null || sed -i '' '1s/^/import tailwindcss from "@tailwindcss\/vite";\n/' vite.config.js
  sed -i 's/plugins: \[/plugins: \[tailwindcss(), /' vite.config.js 2>/dev/null || sed -i '' 's/plugins: \[/plugins: \[tailwindcss(), /' vite.config.js
fi

cat <<EOF > .env
VITE_BASE_URL=/
VITE_API_URL=http://localhost:5000/
EOF

cat <<EOF > Dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

cat <<EOF > .dockerignore
node_modules
dist
.git
.gitignore
Dockerfile
npm-debug.log
EOF
