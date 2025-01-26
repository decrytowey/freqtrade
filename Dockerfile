# Use an official Python slim image
FROM python:3.11-slim

# Install system dependencies, including ta-lib
RUN apt-get update && apt-get install -y \
    libta-lib0-dev ta-lib build-essential gcc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the project files
COPY . .

# Install Python dependencies
RUN pip install --upgrade pip && pip install poetry
RUN poetry install --no-dev

# Expose the application port (optional, adjust as needed)
EXPOSE 8080

# Start the application
CMD ["python", "main.py"]


