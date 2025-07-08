# =============================================================================
# Multi-Stage Dockerfile for Playground Project - GitHub Actions Parity
# =============================================================================

# =============================================================================
# Stage 1: Base Environment - Foundation for all stages
# =============================================================================
FROM node:18-slim AS base

# Set consistent environment variables across all stages
ENV NODE_ENV=development \
    NPM_CONFIG_CACHE=/tmp/npm-cache \
    # Disable telemetry for consistent behavior
    DISABLE_TELEMETRY=1 \
    # Set consistent locale
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Install system dependencies for development tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    # Basic development tools
    vim \
    less \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy package files first for better Docker layer caching
COPY package*.json ./

# Install base dependencies (if package.json exists, otherwise skip)
RUN if [ -f package.json ]; then npm ci --only=production; fi

# =============================================================================
# Stage 2: Development Environment - Primary development stage
# =============================================================================
FROM base AS development

# Install all dependencies including dev dependencies
RUN if [ -f package.json ]; then npm ci; fi    # Install global development tools that match GitHub Actions
    RUN npm install -g \
        markdownlint-cli@0.37.0 \
        markdown-link-check@3.11.2

# Copy all project files
COPY . .

# Create directories for development artifacts
RUN mkdir -p /app/logs /app/test-results /app/.cache

# Set proper permissions
RUN chmod +x /app/scripts/* 2>/dev/null || true

# Default command provides an interactive shell for development
CMD ["bash"]

# =============================================================================
# Stage 3: CI Environment - Matches GitHub Actions exactly
# =============================================================================
FROM base AS ci

# Install minimal tools needed for CI (same versions as GitHub Actions)
RUN npm install -g \
    markdownlint-cli@0.37.0 \
    markdown-link-check@3.11.2

# Copy project files
COPY . .

# Set up test result directories
RUN mkdir -p /app/test-results

# Default command for CI testing
CMD ["echo", "CI environment ready"]

# =============================================================================
# Stage 4: Production Environment (for future use)
# =============================================================================
FROM base AS production

# Copy only necessary files for production
COPY src/ ./src/
COPY README.md ./

# Set production environment
ENV NODE_ENV=production

# Default command for production
CMD ["echo", "Production environment"]
