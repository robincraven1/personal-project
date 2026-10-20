# ============================================
# Stage 1: Boilerplate - shared runtime settings
# ============================================
FROM python:3.11-slim AS boiler

# Prevent Python from writing .pyc files and enable unbuffered output
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# ============================================
# Stage 2: Development - dependencies and hot reload
# ============================================
FROM boiler AS dev

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code (overridden by the Compose volume during development)
COPY . .

EXPOSE 8000

CMD ["uvicorn", "application:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

# ============================================
# Stage 3: Build - isolated production dependencies
# ============================================
FROM boiler AS build

RUN python -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ============================================
# Stage 4: Production - lean runtime image
# ============================================
FROM boiler AS prod

ENV PATH="/app/venv/bin:$PATH"

COPY --from=build /app/venv /app/venv
COPY application.py .

EXPOSE 8000

CMD ["uvicorn", "application:app", "--host", "0.0.0.0", "--port", "8000"]
