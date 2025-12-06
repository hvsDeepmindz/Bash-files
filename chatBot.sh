#!/bin/bash

cat > src/features/chatBot/pages/ChatBot.jsx << 'EOF'
/* eslint-disable no-unused-vars */
import React from "react";
import ChatBotMain from "../components/ChatBotMain";

const ChatBot = () => {
  return (
    <>
      <div className={`relative w-full`}>
        <ChatBotMain />
      </div>
    </>
  );
};

export default ChatBot;
EOF

cat > src/features/chatBot/components/ChatBotMain.jsx << 'EOF'
/* eslint-disable no-unused-vars */
import { Drawer, Tooltip } from "antd";
import React, { useEffect, useRef, useState } from "react";
import { FaUserTie } from "react-icons/fa6";
import { IoIosWarning, IoMdSend } from "react-icons/io";
import { RiRobot3Fill } from "react-icons/ri";
import { useDispatch, useSelector } from "react-redux";
import Markdown from "react-markdown";
import remarkGfm from "remark-gfm";
import {
  clearMessages,
  setInput,
  setIsClearChatModal,
  setIsTyping,
  setOpenChatBotSidebar,
} from "../services/toolkit/ChatBotSlice";
import { handleSendChatBotMessage } from "../services/toolkit/ChatBotHandlers";
import { TbRobot } from "react-icons/tb";

const ChatBotMain = () => {
  const dispatch = useDispatch();
  const { isTyping, isClearChatModal, openChatBotSidebar, messages, input } =
    useSelector((s) => s.chatBotApp);
  const [reaction, setReaction] = useState(null);
  const chatEndRef = useRef(null);

  useEffect(() => {
    if (chatEndRef.current) {
      chatEndRef.current.scrollIntoView({ behavior: "smooth" });
    }
  }, [messages]);

  const formatText = (text) => {
    return (
      <Markdown
        remarkPlugins={[remarkGfm]}
        components={{
          ul: ({ node, ...props }) => (
            <ul className="list-disc text-md" {...props} />
          ),
          ol: ({ node, ...props }) => (
            <ol className="list-decimal text-md" {...props} />
          ),
          li: ({ node, ...props }) => <li className="text-md" {...props} />,
          p: ({ node, ...props }) => <p className="text-md" {...props} />,
          strong: ({ node, ...props }) => (
            <strong
              className="font-semibold text-[#5757a6] first-letter:capitalize text-md"
              {...props}
            />
          ),
          a: ({ href, ...props }) => (
            <a
              href={href}
              target="_blank"
              rel="noopener noreferrer"
              className="text-blue-600 underline text-md"
              {...props}
            />
          ),
        }}
      >
        {text}
      </Markdown>
    );
  };

  return (
    <>
      <div
        onClick={() => dispatch(setOpenChatBotSidebar(true))}
        className={`fixed bottom-8 right-8 bg-[green] p-2 shadow-xl shadow-[#414141] rounded-full cursor-pointer animate-bounce`}
      >
        <TbRobot size={40} className={`text-[white]`} />
      </div>
      <Drawer
        open={openChatBotSidebar}
        onClose={() => dispatch(setOpenChatBotSidebar(false))}
        placement="right"
        width="40%"
        bodyStyle={{ padding: 0 }}
        zIndex={200}
      >
        <div className="w-full h-full relative flex flex-col">
          <div className="w-full p-4 flex items-center justify-between gap-4">
            <h2 className="text-2xl font-semibold text-[#234382]">
              <i className="fa-regular fa-comment-dots" />
              &nbsp; Intelligence Bot
            </h2>

            <Tooltip
              title="Clear chat history"
              color="white"
              overlayInnerStyle={{
                color: "black",
                fontSize: "1rem",
              }}
            >
              <div
                className="w-auto cursor-pointer"
                onClick={() => dispatch(setIsClearChatModal(true))}
              >
                <i className="fa-solid fa-trash text-red-500 text-xl" />
              </div>
            </Tooltip>
          </div>

          <div className="w-full flex-1 overflow-y-auto px-6 space-y-8 custom-scrollbar bg-white mt-4">
            {messages.map((msg, index) => (
              <div
                key={index}
                className={`flex items-start ${
                  msg.type === "user" ? "justify-end" : "justify-start"
                }`}
              >
                <div className="flex flex-col items-end gap-4 max-w-[90%]">
                  <div
                    className={`flex items-start gap-3 ${
                      msg.type === "user" ? "flex-row-reverse" : ""
                    }`}
                  >
                    {msg.type === "bot" ? (
                      <div className={`w-auto`}>
                        <RiRobot3Fill size={30} className="text-[#434385]" />
                      </div>
                    ) : (
                      <div className={`w-auto`}>
                        <FaUserTie size={30} className="text-[#434385]" />
                      </div>
                    )}

                    <div
                      className={`px-4 py-1.5 text-xl font-semibold text-[#515151] rounded-lg shadow-md shadow-[#c2c1c1] whitespace-pre-line ${
                        msg.type === "bot" ? "bg-[#eaf1ff]" : "bg-gray-200"
                      }`}
                    >
                      {formatText(msg.text)}
                    </div>
                  </div>

                  <div
                    className={`flex items-center gap-3 ${
                      msg.type === "bot" ? "self-end" : "self-start"
                    }`}
                  >
                    <Tooltip
                      title="Like the response"
                      color="white"
                      overlayInnerStyle={{ color: "#212121" }}
                      trigger="click"
                    >
                      <button
                        onClick={() =>
                          setReaction((prev) =>
                            prev?.index === index && prev?.type === "like"
                              ? null
                              : { index, type: "like" }
                          )
                        }
                        className="hover:opacity-80 cursor-pointer"
                      >
                        <i
                          className={`text-md text-blue-600 fa-${
                            reaction?.index === index &&
                            reaction?.type === "like"
                              ? "solid"
                              : "regular"
                          } fa-thumbs-up`}
                        ></i>
                      </button>
                    </Tooltip>

                    <Tooltip
                      title="Unlike the response"
                      color="white"
                      overlayInnerStyle={{ color: "#212121" }}
                      trigger="click"
                    >
                      <button
                        onClick={() =>
                          setReaction((prev) =>
                            prev?.index === index && prev?.type === "dislike"
                              ? null
                              : { index, type: "dislike" }
                          )
                        }
                        className="hover:opacity-80 cursor-pointer"
                      >
                        <i
                          className={`text-md text-blue-600 fa-${
                            reaction?.index === index &&
                            reaction?.type === "dislike"
                              ? "solid"
                              : "regular"
                          } fa-thumbs-down`}
                        ></i>
                      </button>
                    </Tooltip>

                    <Tooltip
                      title="Copied to clipboard"
                      color="white"
                      overlayInnerStyle={{ color: "#212121" }}
                      trigger="click"
                    >
                      <button
                        onClick={() => navigator.clipboard.writeText(msg.text)}
                        className="hover:opacity-80 cursor-pointer"
                      >
                        <i className="text-md text-blue-600 fa-regular fa-copy"></i>
                      </button>
                    </Tooltip>
                  </div>
                </div>
              </div>
            ))}

            {isTyping && (
              <div className="flex items-center gap-2">
                <RiRobot3Fill size={30} className="text-[#434385]" />
                <div className="flex items-center space-x-1">
                  <div className="w-3 h-3 bg-gray-400 rounded-full animate-bounce"></div>
                  <div className="w-3 h-3 bg-gray-400 rounded-full animate-bounce delay-200"></div>
                  <div className="w-3 h-3 bg-gray-400 rounded-full animate-bounce delay-400"></div>
                </div>
              </div>
            )}

            <div ref={chatEndRef}></div>
          </div>

          <div className="flex flex-col items-end w-full bg-white p-4 border-t border-[#e8e8e8]">
            <div className="rounded-full px-4 py-2 border border-[#a1a1a1] flex items-center justify-between w-full">
              <div className="flex w-full items-center gap-4">
                <input
                  type="text"
                  name="Question Input"
                  id="question_input"
                  className={`border-none outline-none w-full text-xl text-[#828080] font-semibold placeholder:text-[#979797] ${
                    isTyping ? "cursor-not-allowed" : "cursor-text"
                  }`}
                  placeholder="Ask Me Anything ...."
                  value={input}
                  onChange={(e) => dispatch(setInput(e.target.value))}
                  onKeyDown={(e) =>
                    e.key === "Enter" &&
                    dispatch(handleSendChatBotMessage(input, messages))
                  }
                  disabled={isTyping}
                />
              </div>

              <IoMdSend
                size={20}
                className={`text-[#4C8EBB] ${
                  isTyping
                    ? "opacity-50 cursor-not-allowed"
                    : "opacity-100 cursor-pointer"
                }`}
                onClick={() =>
                  !isTyping &&
                  dispatch(handleSendChatBotMessage(input, messages))
                }
              />
            </div>
          </div>
        </div>
      </Drawer>

      <div
        className={`fixed inset-0 flex items-center justify-center bg-black/50 z-300 transition-opacity duration-300 ${
          isClearChatModal ? "opacity-100" : "opacity-0 pointer-events-none"
        }`}
      >
        <div
          className={`bg-white rounded-xl px-6 py-6 w-md text-center transition-all duration-300 ${
            isClearChatModal ? "scale-100" : "scale-90"
          } flex flex-col items-center justify-center gap-6`}
        >
          <IoIosWarning size={60} className="text-[#c58a1d]" />

          <h2 className="text-2xl font-extrabold text-[#4B4B4B]">
            Clear all chats?
          </h2>

          <p className="text-xl font-semibold text-[#59595a]">
            This will remove all chat messages.
          </p>

          <div className="flex justify-center items-center gap-8 mt-2">
            <button
              onClick={() => dispatch(setIsClearChatModal(false))}
              className="px-6 py-2 font-semibold bg-gray-300 text-[#4B4B4B] rounded-lg hover:bg-gray-400 transition cursor-pointer text-xl"
            >
              Cancel
            </button>

            <button
              onClick={() => {
                dispatch(clearMessages());
                dispatch(setIsClearChatModal(false));
                dispatch(setIsTyping(false));
              }}
              disabled={isTyping}
              className={`px-6 py-2 font-semibold bg-red-500 text-white rounded-lg hover:bg-red-600 transition text-lg ${
                isTyping ? "cursor-not-allowed opacity-50" : "cursor-pointer"
              }`}
            >
              Clear
            </button>
          </div>
        </div>
      </div>
    </>
  );
};

export default ChatBotMain;
EOF

cat > src/features/chatBot/services/toolkit/ChatBotSlice.jsx << 'EOF'
/* eslint-disable no-unused-vars */
import { createSlice } from "@reduxjs/toolkit";

const initialState = {
  isTyping: false,
  openChatBotSidebar: false,
  isClearChatModal: false,
  messages: JSON.parse(localStorage.getItem("chatMessages")) || [],
  input: "",
};

const Slice = createSlice({
  name: "chatBotApp",
  initialState,
  reducers: {
    setIsTyping: (s, a) => {
      s.isTyping = a.payload;
    },
    setOpenChatBotSidebar: (s, a) => {
      s.openChatBotSidebar = a.payload;
    },
    setIsClearChatModal: (s, a) => {
      s.isClearChatModal = a.payload;
    },
    setMessages: (state, action) => {
      state.messages = action.payload;
      localStorage.setItem("chatMessages", JSON.stringify(action.payload));
    },
    clearMessages: (state) => {
      state.messages = [];
      localStorage.removeItem("chatMessages");
    },
    setInput: (s, a) => {
      s.input = a.payload;
    },
  },
});

export const {
  setIsTyping,
  setOpenChatBotSidebar,
  setIsClearChatModal,
  setInput,
  setMessages,
  clearMessages,
} = Slice.actions;

export default Slice.reducer;
EOF

cat > src/features/chatBot/services/toolkit/ChatBotHandlers.jsx << 'EOF'
/* eslint-disable no-unused-vars */
import { setInput, setIsTyping, setMessages } from "./ChatBotSlice";

export const handleSendChatBotMessage =
  (input, messages) => async (dispatch) => {
    if (!input.trim()) return;

    const newUserMsg = {
      text: input,
      type: "user",
    };

    dispatch(setMessages([...messages, newUserMsg]));
    dispatch(setInput(""));
    dispatch(setIsTyping(true));

    setTimeout(() => {
      const botMsg = {
        text: `Bot res: ${input}`,
        type: "bot",
      };
      const updated = [...messages, newUserMsg, botMsg];

      dispatch(setMessages(updated));
      dispatch(setIsTyping(false));
    }, 2000);
  };
EOF
