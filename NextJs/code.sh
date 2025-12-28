#!/bin/bash

cat > src/app/page.tsx << 'EOF'
import { redirect } from "next/navigation";

export default function Page() {
  redirect("/default");
}
EOF

cat > src/app/layout.tsx << 'EOF'
import type { Metadata } from "next";
import ClientRootLayout from "./ClientRootLayout";

export const metadata: Metadata = {
  title: "Hvs Next App",
  description: "Created by Harshvardhan Sharma",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <ClientRootLayout>{children}</ClientRootLayout>;
}
EOF

cat > src/app/ClientRootLayout.tsx << 'EOF'
"use client";

import { Geist, Geist_Mono } from "next/font/google";
import Script from "next/script";
import { usePathname } from "next/navigation";
import { ToastContainer } from "react-toastify";
import Header from "@/globalComponents/Header";
import Footer from "@/globalComponents/Footer";
import Providers from "./providers";
import "./globals.css";
import "react-toastify/dist/ReactToastify.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export default function ClientRootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const hideLayout = ["/auth", "/signup"].includes(pathname);

  return (
    <html lang="en">
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased relative flex flex-col min-h-screen`}
      >
        <Script
          src="https://kit.fontawesome.com/c855874020.js"
          crossOrigin="anonymous"
          strategy="afterInteractive"
        />

        <ToastContainer
          className="custom-toast-container"
          autoClose={3000}
          position="bottom-right"
        />

        <Providers>
          {!hideLayout && <Header />}
          <div className="flex-1 w-full">{children}</div>
          {!hideLayout && <Footer />}
        </Providers>
      </body>
    </html>
  );
}
EOF

cat > src/app/providers.tsx << 'EOF'
"use client";

import { Provider } from "react-redux";
import { store } from "@/utils/Store";

export default function Providers({ children }: { children: React.ReactNode }) {
  return <Provider store={store}>{children}</Provider>;
}
EOF

cat > src/app/global.css << 'EOF'
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

cat > src/app/auth/page.tsx << 'EOF'
import AuthMain from "@/features/auth/components/AuthMain";
import React from "react";

const Auth: React.FC = () => {
  return (
    <>
      <div className={`relative w-full h-full`}>
        <AuthMain />
      </div>
    </>
  );
};

export default Auth;
EOF

cat > src/app/signup/page.tsx << 'EOF'
import SignupMain from "@/features/auth/components/SignupMain";
import React from "react";

const Signup = () => {
  return (
    <>
      <div className={`relative w-full h-full`}>
        <SignupMain />
      </div>
    </>
  );
};

export default Signup;
EOF

cat > src/app/chatBot/page.tsx << 'EOF'
import ChatBotMain from "@/features/chatBot/components/ChatBotMain";
import React from "react";

const ChatBot: React.FC = () => {
  return (
    <>
      <div className={`relative w-full h-full`}>
        <ChatBotMain />
      </div>
    </>
  );
};

export default ChatBot;
EOF

cat > src/app/default/page.tsx << 'EOF'
/* eslint-disable @typescript-eslint/no-unused-vars */
"use client";

import React from "react";
import ChatBot from "../chatBot/page";
import { GiRobotGolem } from "react-icons/gi";
import DefaultTable from "@/features/default/components/DefaultTable";

const Default: React.FC = () => {
  return (
    <>
      <div
        className={`w-full min-h-screen px-32 bg-[#d7fff3] flex flex-col gap-12 items-center justify-center`}
      >
        <div className={`flex gap-8 items-center justify-center text-center`}>
          <GiRobotGolem
            size={30}
            className={`text-2xl animate-bounce text-[#414141]`}
          />
          <h1 className={`text-4xl font-extrabold text-[#5959ad]`}>
            Welcome to Hvs Great Next App
          </h1>
          <GiRobotGolem
            size={30}
            className={`text-2xl animate-bounce text-[#414141]`}
          />
        </div>
        <DefaultTable />
        <ChatBot />
      </div>
    </>
  );
};

export default Default;
EOF

cat > src/features/auth/components/AuthMain.tsx << 'EOF'
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-unused-vars */

"use client";

import React, { useEffect, useRef, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { motion } from "framer-motion";
import {
  setUserMode,
  setPassword,
  setUsername,
} from "../services/toolkit/authSlice";
import ViewBtn from "../../../globalComponents/btns/ViewBtn";
import { FaCircleUser } from "react-icons/fa6";
import { TbLoader2 } from "react-icons/tb";
import { handleLogin } from "../services/toolkit/authHandlers";
import { useRouter } from "next/navigation";

const AuthMain = () => {
  const dispatch = useDispatch<any>();
  const { isLogin, username, password } = useSelector(
    (state: any) => state.authApp
  );
  const [showPassword, setShowPassword] = useState<any>(false);
  const router = useRouter();

  return (
    <div className="relative w-screen h-screen overflow-hidden bg-[#93c4d0]">
      <div className="absolute inset-0 mt-0 flex items-center justify-center">
        <motion.div
          initial={{ scale: 0.5, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ duration: 0.6, ease: "easeOut" }}
          className="backdrop-blur-sm bg-white rounded-3xl shadow-2xl 
            px-14 py-14 w-[35vw] flex flex-col gap-10"
        >
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.5 }}
            className="flex items-center justify-center gap-4"
          >
            <FaCircleUser
              size={50}
              className={`text-[#2957a2] shadow-xl rounded-full`}
            />
            <h2 className="font-semibold text-4xl text-[#111B69] italic">
              User Login
            </h2>
          </motion.div>
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.7 }}
            className="flex flex-col gap-6 w-full"
          >
            <label
              htmlFor="username"
              className="text-2xl font-bold text-[#37468a] tracking-wide flex items-center gap-[1.2rem]"
            >
              <div className="w-12 h-12 rounded-full bg-[#dfe6ff] flex items-center justify-center shadow-md">
                <i className="fa-solid fa-user-tie text-[#37468a] text-2xl" />
              </div>
              Username
            </label>
            <input
              type="text"
              id="username"
              value={username}
              onChange={(e) => {
                dispatch(setUsername(e.target.value));
              }}
              onKeyDown={(e) => {
                if (e.key === "Enter" && !isLogin) {
                  dispatch(handleLogin({ username, password }));
                }
              }}
              required
              autoComplete="off"
              placeholder="Enter your username"
              className={`w-full px-8 py-4 rounded-2xl bg-white/90 border-2 border-[#b5c4ff] text-xl font-semibold text-[#2b2b2b] focus:border-[#1b275b] focus:shadow-lg transition-all duration-300 outline-none ${
                isLogin ? "cursor-not-allowed" : ""
              }`}
            />
          </motion.div>

          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 1.0 }}
            className="flex flex-col gap-6 w-full"
          >
            <label
              htmlFor="password"
              className="text-2xl font-bold text-[#37468a] tracking-wide flex items-center gap-[1.2rem]"
            >
              <div className="w-12 h-12 rounded-full bg-[#dfe6ff] flex items-center justify-center shadow-md">
                <i className="fa-solid fa-key text-[#37468a] text-2xl" />
              </div>
              Password
            </label>
            <div className="relative w-full">
              <input
                type={showPassword ? "text" : "password"}
                id="password"
                required
                autoComplete="off"
                value={password}
                onChange={(e) => {
                  dispatch(setPassword(e.target.value));
                }}
                onKeyDown={(e) => {
                  if (e.key === "Enter" && !isLogin) {
                    dispatch(handleLogin({ username, password }));
                  }
                }}
                placeholder="Enter your password"
                className={`w-full px-8 py-4 rounded-2xl bg-white/90 border-2 border-[#b5c4ff] text-xl font-semibold text-[#2b2b2b] focus:border-[#1b275b] focus:shadow-lg transition-all duration-300 outline-none ${
                  isLogin ? "cursor-not-allowed" : ""
                }`}
              />
              <div
                onClick={() => setShowPassword(!showPassword)}
                className="absolute right-6 top-1/2 -translate-y-1/2 cursor-pointer text-xl text-[#37468a]"
              >
                <i
                  className={`fa-solid ${
                    showPassword ? "fa-eye" : "fa-eye-slash"
                  }`}
                ></i>
              </div>
            </div>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 1.3 }}
            className="w-full"
          >
            <ViewBtn
              btnTitle={
                isLogin ? (
                  <div className="flex items-center justify-center">
                    <TbLoader2 size={30} className={`text-white`} />
                  </div>
                ) : (
                  `Login`
                )
              }
              btnFunc={() => dispatch(handleLogin({ username, password }))}
              disabled={isLogin}
              view={`full`}
              btnType={`Login`}
            />
          </motion.div>

          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.1, delay: 0.2 }}
            className={`flex items-center gap-2 justify-center`}
          >
            <h2 className={`text-xl text-[#212121] font-semibold`}>
              Not registered yet?
            </h2>
            <span
              onClick={
                isLogin
                  ? undefined
                  : () => {
                      router.push("/signup");
                    }
              }
              className={`text-[#543b7e] font-semibold text-xl underline cursor-pointer ${
                isLogin ? "pointer-events-none opacity-60" : ""
              }`}
              tabIndex={isLogin ? -1 : 0}
              aria-disabled={isLogin}
            >
              Signup now
            </span>
          </motion.div>
        </motion.div>
      </div>
    </div>
  );
};

export default AuthMain;
EOF

cat > src/features/auth/components/SignupMain.tsx << 'EOF'
/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-explicit-any */

"use client";

import React, { useEffect, useRef, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { motion } from "framer-motion";
import {
  setUserMode,
  setSelectRole,
  setCreateUsername,
  setCreateEmail,
  setCreatePassword,
} from "../services/toolkit/authSlice";
import ViewBtn from "../../../globalComponents/btns/ViewBtn";
import { FaCircleUser } from "react-icons/fa6";
import { handleSignup } from "../services/toolkit/authHandlers";
import { TbLoader2 } from "react-icons/tb";
import { useRouter } from "next/navigation";

const SignupMain = () => {
  const dispatch = useDispatch<any>();
  const { selectRole, isSignup, createUsername, createEmail, createPassword } =
    useSelector((state: any) => state.authApp);
  const [showPassword, setShowPassword] = useState<any>(false);
  const router = useRouter();

  return (
    <>
      <div
        className={`relative w-screen h-screen overflow-hidden bg-[#93c4d0]`}
      >
        <div
          className={`absolute inset-0 mt-0 flex items-center justify-center`}
        >
          <motion.div
            initial={{ scale: 0.5, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{ duration: 0.6, ease: "easeOut" }}
            className="backdrop-blur-sm bg-white rounded-3xl shadow-2xl px-14 
            py-14 w-[50vw] flex flex-col gap-10"
          >
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.7, delay: 0.5 }}
              className="flex items-center justify-center gap-4"
            >
              <FaCircleUser
                size={50}
                className={`text-[#2957a2] shadow-xl rounded-full`}
              />
              <h2 className="font-semibold text-4xl text-[#111B69] italic">
                User Signup
              </h2>
            </motion.div>

            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.7, delay: 0.7 }}
              className={`grid grid-cols-2 gap-8 justify-center`}
            >
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.7, delay: 0.7 }}
                className="flex flex-col gap-6 w-full"
              >
                <label
                  htmlFor="createUsername"
                  className="text-2xl font-bold text-[#37468a] tracking-wide flex items-center gap-[1.2rem]"
                >
                  <div className="w-12 h-12 rounded-full bg-[#dfe6ff] flex items-center justify-center shadow-md">
                    <i className="fa-solid fa-user-tie text-[#37468a] text-2xl" />
                  </div>
                  Create Username
                </label>
                <input
                  type="text"
                  id="createUsername"
                  required
                  autoComplete="off"
                  value={createUsername}
                  onChange={(e) => {
                    dispatch(setCreateUsername(e.target.value));
                  }}
                  onKeyDown={(e) => {
                    if (e.key === "Enter" && !isSignup) {
                      dispatch(
                        handleSignup({
                          createUsername,
                          createEmail,
                          createPassword,
                        })
                      );
                    }
                  }}
                  placeholder="Set your username"
                  className={`w-full px-8 py-4 rounded-2xl bg-white/90 border-2 border-[#b5c4ff] text-xl font-semibold text-[#2b2b2b] focus:border-[#1b275b] focus:shadow-lg transition-all duration-300 outline-none ${
                    isSignup ? "cursor-not-allowed" : ""
                  }`}
                />
              </motion.div>
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.7, delay: 1.0 }}
                className="flex flex-col gap-6 w-full"
              >
                <label
                  htmlFor="email"
                  className="text-2xl font-bold text-[#37468a] tracking-wide flex items-center gap-[1.2rem]"
                >
                  <div className="w-12 h-12 rounded-full bg-[#dfe6ff] flex items-center justify-center shadow-md">
                    <i className="fa-solid fa-envelope text-[#37468a] text-2xl" />
                  </div>
                  Email
                </label>
                <input
                  type="text"
                  id="email"
                  required
                  value={createEmail}
                  onChange={(e) => {
                    dispatch(setCreateEmail(e.target.value));
                  }}
                  onKeyDown={(e) => {
                    if (e.key === "Enter" && !isSignup) {
                      dispatch(
                        handleSignup({
                          createUsername,
                          createEmail,
                          createPassword,
                        })
                      );
                    }
                  }}
                  autoComplete="off"
                  placeholder="Set your email"
                  className={`w-full px-8 py-4 rounded-2xl bg-white/90 border-2 border-[#b5c4ff] text-xl font-semibold text-[#2b2b2b] focus:border-[#1b275b] focus:shadow-lg transition-all duration-300 outline-none ${
                    isSignup ? "cursor-not-allowed" : ""
                  }`}
                />
              </motion.div>
            </motion.div>
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.7, delay: 1.0 }}
              className={`grid grid-cols-2 gap-8 justify-center`}
            >
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.7, delay: 1.3 }}
                className="flex flex-col gap-6 w-full"
              >
                <label
                  htmlFor="password"
                  className="text-2xl font-bold text-[#37468a] tracking-wide flex items-center gap-[1.2rem]"
                >
                  <div className="w-12 h-12 rounded-full bg-[#dfe6ff] flex items-center justify-center shadow-md">
                    <i className="fa-solid fa-key text-[#37468a] text-2xl" />
                  </div>
                  Create Password
                </label>
                <div className="relative w-full">
                  <input
                    type={showPassword ? "text" : "password"}
                    id="password"
                    required
                    value={createPassword}
                    onChange={(e) => {
                      dispatch(setCreatePassword(e.target.value));
                    }}
                    onKeyDown={(e) => {
                      if (e.key === "Enter" && !isSignup) {
                        dispatch(
                          handleSignup({
                            createUsername,
                            createEmail,
                            createPassword,
                          })
                        );
                      }
                    }}
                    autoComplete="off"
                    placeholder="Set your password"
                    className={`w-full px-8 py-4 rounded-2xl bg-white/90 border-2 border-[#b5c4ff] text-xl font-semibold text-[#2b2b2b] focus:border-[#1b275b] focus:shadow-lg transition-all duration-300 outline-none ${
                      isSignup ? "cursor-not-allowed" : ""
                    }`}
                  />
                  <div
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-6 top-1/2 -translate-y-1/2 cursor-pointer text-xl text-[#37468a]"
                  >
                    <i
                      className={`fa-solid ${
                        showPassword ? "fa-eye" : "fa-eye-slash"
                      }`}
                    ></i>
                  </div>
                </div>
              </motion.div>
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.7, delay: 1.5 }}
                className="flex flex-col gap-6 w-full"
              >
                <label
                  htmlFor="signup-password"
                  className="text-2xl font-bold text-[#37468a] tracking-wide flex items-center gap-[1.2rem]"
                >
                  <div className="w-12 h-12 rounded-full bg-[#dfe6ff] flex items-center justify-center shadow-md">
                    <i className="fa-solid fa-key text-[#37468a] text-2xl" />
                  </div>
                  Role
                </label>
                <div className="relative w-full">
                  <select
                    id="userRole"
                    value={selectRole}
                    required
                    onChange={(e) => dispatch(setSelectRole(e.target.value))}
                    className={`w-full px-8 py-4 rounded-2xl bg-white/90 border-2 border-[#b5c4ff] text-xl font-semibold text-[#2b2b2b] focus:border-[#1b275b] focus:shadow-lg transition-all duration-300 outline-none cursor-pointer ${
                      isSignup ? "cursor-not-allowed" : ""
                    }`}
                  >
                    {["admin", "user"].map((role, index) => (
                      <option key={index}>{role.toLocaleLowerCase()}</option>
                    ))}
                  </select>
                </div>
              </motion.div>
            </motion.div>
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.7, delay: 1.7 }}
              className="w-full mt-0"
            >
              <ViewBtn
                btnTitle={
                  isSignup ? (
                    <div className="flex items-center justify-center">
                      <TbLoader2 size={30} className={`text-white`} />
                    </div>
                  ) : (
                    `Signup`
                  )
                }
                btnFunc={() =>
                  dispatch(
                    handleSignup({
                      createUsername,
                      createEmail,
                      createPassword,
                    })
                  )
                }
                disabled={isSignup}
                view={`full`}
                btnType={`Signup`}
              />
            </motion.div>

            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.1, delay: 0.2 }}
              className="flex items-center gap-2 justify-center"
            >
              <h2 className="text-xl text-[#212121] font-semibold">
                Already have account?
              </h2>
              <span className="text-[#212121] font-semibold text-xl cursor-pointer">
                Back to
              </span>
              <span
                onClick={
                  isSignup
                    ? undefined
                    : () => {
                        router.push("/auth");
                      }
                }
                className={`text-[#543b7e] font-semibold text-xl underline cursor-pointer ${
                  isSignup ? "pointer-events-none opacity-60" : ""
                }`}
                tabIndex={isSignup ? -1 : 0}
                aria-disabled={isSignup}
              >
                Login
              </span>
            </motion.div>
          </motion.div>
        </div>
      </div>
    </>
  );
};

export default SignupMain;
EOF

cat > src/features/auth/services/toolkit/authSlice.ts << 'EOF'
/* eslint-disable @typescript-eslint/no-explicit-any */
import { createSlice, PayloadAction } from "@reduxjs/toolkit";

const initialState = {
  isAuthenticated: false,
  isLogin: false,
  isSignup: false,
  isLogout: false,
  loadingUserInfo: true,
  selectRole: "admin",
  userInfo: null,
  userMode: "login",
  username: "",
  password: "",
  createUsername: "",
  createEmail: "",
  createPassword: "",
};

const Slice = createSlice({
  name: "authApp",
  initialState,
  reducers: {
    setIsAuthenticated: (s, a: PayloadAction<boolean>) => {
      s.isAuthenticated = a.payload;
    },
    setIsLogin: (s, a: PayloadAction<boolean>) => {
      s.isLogin = a.payload;
    },
    setIsSignup(s, a: PayloadAction<boolean>) {
      s.isSignup = a.payload;
    },
    setIsLogout(s, a: PayloadAction<boolean>) {
      s.isLogout = a.payload;
    },
    setLoadingUserInfo(s, a: PayloadAction<boolean>) {
      s.loadingUserInfo = a.payload;
    },
    setSelectRole(s, a: PayloadAction<string>) {
      s.selectRole = a.payload;
    },
    setUserInfo(s, a: PayloadAction<any>) {
      s.userInfo = a.payload;
    },
    setUserMode: (s, a: PayloadAction<string>) => {
      s.userMode = a.payload;
    },
    setUsername: (s, a: PayloadAction<string>) => {
      s.username = a.payload;
    },
    setPassword: (s, a: PayloadAction<string>) => {
      s.password = a.payload;
    },
    setCreateUsername: (s, a: PayloadAction<string>) => {
      s.createUsername = a.payload;
    },
    setCreateEmail: (s, a: PayloadAction<string>) => {
      s.createEmail = a.payload;
    },
    setCreatePassword: (s, a: PayloadAction<string>) => {
      s.createPassword = a.payload;
    },
  },
});

export const {
  setIsAuthenticated,
  setIsLogin,
  setIsSignup,
  setIsLogout,
  setLoadingUserInfo,
  setSelectRole,
  setUserInfo,
  setUserMode,
  setCreatePassword,
  setCreateUsername,
  setUsername,
  setCreateEmail,
  setPassword,
} = Slice.actions;

export default Slice.reducer;
EOF

cat > src/features/auth/services/toolkit/authHandlers.ts << 'EOF'
/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-explicit-any */
import { toast } from "react-toastify";
import {
  setIsAuthenticated,
  setIsLogin,
  setIsLogout,
  setIsSignup,
} from "./authSlice";
import { LoginTypes, SignupTypes } from "../../types/authValidators";

export const handleLogin =
  ({ username, password }: LoginTypes) =>
  async (dispatch: any) => {
    try {
      const fields = { username, password };
      const empty = Object.keys(fields).filter(
        (k) => !fields[k as keyof LoginTypes]
      );
      if (empty.length) {
        toast.warn(`Required ${empty.join(" and ")}`);
        return;
      }

      dispatch(setIsLogin(true));
      dispatch(setIsAuthenticated(true));
    } catch (err) {
      toast.error("Something went wrong while login!");
      dispatch(setIsAuthenticated(false));
    } finally {
      dispatch(setIsLogin(false));
    }
  };

export const handleSignup =
  ({ createUsername, createEmail, createPassword }: SignupTypes) =>
  async (dispatch: any) => {
    try {
      const fields = { createUsername, createEmail, createPassword };
      const empty = Object.keys(fields).filter(
        (k) => !fields[k as keyof SignupTypes]
      );
      if (empty.length) {
        toast.warn(`Required ${empty.join(" and ")}`);
        return;
      }
      dispatch(setIsSignup(true));
    } catch (err) {
      toast.error("Something went wrong while signup!");
    } finally {
      dispatch(setIsSignup(false));
    }
  };

export const handleLogout = () => async (dispatch: any) => {
  try {
    dispatch(setIsLogout(true));
    dispatch(setIsAuthenticated(false));
    toast.success("Logged out successfully");
  } catch (err) {
    toast.error("Something went wrong while logout!");
  } finally {
    dispatch(setIsLogout(false));
  }
};
EOF

cat > src/features/auth/types/authValidators.ts << 'EOF'
export interface LoginTypes {
  username?: string;
  password?: string;
}

export interface SignupTypes {
  createUsername?: string;
  createEmail?: string;
  createPassword?: string;
}
EOF

cat > src/features/default/components/DefaultTable.tsx << 'EOF'
/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-explicit-any */
import { useState } from "react";
import { Modal } from "antd";
import { formatDate } from "@/utils/formatUtils";
import { TableDummyData } from "@/globalService/Data";
import Table from "@/globalComponents/Table";

const DefaultTable = () => {
  const [selectedRow, setSelectedRow] = useState<any>(null);
  const [docModalVisible, setDocModalVisible] = useState<boolean>(false);
  const [docList, setDocList] = useState<string[]>([]);
  const [searchText, setSearchText] = useState<string>("");

  const defaultColumns = [
    { header: "ID", accessor: (row: any) => row.id },
    { header: "Name", accessor: (row: any) => row.name },
    { header: "Algorithm", accessor: (row: any) => row.algorithm },
    {
      header: "Created On",
      accessor: (row: any) => (
        <div className="flex items-center gap-4">
          <p className="text-xl text-[#888888] font-normal">
            {formatDate(row.created_on)}
          </p>
        </div>
      ),
    },
    {
      header: "Status",
      accessor: (row: any) => {
        let text = "#47B881";
        if (row.status === "Pending" || row.status === "Not Started") {
          text = "#FFC000";
        } else if (row.status === "Failed") {
          text = "red";
        }
        return (
          <span
            className="px-8 py-2 rounded-lg"
            style={{ backgroundColor: "#E9F6F0", color: text }}
          >
            {row.status}
          </span>
        );
      },
    },
  ];

  const filteredDocs = docList.filter((doc: string) =>
    doc.toLowerCase().includes(searchText.toLowerCase())
  );

  return (
    <>
      <Table
        tableTitle="Dataset Table"
        columns={defaultColumns}
        data={TableDummyData || []}
        tooltipShow={true}
        checkData={false}
        tableIndex={true}
      />

      <Modal
        open={docModalVisible}
        onCancel={() => setDocModalVisible(false)}
        footer={null}
        title="Documents"
        centered
      >
        <div className="flex flex-col gap-4">
          <div className="bg-[#FAFAFA] rounded-xl px-8 py-2 border border-[#d2d2d2] outline-none w-full flex items-center gap-4 mb-4">
            <i className="fa-solid fa-search text-2xl text-[#888888]" />
            <input
              type="text"
              placeholder="Search Pdf"
              value={searchText}
              onChange={(e) => setSearchText(e.target.value)}
              className="text-[#888888] text-2xl font-normal outline-none w-full"
            />
          </div>

          <div className="flex flex-col gap-8 custom-scrollbar overflow-y-auto max-h-[50vh] my-4">
            {filteredDocs.length > 0 ? (
              filteredDocs.map((doc: string, index: number) => (
                <div key={index} className="flex items-center gap-4">
                  <i className="fa-solid fa-document text-xl text-[#555598]" />
                  <p className="text-2xl text-[#888888] font-normal">{doc}</p>
                </div>
              ))
            ) : (
              <p className="text-2xl text-[orangered] text-center">
                Document not found
              </p>
            )}
          </div>
        </div>
      </Modal>
    </>
  );
};

export default DefaultTable;
EOF

cat > src/features/default/types/defaultValidators.ts << 'EOF'
/* eslint-disable @typescript-eslint/no-explicit-any */
import React from "react";

export interface TableColumn<T = any> {
  header: string;
  accessor: (row: T, index?: number) => React.ReactNode;
}

export interface TableProps<T = any> {
  tableTitle?: string;
  columns: TableColumn<T>[];
  data: T[];
  tooltipShow?: boolean;
  checkData?: boolean;
  tableIndex?: boolean;
  tableLoader?: boolean;
  detailMode?: boolean;
  detailView?: (row: T) => void;
}
EOF

cat > src/globalComponents/btns/ViewBtn.tsx << 'EOF'
import { BtnProps } from "@/utils/validators";
import React from "react";

const ViewBtn = ({
  btnTitle,
  btnClass,
  btnFunc,
  disabled = false,
  view,
  btnType,
}: BtnProps) => {
  return (
    <>
      <button
        onClick={btnFunc}
        disabled={disabled}
        className={`px-8 py-4 ${
          view === "auto" ? "w-auto" : "w-full"
        } text-[white] font-extrabold transition-all duration-200 rounded-xl ease-in-out hover:opacity-[0.8] bg-[#5454b1] text-xl ${btnClass} ${
          disabled ? "cursor-not-allowed opacity-50" : "cursor-pointer"
        } ${btnType ? "opacity-[1]" : "opacity-[0.6]"}`}
      >
        {btnTitle}
      </button>
    </>
  );
};

export default ViewBtn;
EOF

cat > src/globalComponents/Table.tsx << 'EOF'
/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-explicit-any */

"use client";

import React from "react";
import { Empty, Pagination, Tooltip } from "antd";
import { motion } from "framer-motion";
import { useDispatch, useSelector } from "react-redux";
import {
  handlePageChange,
  handleShowSizeChange,
  handleToggleRow,
  handleToggleSelectAll,
} from "../globalService/GlobalHandlers";
import { TableProps } from "@/features/default/types/defaultValidators";

const Table = <T extends { id: number }>({
  tableTitle,
  columns,
  data,
  tooltipShow,
  checkData = false,
  tableIndex = false,
  tableLoader,
  detailMode = false,
  detailView,
}: TableProps<T>) => {
  const { currentPage, itemsPerPage, selectedRows } = useSelector(
    (s: any) => s.globalApp
  );

  const dispatch = useDispatch<any>();

  const rows = Array.isArray(data) ? data : [];
  const totalItems = rows.length;
  const startIndex = (currentPage - 1) * itemsPerPage;
  const endIndex = Math.min(startIndex + itemsPerPage, totalItems);
  const currentRows = rows.slice(startIndex, endIndex);

  const allSelected =
    currentRows.length > 0 &&
    currentRows.every((row: any) => selectedRows.includes(row.id));

  return (
    <div title={tableTitle} className="w-full rounded-xl">
      <div className="overflow-x-auto custom-scrollbar rounded-xl w-full">
        <div className="h-[42vh] overflow-y-auto custom-scrollbar">
          <table className="w-full border-collapse rounded-xl shadow-md whitespace-nowrap">
            <thead className="sticky top-0 z-10 bg-[#D6E2FE] text-[#414141]">
              <tr>
                {checkData && (
                  <th className="px-8 py-7 sticky left-0 z-10 bg-[#D6E2FE]">
                    <input
                      type="checkbox"
                      className="w-4.5 h-4.5 cursor-pointer"
                      checked={allSelected}
                      onChange={() =>
                        dispatch(handleToggleSelectAll(currentRows.length))
                      }
                    />
                  </th>
                )}

                {tableIndex === true && (
                  <th
                    className={`px-8 py-7 text-left text-xl font-semibold sticky ${
                      checkData === true ? "left-32" : "left-0"
                    } z-10 bg-[#D6E2FE]`}
                  >
                    S. No.
                  </th>
                )}

                {columns.map((column, index) => (
                  <th
                    key={index}
                    className="px-8 py-7 text-left text-xl font-semibold"
                  >
                    {column.header}
                  </th>
                ))}
              </tr>
            </thead>

            {tableLoader ? (
              [...Array(18)].map((_, index) => (
                <motion.tr
                  key={index}
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ duration: 0.4, delay: index * 0.1 }}
                  className={`${
                    index % 2 === 0 ? "bg-[#f9f9ff]" : "bg-white"
                  } border-t border-[#e5e5e5]`}
                >
                  {Array.from({
                    length:
                      columns.length +
                      (checkData ? 1 : 0) +
                      (tableIndex ? 1 : 0),
                  }).map((__, colIndex) => (
                    <td key={colIndex} className="px-8 py-4">
                      <motion.div
                        initial={{ backgroundPosition: "-200% 0" }}
                        animate={{ backgroundPosition: "200% 0" }}
                        transition={{
                          duration: 1.2,
                          repeat: Infinity,
                          ease: "linear",
                        }}
                        className="h-16 w-3/4 rounded-md bg-linear-to-r from-[#e0e0e0] via-[#f0f0f0] to-[#e0e0e0] bg-size-[200%_100%]"
                      />
                    </td>
                  ))}
                </motion.tr>
              ))
            ) : (
              <tbody>
                {currentRows.length > 0 ? (
                  currentRows.map((row: any, rowIndex: number) => (
                    <tr
                      key={row.id}
                      onClick={detailMode ? () => detailView?.(row) : undefined}
                      className={`${
                        rowIndex % 2 === 0 ? "bg-[#f2f2f2]" : "bg-white"
                      } border-t border-[#e5e5e5] hover:opacity-[0.8] ${
                        detailMode ? "cursor-pointer" : ""
                      }`}
                    >
                      {checkData && (
                        <td
                          className={`sticky left-0 ${
                            rowIndex % 2 === 0 ? "bg-[#f2f2f2]" : "bg-white"
                          } px-8 py-4`}
                        >
                          <input
                            type="checkbox"
                            className="w-4.5 h-4.5 cursor-pointer"
                            checked={selectedRows.includes(row.id)}
                            onChange={() => dispatch(handleToggleRow(row.id))}
                          />
                        </td>
                      )}

                      {tableIndex === true && (
                        <td
                          className={`sticky ${
                            checkData === true ? "left-32" : "left-0"
                          } ${
                            rowIndex % 2 === 0 ? "bg-[#f2f2f2]" : "bg-white"
                          } px-8 py-7 text-xl text-[#414141] font-medium`}
                        >
                          {startIndex + rowIndex + 1}.
                        </td>
                      )}

                      {columns.map((column, colIndex) => {
                        const accessorOutput = column.accessor(row, rowIndex);
                        const truncatedOutput =
                          typeof accessorOutput === "string"
                            ? accessorOutput.split(" ").slice(0, 10).join(" ") +
                              (accessorOutput.split(" ").length > 10
                                ? "..."
                                : "")
                            : accessorOutput;

                        return (
                          <td
                            key={colIndex}
                            className="px-8 py-4 text-xl text-[#414141] font-medium"
                          >
                            {tooltipShow ? (
                              <Tooltip
                                title={
                                  <div
                                    style={{
                                      color: "#000",
                                      maxWidth: "500px",
                                      whiteSpace: "normal",
                                      wordWrap: "break-word",
                                    }}
                                  >
                                    {accessorOutput}
                                  </div>
                                }
                                color="#fff"
                                styles={{
                                  root: {
                                    color: "#000",
                                    background: "#fff",
                                    maxWidth: "500px",
                                    whiteSpace: "normal",
                                    wordWrap: "break-word",
                                  },
                                }}
                              >
                                <span>{truncatedOutput}</span>
                              </Tooltip>
                            ) : (
                              <span>{truncatedOutput}</span>
                            )}
                          </td>
                        );
                      })}
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td
                      colSpan={columns.length + 2}
                      className="px-8 py-16 text-center text-xl text-[#666]"
                    >
                      <Empty />
                    </td>
                  </tr>
                )}
              </tbody>
            )}
          </table>
        </div>
      </div>

      <div className="flex justify-end gap-8 items-center py-4 mt-8">
        <span className="text-xl text-[#414141] font-normal">
          {totalItems > 0 ? `${startIndex + 1} - ${endIndex}` : "0 - 0"} of{" "}
          {totalItems}
        </span>

        <Pagination
          current={currentPage}
          total={totalItems}
          pageSize={itemsPerPage}
          showSizeChanger
          showQuickJumper
          pageSizeOptions={["10", "20", "50", "100"]}
          onChange={(page: number, pageSize: number) =>
            dispatch(handlePageChange(page, pageSize))
          }
          onShowSizeChange={(page: number, pageSize: number) =>
            dispatch(handleShowSizeChange(page, pageSize))
          }
          className="custom-pagination"
        />
      </div>
    </div>
  );
};

export default Table;
EOF

cat > src/globalComponents/Header.tsx << 'EOF'
/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-explicit-any */
import { useEffect, useRef, useState } from "react";
import { HiMenuAlt1 } from "react-icons/hi";
import { NavLink } from "@/globalService/Data";
import Link from "next/link";

const Header: React.FC = () => {
  const [navlink] = useState<any[]>(NavLink);
  const [isMenuOpen, setIsMenuOpen] = useState<boolean>(false);
  const [view, setView] = useState<string>("Home");
  const sidebarRef = useRef<HTMLDivElement | null>(null);
  const [scrollingUp, setScrollingUp] = useState<boolean>(false);
  const prevScrollY = useRef<number>(0);
  const [isDropdownOpen, setIsDropdownOpen] = useState<number | null>(null);
  const [isMobileDropdownOpen, setIsMobileDropdownOpen] = useState<
    number | null
  >(null);
  const dropdownRef = useRef<HTMLDivElement | null>(null);

  const toggleMenu = () => setIsMenuOpen(!isMenuOpen);

  const handleNavigation = () => {
    window.scrollTo(0, 0);
    setIsMenuOpen(false);
    setIsDropdownOpen(null);
    setIsMobileDropdownOpen(null);
  };

  const handleSelectedView = (selectedView: string) => {
    setView(selectedView);
  };

  useEffect(() => {
    const handleScroll = () => {
      const currentScrollY = window.scrollY;
      setScrollingUp(currentScrollY < prevScrollY.current);
      prevScrollY.current = currentScrollY;
    };

    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      const target = event.target as Node;

      if (
        sidebarRef.current &&
        !sidebarRef.current.contains(target) &&
        isMenuOpen
      ) {
        setIsMenuOpen(false);
      }

      if (dropdownRef.current && !dropdownRef.current.contains(target)) {
        setIsDropdownOpen(null);
        setIsMobileDropdownOpen(null);
      }
    };

    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, [isMenuOpen]);

  return (
    <>
      <div
        className={`header fixed top-0 left-0 z-200 px-6 py-6 flex justify-center 
        items-center gap-10 w-full max-lg:justify-end`}
        ref={sidebarRef}
      >
        <div
          className={`absolute top-0 left-0 w-full h-full bg-[#26203c] transition-all duration-[0.4s] ease-linear opacity-100`}
        ></div>

        <nav className="relative navbar w-auto hidden lg:flex">
          <ul className="flex items-start gap-16 transition-all duration-200 ease-in-out">
            {navlink.map((e: any) => {
              if (e.submenu) {
                return (
                  <div
                    key={e.id}
                    className="relative cursor-pointer"
                    onClick={() =>
                      setIsDropdownOpen(isDropdownOpen !== e.id ? e.id : null)
                    }
                  >
                    <span className="navlink border-b pb-2 border-none text-xl text-white font-semibold transition-all duration-200 hover:opacity-50">
                      {e.title} &nbsp;
                      <i className="fa-solid fa-chevron-down text-sm relative bottom-[0.2rem]" />
                    </span>

                    {isDropdownOpen === e.id && (
                      <div
                        ref={dropdownRef}
                        className="absolute -left-24 mt-[0.2rem] px-4 py-4 border border-[#d2d2d2] w-75 bg-white shadow-lg rounded-lg z-50 flex flex-col gap-2"
                      >
                        {e.submenu.map((sub: any) => (
                          <Link
                            key={sub.id}
                            href={sub.to}
                            className="block text-lg hover:opacity-50 text-black transition"
                            onClick={handleNavigation}
                          >
                            {sub.title}
                          </Link>
                        ))}
                      </div>
                    )}
                  </div>
                );
              }

              return (
                <Link
                  key={e.id}
                  href={e.to}
                  onClick={() => {
                    handleNavigation();
                    handleSelectedView(e.title);
                  }}
                  className={`navlink ${
                    view === e.title ? "border-b border-white" : "border-none"
                  } text-xl text-white font-semibold transition-all duration-200 hover:opacity-50`}
                >
                  {e.title}
                </Link>
              );
            })}
          </ul>
        </nav>

        <div className="relative flex items-center justify-center gap-8">
          <a className="fa-brands fa-facebook text-[wheat] text-2xl hover:opacity-50 cursor-pointer" />
          <a className="fa-brands fa-linkedin text-[wheat] text-2xl hover:opacity-50 cursor-pointer" />
          <a className="fa-brands fa-instagram text-[wheat] text-2xl hover:opacity-50 cursor-pointer" />

          <div className="lg:hidden">
            <HiMenuAlt1
              size={20}
              className="text-white cursor-pointer"
              onClick={toggleMenu}
            />
          </div>
        </div>
      </div>

      <div
        ref={sidebarRef}
        className={`${
          isMenuOpen ? "translate-x-0" : "translate-x-full"
        } fixed top-0 right-0 w-full h-screen bg-white transition-transform duration-300 lg:hidden z-200`}
      >
        <div className="flex justify-end p-4">
          <HiMenuAlt1
            size={20}
            className="text-black cursor-pointer"
            onClick={toggleMenu}
          />
        </div>

        <ul className="flex flex-col justify-center items-center h-full gap-12 text-black">
          {navlink.map((e: any) => {
            if (e.submenu) {
              return (
                <div key={e.id} className="w-full flex flex-col items-center">
                  <span
                    className="block text-xl cursor-pointer"
                    onClick={() =>
                      setIsMobileDropdownOpen(
                        isMobileDropdownOpen === e.id ? null : e.id
                      )
                    }
                  >
                    {e.title} &nbsp;
                    <i className="fa-solid fa-chevron-down text-sm relative bottom-[0.2rem]" />
                  </span>

                  <div
                    className={`w-full flex flex-col gap-2 transition-all duration-300 ${
                      isMobileDropdownOpen === e.id
                        ? "max-h-75 mt-4 opacity-100"
                        : "max-h-0 opacity-0"
                    }`}
                  >
                    {e.submenu.map((sub: any) => (
                      <Link
                        key={sub.id}
                        href={sub.to}
                        className="block text-lg text-black py-2 transition"
                        onClick={handleNavigation}
                      >
                        {sub.title}
                      </Link>
                    ))}
                  </div>
                </div>
              );
            }

            return (
              <Link
                key={e.id}
                href={e.to}
                onClick={handleNavigation}
                className="text-xl text-black hover:opacity-50"
              >
                {e.title}
              </Link>
            );
          })}
        </ul>
      </div>
    </>
  );
};

export default Header;
EOF

cat > src/globalComponents/Footer.tsx << 'EOF'
import React from "react";

const Footer: React.FC = () => {
  return (
    <>
      <div
        className={`px-8 py-3 bg-[#26203c] w-full flex items-center justify-center text-center`}
      >
        <h2 className={`text-xl text-white font-semibold`}>
          ❤️ Made By Harshvardhan Sharma
        </h2>
      </div>
    </>
  );
};

export default Footer;
EOF

cat > src/globalService/GlobalSlice.ts << 'EOF'
import { createSlice, PayloadAction } from "@reduxjs/toolkit";

const initialState = {
  isMenuOpen: false,
  currentPage: 1,
  itemsPerPage: 10,
  selectedRows: [] as number[],
};

const Slice = createSlice({
  name: "globalApp",
  initialState,
  reducers: {
    setMenuOpen: (state, action: PayloadAction<boolean>) => {
      state.isMenuOpen = action.payload;
    },
    setCurrentPage(state, action: PayloadAction<number>) {
      state.currentPage = action.payload;
    },
    setItemsPerPage(state, action: PayloadAction<number>) {
      state.itemsPerPage = action.payload;
    },
    toggleRow(state, action: PayloadAction<number>) {
      const id = action.payload;
      if (state.selectedRows.includes(id)) {
        state.selectedRows = state.selectedRows.filter((rowId) => rowId !== id);
      } else {
        state.selectedRows = [...state.selectedRows, id];
      }
    },
    toggleSelectAll(
      state,
      action: PayloadAction<{ id: number }[]>
    ) {
      const currentRows = action.payload;
      const allSelected =
        currentRows.length > 0 &&
        currentRows.every((row) => state.selectedRows.includes(row.id));

      if (allSelected) {
        state.selectedRows = state.selectedRows.filter(
          (id) => !currentRows.some((row) => row.id === id)
        );
      } else {
        const newIds = currentRows
          .map((row) => row.id)
          .filter((id) => !state.selectedRows.includes(id));
        state.selectedRows = [...state.selectedRows, ...newIds];
      }
    },
    clearSelectedRows(state) {
      state.selectedRows = [];
    },
  },
});

export const {
  setMenuOpen,
  setCurrentPage,
  setItemsPerPage,
  toggleRow,
  toggleSelectAll,
  clearSelectedRows,
} = Slice.actions;

export default Slice.reducer;
EOF

cat > src/globalService/GlobalHandlers.ts << 'EOF'
/* eslint-disable @typescript-eslint/no-explicit-any */
import {
  clearSelectedRows,
  setCurrentPage,
  setItemsPerPage,
  toggleRow,
  toggleSelectAll,
} from "./GlobalSlice";

export const handlePageChange =
  (page: number, pageSize: number) => async (dispatch: any) => {
    dispatch(setCurrentPage(page));
    dispatch(setItemsPerPage(pageSize));
  };

export const handleShowSizeChange =
  (page: number, pageSize: number) => async (dispatch: any) => {
    dispatch(setCurrentPage(1));
    dispatch(setItemsPerPage(pageSize));
  };

export const handleToggleRow = (id: number) => async (dispatch: any) => {
  dispatch(toggleRow(id));
};

export const handleToggleSelectAll =
  (currentRows: number) => async (dispatch: any) => {
    dispatch(toggleSelectAll([{ id: currentRows }]));
  };

export const handleClearSelection = () => async (dispatch: any) => {
  dispatch(clearSelectedRows());
};
EOF

cat > src/globalService/Data.ts << 'EOF'
export const NavLink = [
  {
    id: 1,
    title: "Home",
    to: "/default",
  },
  {
    id: 2,
    title: "About Us",
    to: "/default",
  },
  {
    id: 3,
    title: "Course",
    to: "#",
    submenu: [
      { id: 1, title: "Our Course", to: "/default" },
      { id: 2, title: "AI Course", to: "/default" },
    ],
  },
  {
    id: 7,
    title: "Contact Us",
    to: "/default",
  },
];

const algorithms: string[] = [
  "GPT-4",
  "Llama 2",
  "Falcon",
  "Mistral",
  "Gemini",
  "Claude",
  "GPT-3.5",
  "BERT",
  "T5",
  "PaLM",
  "OPT",
  "BLOOM",
];

const status: string[] = ["Ready", "Pending", "Failed"];

const datasetNames: string[] = [
  "Technical Manual",
  "Industrial Report",
  "Sensor Data Archive",
  "Maintenance Logs",
  "Weather Records",
  "Satellite Imagery Set",
  "Operational Handbook",
  "Incident Reports",
  "Training Dataset",
  "Communications Log",
  "Research Paper Collection",
  "Blueprint Repository",
  "Performance Metrics",
  "Inventory List",
  "Mission Briefings",
  "Navigation Charts",
  "Equipment Specifications",
  "Test Results",
  "Safety Guidelines",
  "Personnel Records",
  "Project Documentation",
  "Simulation Data",
  "Inspection Reports",
  "Environmental Data",
  "Procurement Records",
  "Quality Assurance Logs",
  "Deployment Plans",
  "Compliance Documents",
  "Budget Reports",
  "System Architecture Files",
  "Audit Trail",
];

function randomDate(start: Date, end: Date): string {
  const date = new Date(
    start.getTime() + Math.random() * (end.getTime() - start.getTime())
  );
  const options: Intl.DateTimeFormatOptions = {
    month: "short",
    day: "numeric",
    year: "numeric",
  };
  return (
    date.toLocaleString("en-US", options).replace(",", "") +
    " at " +
    date
      .toLocaleTimeString("en-US", {
        hour: "numeric",
        minute: "2-digit",
        hour12: true,
      })
      .toLowerCase()
  );
}

function generateRandomHash(length: number = 8): string {
  const chars =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  let result = "";
  for (let i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return result;
}

export const TableDummyData = Array.from({ length: 30 }, (_, i) => ({
  id: i,
  name: datasetNames[i % datasetNames.length],
  algorithm: algorithms[i % algorithms.length],
  documents: `Parsing_Doc_${i + 1}.pdf`,
  created_on: randomDate(new Date(2024, 0, 1), new Date(2025, 11, 31)),
  status: status[i % status.length],
}));
EOF

cat > src/utils/axiosInstance.ts << 'EOF'
import axios, {
  AxiosInstance,
  AxiosResponse,
  InternalAxiosRequestConfig,
  Method,
} from "axios";

const axiosInstance: AxiosInstance = axios.create({
  baseURL: process.env.NEXT_PUBLIC_APP_BACKEND_URL,
  withCredentials: true,
});

axiosInstance.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    config.withCredentials = true;
    config.headers.set(
      "Access-Control-Allow-Origin",
      process.env.NEXT_PUBLIC_APP_BACKEND_URL || ""
    );
    config.headers.set(
      "Access-Control-Allow-Methods",
      "GET,POST,PUT,DELETE,OPTIONS"
    );
    config.headers.set(
      "Access-Control-Allow-Headers",
      "Content-Type, Authorization"
    );
    return config;
  },
  (error) => Promise.reject(error)
);

axiosInstance.interceptors.response.use(
  (response: AxiosResponse) => {
    const location = response.headers?.location;
    if (location && typeof window !== "undefined") {
      window.location.href = location;
    }
    return response;
  },
  (error) => {
    const location = error?.response?.headers?.location;
    if (location && typeof window !== "undefined") {
      window.location.href = location;
      return;
    }
    return Promise.reject(error?.response?.data || error);
  }
);

type ApiRequestArgs<T = unknown> = {
  method: Method;
  url: string;
  data?: T;
  params?: Record<string, unknown>;
  headers?: Record<string, string>;
  baseURL?: string;
  withCredentials?: boolean;
};

export const apiRequest = async <TResponse = unknown, TData = unknown>({
  method,
  url,
  data,
  params,
  headers,
  baseURL,
  withCredentials = true,
}: ApiRequestArgs<TData>): Promise<TResponse> => {
  const instance: AxiosInstance = baseURL
    ? axios.create({ baseURL, withCredentials })
    : axiosInstance;

  const res = await instance.request<TResponse>({
    method,
    url,
    data,
    params,
    headers,
    withCredentials,
  });

  return res.data;
};

export default axiosInstance;
EOF

cat > src/utils/formatUtils.ts << 'EOF'
export const formatFileSize = (bytes?: number): string => {
  if (!bytes) return "0 B";
  const units: string[] = ["B", "KB", "MB", "GB", "TB"];
  const i: number = Math.floor(Math.log(bytes) / Math.log(1024));
  return `${(bytes / Math.pow(1024, i)).toFixed(1)} ${units[i]}`;
};

export const formatDate = (dateString: string | number | Date): string => {
  const options: Intl.DateTimeFormatOptions = {
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

export const formatTime = (dateString: string | number | Date): string => {
  const date = new Date(dateString);
  return date.toLocaleTimeString("en-US", {
    hour: "2-digit",
    minute: "2-digit",
    hour12: true,
  });
};

type RelativeUnit = {
  sec: number;
  name: Intl.RelativeTimeFormatUnit;
};

export const formatRelativeTime = (
  dateString: string | number | Date
): string => {
  const rtf = new Intl.RelativeTimeFormat("en", { numeric: "auto" });
  const diff: number = (new Date(dateString).getTime() - Date.now()) / 1000;

  const units: RelativeUnit[] = [
    { sec: 60, name: "second" },
    { sec: 3600, name: "minute" },
    { sec: 86400, name: "hour" },
    { sec: 604800, name: "day" },
    { sec: 2592000, name: "week" },
    { sec: 31536000, name: "month" },
  ];

  for (let i = units.length - 1; i >= 0; i--) {
    if (Math.abs(diff) >= units[i].sec) {
      return rtf.format(Math.round(diff / units[i].sec), units[i].name);
    }
  }

  return rtf.format(Math.round(diff), "second");
};
EOF

cat > src/utils/validators.ts << 'EOF'
/* eslint-disable @typescript-eslint/no-explicit-any */
import { ReactNode } from "react";

export interface BtnProps {
  btnTitle?: ReactNode;
  btnClass?: string;
  btnFunc?: () => void;
  disabled?: boolean;
  view?: string;
  btnType?: string;
}
EOF

cat > src/utils/Store.ts << 'EOF'
import { configureStore } from "@reduxjs/toolkit";
import chatBotReducer from "@/features/chatBot/services/toolkit/ChatBotSlice";
import globalReducer from "@/globalService/GlobalSlice";
import authReducer from "@/features/auth/services/toolkit/authSlice";

export const store = configureStore({
  reducer: {
    chatBotApp: chatBotReducer,
    globalApp: globalReducer,
    authApp: authReducer,
  },
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;
EOF
