# Dockerfile for FastAPI app
FROM python:3.11-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# System deps for building wheels and postgres client libs
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Install Python deps first for better caching
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copy the rest of the project
COPY . /app

# Expose FastAPI port
EXPOSE 8000

# Allow overriding the ASGI app path via UVICORN_APP (defaults to main:app)
CMD ["/bin/sh", "-c", "uvicorn ${UVICORN_APP:-main:app} --host 0.0.0.0 --port 8000"]
