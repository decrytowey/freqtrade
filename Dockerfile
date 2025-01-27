# Use an official Python image
FROM python:3.11-slim

# Install system dependencies (including ta-lib)
RUN apt-get update && apt-get install -y \
    libta-lib0-dev \
    ta-lib \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN pip install poetry

# Copy the Freqtrade source code
COPY . /freqtrade
WORKDIR /freqtrade

# Install Python dependencies using Poetry
RUN poetry install --no-root

# Set the command to run Freqtrade
CMD ["poetry", "run", "freqtrade", "trade", "--strategy", "YourStrategyName"]
