FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libta-lib0-dev \
    ta-lib \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install poetry

# Copy project files
COPY . /app
WORKDIR /app

# Install Python dependencies
RUN poetry install --no-root

# Command to run your application
CMD ["poetry", "run", "python", "your_app.py"]
