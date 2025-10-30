# Use the latest stable Python slim image for better security and compatibility
FROM python:3.12-slim

# Set environment variables for Python
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y gcc libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Install pipenv or poetry if needed (uncomment if you use it)
# RUN pip install --upgrade pip pipenv

# Install Python dependencies early for better cache
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Expose the port (optional, set to your app's port)
EXPOSE 8000

# Use a production-grade server and process manager
CMD ["sh", "-c", "gunicorn app:app --bind 0.0.0.0:8000 & python3 bot.py"]
