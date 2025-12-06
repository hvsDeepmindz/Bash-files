#!/bin/bash

cat > .vscode/settings.json << 'EOF'
{
  "material-icon-theme.folders.associations": {
    "global_component": "global",
    "global_components": "global",
    "globalComponent": "global",
    "globalComponents": "global",
    "globalService": "robot",
    "globalServices": "robot",
    "shared_component": "components",
    "shared_components": "components",
    "sharedComponents": "components",
    "sharedComponent": "components",
    "ui_elements": "components",
    "ui_element": "components",
    "uiElements": "components",
    "uiElement": "components",
    "widgets": "components",
    "btns": "ui",
    "Bash":"robot",
    "chat":"messages",
    "Chat":"messages",
    "ChatBot":"messages",
    "chatBot":"messages",
  }
}
EOF

cat > src/App.jsx << 'EOF'
/* eslint-disable react/prop-types */
import {
  BrowserRouter,
  Routes,
  Route,
  useLocation,
  Navigate,
} from "react-router-dom";
import AppRoutes from "./AppRoutes";
import Header from "./globalComponents/Header";
import Footer from "./globalComponents/Footer";
import { ToastContainer } from "react-toastify";

const Layout = ({ children }) => {
  const { pathname } = useLocation();
  const hideLayout = ["/auth", "/signup"].includes(pathname);

  return (
    <div className="relative flex flex-col w-full min-h-screen">
      <ToastContainer
        className={`custom-toast-container`}
        autoClose={3000}
        position="bottom-right"
      />
      {!hideLayout && <Header />}
      <div className="flex-1 w-full">{children}</div>
      {!hideLayout && <Footer />}
    </div>
  );
};

const App = () => {
  return (
    <BrowserRouter>
      <Layout>
        <Routes>
          <Route path="/" element={<Navigate to="/default" />} />
          {AppRoutes.map((r, i) => {
            const Component = r.component;
            return <Route key={i} path={r.path} element={<Component />} />;
          })}
        </Routes>
      </Layout>
    </BrowserRouter>
  );
};

export default App;
EOF

cat > src/AppRoutes.js << 'EOF'
import Default from "./Default";
import Auth from "./features/auth/pages/Auth";
import Signup from "./features/auth/pages/Signup";

const AppRoutes = [
  { path: "/auth", component: Auth },
  { path: "/signup", component: Signup },
  { path: "/default", component: Default },
];

export default AppRoutes;
EOF

cat > src/ProtectedRoute.jsx << 'EOF'
/* eslint-disable no-unused-vars */
/* eslint-disable react/prop-types */
import React, { useEffect } from "react";
import { useSelector, useDispatch } from "react-redux";
import { Navigate, useNavigate } from "react-router-dom";
import { toast, ToastContainer } from "react-toastify";
import {
  setIsAuthenticated,
  setLoadingUserInfo,
} from "./features/auth/services/toolkit/AuthSlice";
import { BiLoaderAlt } from "react-icons/bi";

const ProtectedRoute = ({ children }) => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const {
    isAuthenticated,
    loadingUserInfo,
    userInfo: user,
  } = useSelector((s) => s.authApp);

  useEffect(() => {
    const check = async () => {
      try {
        dispatch(setIsAuthenticated(true));
      } catch (err) {
        dispatch(setIsAuthenticated(false));
        toast.error("Session expired");
        setTimeout(() => navigate("/auth"), 3000);
      } finally {
        dispatch(setLoadingUserInfo(false));
      }
    };
    if (loadingUserInfo) check();
  }, [loadingUserInfo]);

  if (loadingUserInfo)
    return (
      <>
        <ToastContainer
          autoClose={2000}
          position="bottom-right"
          className="custom-toast-container"
        />
        <div className="w-auto h-screen flex items-center justify-center bg-white">
          <BiLoaderAlt size={60} className={`text-[blue] animate-spin`} />
        </div>
      </>
    );

  if (!isAuthenticated)
    return (
      <>
        <ToastContainer
          autoClose={2000}
          position="bottom-right"
          className="custom-toast-container"
        />
        <div className="w-auto h-screen flex items-center justify-center bg-white"></div>
      </>
    );

  return (
    <>
      <ToastContainer
        autoClose={2000}
        position="bottom-right"
        className="custom-toast-container"
      />
      {children}
    </>
  );
};

export default ProtectedRoute;
EOF

cat > src/features/auth/services/toolkit/AuthSlice.js << 'EOF'
/* eslint-disable no-unused-vars */
import { createSlice } from "@reduxjs/toolkit";

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
    setIsAuthenticated: (s, a) => {
      s.isAuthenticated = a.payload;
    },
    setIsLogin: (s, a) => {
      s.isLogin = a.payload;
    },
    setIsSignup(s, a) {
      s.isSignup = a.payload;
    },
    setIsLogout(s, a) {
      s.isLogout = a.payload;
    },
    setLoadingUserInfo(s, a) {
      s.loadingUserInfo = a.payload;
    },
    setSelectRole(s, a) {
      s.selectRole = a.payload;
    },
    setUserInfo(s, a) {
      s.userInfo = a.payload;
    },
    setUserMode: (s, a) => {
      s.userMode = a.payload;
    },
    setUsername: (s, a) => {
      s.username = a.payload;
    },
    setPassword: (s, a) => {
      s.password = a.payload;
    },
    setCreateUsername: (s, a) => {
      s.createUsername = a.payload;
    },
    setCreateEmail: (s, a) => {
      s.createEmail = a.payload;
    },
    setCreatePassword: (s, a) => {
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

cat > src/features/auth/services/toolkit/AuthHandlers.js << 'EOF'
/* eslint-disable no-unused-vars */
import { toast } from "react-toastify";
import {
  setIsAuthenticated,
  setIsLogin,
  setIsLogout,
  setIsSignup,
} from "./AuthSlice";

export const handleLogin =
  ({ username, password }) =>
  async (dispatch) => {
    try {
      const fields = { username, password };
      const empty = Object.keys(fields).filter((k) => !fields[k]);
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
  ({ createUsername, createEmail, createPassword }) =>
  async (dispatch) => {
    try {
      const fields = { createUsername, createEmail, createPassword };
      const empty = Object.keys(fields).filter((k) => !fields[k]);
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

export const handleLogout = () => async (dispatch) => {
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

cat > src/utils/Store.js << 'EOF'
import { configureStore } from "@reduxjs/toolkit";
import authReducer from "../features/auth/services/toolkit/AuthSlice";
import globalReducer from "../globalService/GlobalSlice";
import chatBotReducer from "../features/chatBot/services/toolkit/ChatBotSlice";

export const store = configureStore({
  reducer: {
    authApp: authReducer,
    globalApp: globalReducer,
    chatBotApp: chatBotReducer,
  },
});
EOF

cat > src/main.jsx << 'EOF'
/* eslint-disable no-unused-vars */
import { createRoot } from "react-dom/client";
import "./index.css";
import App from "./App.jsx";
import { Provider } from "react-redux";
import { store } from "./utils/Store.js";

createRoot(document.getElementById("root")).render(
  <Provider store={store}>
    <App />
  </Provider>
);
EOF

cat > src/globalService/GlobalSlice.js << 'EOF'
/* eslint-disable no-unused-vars */
import { createSlice } from "@reduxjs/toolkit";

const initialState = {
  isMenuOpen: false,
  currentPage: 1,
  itemsPerPage: 10,
  selectedRows: [],
};

const Slice = createSlice({
  name: "globalApp",
  initialState,
  reducers: {
    setMenuOpen: (state, action) => {
      state.isMenuOpen = action.payload;
    },
    setCurrentPage(state, action) {
      state.currentPage = action.payload;
    },
    setItemsPerPage(state, action) {
      state.itemsPerPage = action.payload;
    },
    toggleRow(state, action) {
      const id = action.payload;
      if (state.selectedRows.includes(id)) {
        state.selectedRows = state.selectedRows.filter(
          (rowId) => rowId !== id
        );
      } else {
        state.selectedRows = [...state.selectedRows, id];
      }
    },
    toggleSelectAll(state, action) {
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

cat > src/globalService/GlobalHandlers.js << 'EOF'
import {
  clearSelectedRows,
  setCurrentPage,
  setItemsPerPage,
  toggleRow,
  toggleSelectAll,
} from "./GlobalSlice";

export const handlePageChange = (page, pageSize) => async (dispatch) => {
  dispatch(setCurrentPage(page));
  dispatch(setItemsPerPage(pageSize));
};

export const handleShowSizeChange = (page, pageSize) => async (dispatch) => {
  dispatch(setCurrentPage(1));
  dispatch(setItemsPerPage(pageSize));
};

export const handleToggleRow = (id) => async (dispatch) => {
  dispatch(toggleRow(id));
};

export const handleToggleSelectAll = (currentRows) => async (dispatch) => {
  dispatch(toggleSelectAll(currentRows));
};

export const handleClearSelection = () => async (dispatch) => {
  dispatch(clearSelectedRows());
};
EOF

cat > src/Default.jsx << 'EOF'
/* eslint-disable no-unused-vars */
import React from "react";
import { GiRobotGolem } from "react-icons/gi";
import DefaultTable from "./DefaultTable";
import ChatBot from "./features/chatBot/pages/ChatBot";

const Default = () => {
  return (
    <>
      <div
        className={`w-full h-screen px-32 bg-[#d7fff3] flex flex-col gap-12 items-center justify-center`}
      >
        <div className={`flex gap-8 items-center justify-center text-center`}>
          <GiRobotGolem
            size={60}
            className={`text-2xl animate-bounce text-[#414141]`}
          />
          <h1 className={`text-4xl font-extrabold text-[#5959ad]`}>
            Welcome to Hvs Great App
          </h1>
          <GiRobotGolem
            size={60}
            className={`text-2xl animate-bounce text-[#414141]`}
          />
        </div>
        {/* <DefaultTable /> */}
        <ChatBot />
      </div>
    </>
  );
};

export default Default;
EOF

cat > src/DefaultTable.jsx << 'EOF'
/* eslint-disable no-unused-vars */
import { useState } from "react";
import { formatDate } from "./utils/formatUtils";
import { Modal } from "antd";
import Table from "./globalComponents/Table";
import { TableDummyData } from "./globalService/Data";

const DefaultTable = () => {
  const [selectedRow, setSelectedRow] = useState(null);
  const [docModalVisible, setDocModalVisible] = useState(false);
  const [docList, setDocList] = useState([]);
  const [searchText, setSearchText] = useState("");

  const defaultColumns = [
    { header: "ID", accessor: (row) => row.id },
    { header: "Name", accessor: (row) => row.name },
    { header: "Algorithm", accessor: (row) => row.algorithm },
    {
      header: "Created On",
      accessor: (row) => (
        <div className="flex items-center gap-4">
          <p className="text-xl text-[#888888] font-normal">
            {formatDate(row.created_on)}
          </p>
        </div>
      ),
    },
    {
      header: "Status",
      accessor: (row) => {
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

  const filteredDocs = docList.filter((doc) =>
    doc.toLowerCase().includes(searchText.toLowerCase())
  );

  return (
    <>
      <Table
        title={"Dataset Table"}
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
              filteredDocs.map((doc, index) => (
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

cat > src/globalComponents/btns/ViewBtn.jsx << 'EOF'
/* eslint-disable no-unused-vars */
/* eslint-disable react/prop-types */
import React from "react";

const ViewBtn = ({
  btnTitle,
  btnClass,
  btnFunc,
  disabled = false,
  view,
  btnType,
}) => {
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

cat > src/globalComponents/Header.jsx << 'EOF'
/* eslint-disable no-unused-vars */
import { useEffect, useRef, useState } from "react";
import { Link } from "react-router-dom";
import { HiMenuAlt1 } from "react-icons/hi";
import { NavLink } from "../globalService/Data";

const Header = () => {
  const [navlink] = useState(NavLink);
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [view, setView] = useState("Home");
  const sidebarRef = useRef(null);
  const [scrollingUp, setScrollingUp] = useState(false);
  const prevScrollY = useRef(0);
  const [isDropdownOpen, setIsDropdownOpen] = useState(null);
  const [isMobileDropdownOpen, setIsMobileDropdownOpen] = useState(null);
  const dropdownRef = useRef(null);

  const toggleMenu = () => setIsMenuOpen(!isMenuOpen);
  const handleNavigation = () => {
    window.scrollTo(0, 0);
    setIsMenuOpen(false);
    setIsDropdownOpen(null);
    setIsMobileDropdownOpen(null);
  };

  const handleSelectedView = (selectedView) => {
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
    const handleClickOutside = (event) => {
      if (
        sidebarRef.current &&
        !sidebarRef.current.contains(event.target) &&
        isMenuOpen
      ) {
        setIsMenuOpen(false);
      }
      if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
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
        className={`header fixed top-0 left-0 z-200 px-6 py-6 shadow-sm flex justify-center 
        items-center gap-10 w-full max-lg:justify-end`}
        ref={sidebarRef}
      >
        <div
          className={`absolute top-0 left-0 w-full h-full bg-[crimson] transition-all duration-[0.4s] ease-linear opacity-100`}
        ></div>
        <nav className="relative navbar w-auto hidden lg:flex">
          <ul className="flex items-start gap-16 transition-all duration-200 ease-in-out">
            {navlink.map((e) => {
              if (e.submenu) {
                return (
                  <div
                    key={e.id}
                    className="relative cursor-pointer"
                    onClick={() => setIsDropdownOpen(!isDropdownOpen ? e.id : null)}
                  >
                    <span
                      className={`navlink border-b pb-2 border-none text-xl text-white max-md:text-xl font-semibold  transition-all duration-200 navlink tracking-[0] hover:opacity-50`}
                    >
                      {e.title} &nbsp;
                      <i className="fa-solid fa-chevron-down text-sm relative bottom-[0.2rem]"></i>
                    </span>
                    {isDropdownOpen === e.id && (
                      <div
                        ref={dropdownRef}
                        className="absolute -left-24 mt-[0.2rem] px-4 py-4 border border-[#d2d2d2] w-[300px] 
                        bg-white shadow-lg rounded-lg z-50 flex flex-col gap-2"
                      >
                        {e.submenu.map((sub) => (
                          <Link
                            key={sub.id}
                            to={sub.to}
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
              } else {
                return (
                  <Link
                    key={e.id}
                    to={e.to}
                    onClick={() => {
                      handleNavigation();
                      handleSelectedView(e.title);
                    }}
                    className={`navlink ${
                      view === e.title ? "border-b border-white" : "border-none"
                    } text-xl text-white max-md:text-xl font-semibold  transition-all duration-200 navlink tracking-[0] hover:opacity-50`}
                  >
                    {e.title}
                  </Link>
                );
              }
            })}
          </ul>
        </nav>
        <div className="relative flex items-center justify-center gap-8">
          <a
            href="#"
            target="_blank"
            className="fa-brands fa-facebook text-[wheat] text-2xl hover:opacity-50 transition-all duration-200 ease-in-out"
          ></a>
          <a
            href="#"
            target="_blank"
            className="fa-brands fa-linkedin text-[wheat] text-2xl hover:opacity-50 transition-all duration-200 ease-in-out"
          ></a>
          <a
            href="#"
            target="_blank"
            className="fa-brands fa-instagram text-[wheat] text-2xl hover:opacity-50 transition-all duration-200 ease-in-out"
          ></a>
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
        } fixed top-0 right-0 w-full h-screen bg-[white] transition-transform duration-300 ease-in-out 
        lg:hidden z-200`}
      >
        <div className="flex justify-end p-4">
          <HiMenuAlt1
            size={20}
            className="text-black cursor-pointer"
            onClick={toggleMenu}
          />
        </div>
        <ul
          className={`flex flex-col justify-center items-center text-center h-full px-24 py-0 gap-12 text-black`}
        >
          {navlink.map((e) => {
            if (e.submenu) {
              return (
                <div key={e.id} className="w-full flex flex-col items-center">
                  <span
                    className="block text-xl font-normal cursor-pointer"
                    onClick={() =>
                      setIsMobileDropdownOpen(
                        isMobileDropdownOpen === e.id ? null : e.id
                      )
                    }
                  >
                    {e.title} &nbsp;
                    <i className="fa-solid fa-chevron-down text-sm relative bottom-[0.2rem]"></i>
                  </span>
                  <div
                    className={`w-full overflow-y-auto flex flex-col gap-2 justify-center items-center text-center transition-all duration-300 ease-in-out z-100
                    ${
                      isMobileDropdownOpen === e.id
                        ? "max-h-[300px] mt-4 -mb-8 translate-y-0 opacity-[1]"
                        : "max-h-0 -translate-y-full opacity-0"
                    }`}
                  >
                    {e.submenu.map((sub) => (
                      <Link
                        key={sub.id}
                        to={sub.to}
                        className="block text-lg text-black py-2 transition"
                        onClick={handleNavigation}
                      >
                        <i className="fa-solid fa-circle text-xs text-[grey]"></i>
                        &nbsp; {sub.title}
                      </Link>
                    ))}
                  </div>
                </div>
              );
            } else {
              return (
                <Link
                  key={e.id}
                  to={e.to}
                  onClick={handleNavigation}
                  className={`relative navlink text-xl text-black max-md:text-xl font-normal  transition-all duration-200 navlink tracking-[0] hover:opacity-50`}
                >
                  {e.title}
                </Link>
              );
            }
          })}
        </ul>
      </div>
    </>
  );
};

export default Header;
EOF

cat > src/globalComponents/Footer.jsx << 'EOF'
/* eslint-disable no-unused-vars */
import React from "react";

const Footer = () => {
  return (
    <>
      <div
        className={`px-8 py-3 bg-[crimson] w-full flex items-center justify-center text-center`}
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

cat > src/features/auth/pages/Auth.jsx << 'EOF'
/* eslint-disable no-unused-vars */
import React from "react";
import AuthMain from "../components/AuthMain";

const Auth = () => {
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

cat > src/features/auth/components/AuthMain.jsx << 'EOF'
/* eslint-disable no-unused-vars */
import React, { useEffect, useRef, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { motion } from "framer-motion";
import {
  setUserMode,
  setPassword,
  setUsername,
} from "../services/toolkit/AuthSlice";
import { useNavigate } from "react-router-dom";
import ViewBtn from "../../../globalComponents/btns/ViewBtn";
import { FaCircleUser } from "react-icons/fa6";
import { handleLogin } from "../services/toolkit/AuthHandlers";
import { TbLoader2 } from "react-icons/tb";

const AuthMain = () => {
  const dispatch = useDispatch();
  const {
    isLogin,
    username,
    password,
  } = useSelector((state) => state.authApp);
  const [showPassword, setShowPassword] = useState(false);
  const navigate = useNavigate();

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
                      navigate("/signup")
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

cat > src/features/auth/pages/Signup.jsx << 'EOF'
/* eslint-disable no-unused-vars */
import React from "react";
import SignupMain from "../components/SignupMain";

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

cat > src/features/auth/components/SignupMain.jsx << 'EOF'
/* eslint-disable no-unused-vars */
import React, { useEffect, useRef, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { motion } from "framer-motion";
import {
  setUserMode,
  setSelectRole,
  setCreateUsername,
  setCreateEmail,
  setCreatePassword,
} from "../services/toolkit/AuthSlice";
import { useNavigate } from "react-router-dom";
import ViewBtn from "../../../globalComponents/btns/ViewBtn";
import { FaCircleUser } from "react-icons/fa6";
import { handleSignup } from "../services/toolkit/AuthHandlers";
import { TbLoader2 } from "react-icons/tb";

const SignupMain = () => {
  const dispatch = useDispatch();
  const { selectRole, isSignup, createUsername, createEmail, createPassword } =
    useSelector((state) => state.authApp);
  const [showPassword, setShowPassword] = useState(false);
  const navigate = useNavigate();

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
              <span
                className="text-[#212121] font-semibold text-xl cursor-pointer"
              >
                Back to
              </span>
              <span
                onClick={
                  isSignup
                    ? undefined
                    : () => {
                        navigate("/auth");
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

cat > src/globalService/Data.js << 'EOF'
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

const algorithms = [
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

const status = ["Ready", "Pending", "Failed"];

const datasetNames = [
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

function randomDate(start, end) {
  const date = new Date(start.getTime() + Math.random() * (end.getTime() - start.getTime()));
  const options = {
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

function generateRandomHash(length = 8) {
  const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  let result = "";
  for (let i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return result;
}

export const TableDummyData = Array.from({ length: 30 }, (_, i) => ({
  id: generateRandomHash(8),
  name: datasetNames[i % datasetNames.length],
  algorithm: algorithms[i % algorithms.length],
  documents: `Parsing_Doc_${i + 1}.pdf`,
  created_on: randomDate(new Date(2024, 0, 1), new Date(2025, 11, 31)),
  status: status[i % status.length],
}));
EOF

cat <<'EOF' > src/globalComponents/Table.jsx
/* eslint-disable no-unused-vars */
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

const Table = ({
  tableTitle,
  columns,
  data,
  tooltipShow,
  checkData = false,
  tableIndex = false,
  tableLoader,
  detailMode = false,
  detailView,
}) => {
  const { currentPage, itemsPerPage, selectedRows } = useSelector(
    (s) => s.globalApp
  );
  const dispatch = useDispatch();
  const rows = Array.isArray(data) ? data : [];
  const totalItems = rows.length;
  const startIndex = (currentPage - 1) * itemsPerPage;
  const endIndex = Math.min(startIndex + itemsPerPage, totalItems);
  const currentRows = rows.slice(startIndex, endIndex);

  const allSelected =
    currentRows.length > 0 &&
    currentRows.every((row) => selectedRows.includes(row.id));

  return (
    <div className="w-full rounded-xl">
      <div className="overflow-x-auto custom-scrollbar rounded-xl w-full">
        <div className="h-[42vh] overflow-y-auto custom-scrollbar">
          <table className="w-full border-collapse rounded-xl shadow-md whitespace-nowrap">
            <thead className="sticky top-0 z-10 bg-[#D6E2FE] text-[#414141]">
              <tr>
                {checkData && (
                  <th className="px-8 py-7 sticky left-0 z-10 bg-[#D6E2FE]">
                    <input
                      type="checkbox"
                      className="w-[18px] h-[18px] cursor-pointer"
                      checked={
                        currentRows.length > 0 &&
                        currentRows.every((row) =>
                          selectedRows.includes(row.id)
                        )
                      }
                      onChange={() =>
                        dispatch(handleToggleSelectAll(currentRows))
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
                  currentRows.map((row, rowIndex) => (
                    <tr
                      key={row.id}
                      onClick={detailMode ? () => detailView(row) : null}
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
                            className="w-[18px] h-[18px] cursor-pointer"
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
                                overlayInnerStyle={{
                                  color: "#000",
                                  background: "#fff",
                                  maxWidth: "500px",
                                  whiteSpace: "normal",
                                  wordWrap: "break-word",
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
          onChange={(page, pageSize) => {
            dispatch(handlePageChange(page, pageSize));
          }}
          onShowSizeChange={(page, pageSize) => {
            dispatch(handleShowSizeChange(page, pageSize));
          }}
          className="custom-pagination"
        />
      </div>
    </div>
  );
};

export default Table;
EOF

cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/logo.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>HVS App</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@100..900&family=Lato:wght@100;300;400;700;900&family=Raleway:wght@100..900&family=Roboto+Serif:wght@100..900&family=Roboto:wght@100;300;400;500;700;900&family=Saira:wght@100..900&display=swap" rel="stylesheet" />
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
    <script src="https://kit.fontawesome.com/c855874020.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  </body>
</html>
EOF
