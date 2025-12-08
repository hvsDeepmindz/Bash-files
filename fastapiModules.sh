#!/bin/bash

python3 -m venv .venv
source .venv/bin/activate

pip install "fastapi[standard]" uvicorn sqlalchemy psycopg2-binary python-dotenv pydantic

pip freeze > requirements.txt

mkdir -p features/app/routes
mkdir -p features/app/schemas
mkdir -p features/app/db
mkdir -p features/app/models

touch features/app/main.py
touch features/app/models/__init__.py
touch features/app/models/models.py
touch features/app/db/__init__.py
touch features/app/db/dbSetup.py
touch features/app/routes/__init__.py
touch features/app/routes/routes.py
touch features/app/schemas/__init__.py
touch features/app/schemas/schemas.py

touch ProcFile
touch README.md
touch dockerfile
touch .dockerignore
touch .gitignore

cat > features/app/main.py << 'EOF'
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def home():
    return {"data": "Hello world"}
EOF
