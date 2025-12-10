---

# 🚀 Frontend + Backend Setup Automation Script

This repository provides a **plug-and-play Bash script** that instantly configures a modern React + Vite project **and a FastAPI backend** with essential tools like Redux Toolkit, Tailwind CSS, Framer Motion, Ant Design, SQLAlchemy, PostgreSQL, and more.  
It eliminates repetitive setup work and prepares your project with production-ready configuration files for both frontend and backend.

---

## 📌 Features

### ✅ 1. Automatic Frontend Dependency Installation

Installs major frontend libraries:

* **React Redux**
* **Redux Toolkit**
* **React Router DOM**
* **Tailwind CSS** (with Vite plugin integration)
* **React Icons**
* **Ant Design**
* **Framer Motion**

---

### ✅ 2. Auto-Inject Tailwind Into `vite.config.js`

The script:

* Adds Tailwind Vite plugin import
* Inserts Tailwind into the Vite `plugins` array
* Removes unnecessary files (like `App.css`)

Tailwind is ready instantly — no manual setup required.

---

### ✅ 3. Generates Full Custom `index.css`

The script replaces your default CSS with a **fully-styled global stylesheet**, including:

* Scrollbar styles  
* Global font + layout rules  
* Responsive typography  
* Toastify styles  
* Tooltip + AntD patches  
* Custom animations  
* Utility classes  

Perfect for a clean and consistent UI foundation.

---

### ✅ 4. Creates Environment Config (`.env`)

Automatically generates:


---

### ✅ 5. Docker-Ready Setup (Frontend)

Auto-generates:

### **Dockerfile**
Production-ready multistage build (Node → Nginx)

### **.dockerignore**
Optimized for smaller image size.

---

# 🐍 Backend Features (FastAPI)

### ✅ 6. Automatic Backend Dependency Installation

Installs essential Python backend libraries:

* **FastAPI**
* **Uvicorn**
* **SQLAlchemy**
* **psycopg2-binary**
* **python-dotenv**
* **pydantic**

---

### ✅ 7. Auto-Generate Backend Project Structure

Creates full FastAPI folder layout:


---

### ✅ 8. Backend Essential Files Created

The script creates boilerplate placeholders for:

* `blogModels.py`  
* `blogdbSetup.py`  
* `blogRoutes.py`  
* `blogSchemas.py`  
* `main.py`  

Plus global project files:

* `requirements.txt`
* `.env`
* `.gitignore`
* `.dockerignore`
* `ProcFile`
* `dockerfile`
* `.vscode/settings.json`

Your backend becomes fully ready to start coding instantly.

---

## 🛠️ Installation & Usage

### 1️⃣ Place the script anywhere (example: home directory)


### 2️⃣ Move it into your React + FastAPI project folder


---

### 3️⃣ Make it executable


---

### 4️⃣ Run the script inside your project


The script will automatically:

* Install frontend dependencies  
* Install backend dependencies  
* Configure Tailwind  
* Create backend folder structure  
* Generate `.env`, Dockerfile, `.dockerignore`  
* Replace `index.css` with custom version  
* Clean unused files  

---

## 📂 Output Files Created

| File                             | Description                                |
| -------------------------------- | ------------------------------------------ |
| `.env`                           | Frontend + backend base config             |
| `Dockerfile`                     | Production-ready multistage image          |
| `.dockerignore`                  | Reduce build size                          |
| `src/index.css`                  | Full custom global stylesheet              |
| `src/App.css` (removed)          | Cleanup                                    |
| `requirements.txt`               | Python backend dependencies                 |
| `features/blog/main.py`          | FastAPI application entry point            |
| `features/blog/models/*.py`      | SQLAlchemy models                           |
| `features/blog/db/*.py`          | DB engine setup                             |
| `features/blog/routes/*.py`      | Backend routes                              |
| `features/blog/schemas/*.py`     | Pydantic schemas                            |
| `.vscode/settings.json`          | Auto-created editor config                 |

---

## 🎯 Purpose of This Script

This script is designed for developers who:

* Create multiple full-stack React + FastAPI projects  
* Want a **standardized frontend + backend stack**  
* Prefer **ready-to-code** environments  
* Don’t want to repeat configuration steps  
* Need fast onboarding for team members  

---

## 📦 Example Full-Stack Technology Stack

### Frontend

* **React 19**  
* **Redux Toolkit**  
* **React Router DOM**  
* **Tailwind CSS**  
* **Framer Motion**  
* **Ant Design**  
* **Docker + Nginx**  
* **Vite (with Tailwind integration)**  

### Backend

* **FastAPI**  
* **Uvicorn**  
* **SQLAlchemy ORM**  
* **PostgreSQL**  
* **Pydantic**  
* **Dotenv**  

---

## 🤝 Contributing

Feel free to fork this repository and improve the automation script.  
Pull requests are welcome!

---

## ⭐ Support

If this script saves you time, consider giving the repository a **star** ⭐ on GitHub.

---
