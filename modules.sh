#!/bin/bash

npm install react-redux react-icons react-router-dom @reduxjs/toolkit tailwindcss @tailwindcss/vite antd framer-motion axios react-toastify react-markdown remark-gfm

if ! grep -q "@tailwindcss/vite" vite.config.js; then
  sed -i '1s/^/import tailwindcss from "@tailwindcss\/vite";\n/' vite.config.js 2>/dev/null || sed -i '' '1s/^/import tailwindcss from "@tailwindcss\/vite";\n/' vite.config.js
  sed -i 's/plugins: \[/plugins: \[tailwindcss(), /' vite.config.js 2>/dev/null || sed -i '' 's/plugins: \[/plugins: \[tailwindcss(), /' vite.config.js
fi

rm -f src/App.css
mkdir -p src/utils
mkdir -p src/features
mkdir -p src/features/auth
mkdir -p src/features/auth/pages
mkdir -p src/features/auth/components
mkdir -p src/features/auth/services
mkdir -p src/features/auth/services/toolkit
mkdir -p src/features/auth/services/apis
mkdir -p src/features/auth/services/data
mkdir -p src/globalComponents
mkdir -p src/globalService
mkdir -p src/globalComponents/btns
mkdir -p src/globalComponents/design
mkdir -p public/images
mkdir -p public/videos
mkdir -p public/icons
mkdir -p .vscode
mkdir -p src/features/chatBot
mkdir -p src/features/chatBot/components
mkdir -p src/features/chatBot/pages
mkdir -p src/features/chatBot/services
mkdir -p src/features/chatBot/services/apis
mkdir -p src/features/chatBot/services/data
mkdir -p src/features/chatBot/services/toolkit

cat <<EOF > src/utils/axiosInstance.js
import axios from "axios";

const axiosInstance = axios.create({
  baseURL: import.meta.env.VITE_APP_BACKEND_URL,
  withCredentials: true,
});

axiosInstance.interceptors.request.use(
  (config) => {
    config.withCredentials = true;
    config.headers["Access-Control-Allow-Origin"] =
      import.meta.env.VITE_APP_BACKEND_URL;
    config.headers["Access-Control-Allow-Methods"] =
      "GET,POST,PUT,DELETE,OPTIONS";
    config.headers["Access-Control-Allow-Headers"] =
      "Content-Type, Authorization";
    return config;
  },
  (error) => Promise.reject(error)
);

axiosInstance.interceptors.response.use(
  (response) => {
    if (response?.headers?.location) {
      window.location.href = response.headers.location;
      return;
    }
    return response;
  },
  (error) => {
    if (error?.response?.headers?.location) {
      window.location.href = error.response.headers.location;
      return;
    }
    return Promise.reject(error.response?.data || error);
  }
);

export const apiRequest = async ({
  method,
  url,
  data,
  params,
  headers,
  baseURL,
  withCredentials = true,
}) => {
  const instance = baseURL
    ? axios.create({ baseURL, withCredentials })
    : axiosInstance;

  return instance({
    method,
    url,
    data,
    params,
    headers,
    withCredentials,
  }).then((res) => res.data);
};

export default axiosInstance;
EOF

cat <<EOF > src/utils/formatUtils.js
export const formatFileSize = (bytes) => {
  if (!bytes) return "0 B";
  const units = ["B", "KB", "MB", "GB", "TB"];
  let i = Math.floor(Math.log(bytes) / Math.log(1024));
  return (bytes / Math.pow(1024, i)).toFixed(1) + " " + units[i];
};

export const formatDate = (dateString) => {
  const options = {
    year: "numeric",
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
    hour12: true,
    timeZone: "UTC",
  };
  const date = new Date(dateString);
  return date.toLocaleDateString("en-US", options).replace(",", " |");
};

export const formatTime = (dateString) => {
  const date = new Date(dateString);
  return date.toLocaleTimeString("en-US", {
    hour: "2-digit",
    minute: "2-digit",
    hour12: true,
  });
};

export const formatRelativeTime = (dateString) => {
  const rtf = new Intl.RelativeTimeFormat("en", { numeric: "auto" });
  const diff = (new Date(dateString) - new Date()) / 1000;
  const units = [
    { sec: 60, name: "second" },
    { sec: 3600, name: "minute" },
    { sec: 86400, name: "hour" },
    { sec: 604800, name: "day" },
    { sec: 2592000, name: "week" },
    { sec: 31536000, name: "month" },
  ];
  for (let i = units.length - 1; i >= 0; i--) {
    if (Math.abs(diff) >= units[i].sec)
      return rtf.format(Math.round(diff / units[i].sec), units[i].name);
  }
  return rtf.format(Math.round(diff), "second");
};
EOF

cat <<EOF > src/index.css
@import "tailwindcss";

@layer utilities {
  .no-scrollbar::-webkit-scrollbar {
    display: none;
  }
  .no-scrollbar {
    -ms-overflow-style: none;
    scrollbar-width: none;
  }
  .custom-scrollbar::-webkit-scrollbar {
    height: 8px;
  }
  .custom-scrollbar::-webkit-scrollbar-track {
    background: #f1f1f1;
  }
  .custom-scrollbar::-webkit-scrollbar-thumb {
    background-color: #cacaca;
    border-radius: 10px;
  }
  .custom-scrollbar::-webkit-scrollbar-thumb:hover {
    background-color: rgb(170, 167, 167);
  }
}

* {
  font-family: 'Lato', sans-serif;
}

html {
  font-size: 100%;
  overflow-x: hidden;
}

body {
  font-weight: 500;
  background-color: #f4fcff;
  overflow-x: hidden;
}

@keyframes glow {
  0% {
    box-shadow: 0 0 5px rgba(105, 167, 195, 0.5), 0 0 10px rgba(72, 179, 228, 0.5);
    transform: scale(1);
  }
  50% {
    box-shadow: 0 0 5px rgb(255, 255, 255), 0 0 25px rgb(255, 255, 255);
    transform: scale(1.02);
  }
  100% {
    box-shadow: 0 0 5px rgba(255, 255, 255, 0.5), 0 0 10px rgba(255, 255, 255, 0.5);
    transform: scale(1);
  }
}

.custom-tooltip .ant-tooltip-inner {
  max-width: 400px !important;
  width: auto !important;
}

.glowing-img {
  animation: glow 1.5s ease-in-out infinite;
}

.custom-toast-container {
  font-size: 1.2rem;
  line-height: 1.5;
}

.Toastify__toast {
  border-radius: 8px !important;
  font-weight: 500 !important;
  font-size: 1.2rem !important;
  min-width: 500px !important;
  padding: 1rem 1rem !important;
}

.Toastify__toast--success {
  background: darkgreen !important;
  color: white !important;
  font-weight: 600 !important;
}

.Toastify__toast--success .Toastify__toast-icon svg {
  fill: white !important;
}

.Toastify__toast--info {
  background: rgb(96, 96, 195) !important;
  color: white !important;
  font-weight: 600 !important;
}

.Toastify__toast--info .Toastify__toast-icon svg {
  fill: white !important;
}

.Toastify__toast--error {
  background: orangered !important;
  color: white !important;
  font-weight: 600 !important;
}

.Toastify__toast--error .Toastify__toast-icon svg {
  fill: white !important;
}

.Toastify__toast--warning {
  background: rgb(161, 122, 24) !important;
  color: white !important;
  font-weight: 600 !important;
}

.Toastify__toast--warning .Toastify__toast-icon svg {
  fill: white !important;
}

.ant-switch-checked {
  background-color: goldenrod !important;
}

.custom-pagination .ant-pagination-item {
  border-radius: 9999px;
  border: 1px solid #d2d2d2;
  color: #666666;
}

.custom-pagination .ant-pagination-item-active {
  background-color: #111B69;
  border-color: transparent;
  color: white;
}

.custom-pagination .ant-pagination-item-active a {
  color: white !important;
}

.custom-pagination .ant-pagination-item:hover {
  border-color: #623AA2;
  color: #623AA2;
}

.custom-pagination .ant-pagination-prev .ant-pagination-item-link,
.custom-pagination .ant-pagination-next .ant-pagination-item-link {
  border-radius: 9999px;
  border: 1px solid #d2d2d2;
  color: #623AA2;
}

.custom-pagination .ant-pagination-disabled .ant-pagination-item-link {
  color: #a3a0a0 !important;
  cursor: not-allowed;
}

.custom-pagination .ant-pagination-options {
  display: inline-flex !important;
  visibility: visible !important;
}

.custom-pagination .ant-pagination-options-size-changer,
.custom-pagination .ant-pagination-options-quick-jumper {
  display: inline-flex !important;
  visibility: visible !important;
}

@media(max-width: 1500px) {
  html {
    font-size: 90%;
  }
}

@media(max-width: 1024px) {
  html {
    font-size: 80%;
  }
}
EOF

cat <<EOF > .env
VITE_BASE_URL=/
VITE_API_URL=http://localhost:5000/
VITE_APP_BACKEND_URL=http://localhost:5000/backend
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

touch src/features/auth/components/AuthMain.jsx
touch src/features/auth/components/SignupMain.jsx
touch src/features/auth/pages/Auth.jsx
touch src/features/auth/pages/Signup.jsx
touch src/ProtectedRoute.jsx
touch src/utils/Store.js
touch src/Default.jsx
touch src/AppRoutes.js
touch src/DefaultTable.jsx
touch src/features/auth/services/AuthPayload.js
touch src/features/auth/services/toolkit/AuthSlice.js
touch src/features/auth/services/toolkit/AuthHandlers.js
touch src/globalComponents/btns/ViewBtn.jsx
touch src/globalComponents/Header.jsx
touch src/globalComponents/Footer.jsx
touch src/globalComponents/Table.jsx
touch .vscode/settings.json
touch src/globalService/GlobalSlice.js
touch src/globalService/GlobalHandlers.js
touch src/globalService/Data.js
touch src/features/chatBot/components/ChatBotMain.jsx
touch src/features/chatBot/pages/ChatBot.jsx
touch src/features/chatBot/services/toolkit/ChatBotSlice.js
touch src/features/chatBot/services/toolkit/ChatBotHandlers.js
touch src/features/chatBot/services/ChatBotPayload.js
