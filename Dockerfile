# ============================================
# Stage 1: Builder - install dependencies
# ============================================
FROM python:3.11-slim AS builder

WORKDIR /app

# Create a virtual environment for clean dependency isolation
RUN python -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Copy and install dependencies (cached layer if requirements unchanged)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ============================================
# Stage 2: Final - lean production image
# ============================================
FROM python:3.11-slim

# Prevent Python from writing .pyc files and enable unbuffered output
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PATH="/app/venv/bin:$PATH"

WORKDIR /app

# Copy only the virtual environment from the builder stage
COPY --from=builder /app/venv /app/venv

# Copy application code
COPY application.py .

# Document the port the app listens on
EXPOSE 8000

# Start the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]