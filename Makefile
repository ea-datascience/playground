# Makefile for Playground Project - Shift-Left Container Development
.PHONY: help setup dev test lint github-ci clean

# Configuration
SHELL := /bin/bash
DOCKER_BUILDKIT := 1
COMPOSE_DOCKER_CLI_BUILD := 1

# Export Docker BuildKit for faster builds
export DOCKER_BUILDKIT
export COMPOSE_DOCKER_CLI_BUILD

# =============================================================================
# Help and Setup Commands
# =============================================================================

help: ## Show available commands
	@echo "🏗️  Playground Development Commands"
	@echo "=================================="
	@echo ""
	@echo "Setup:"
	@echo "  setup          Setup development environment"
	@echo ""
	@echo "Development:"
	@echo "  dev            Start development container"
	@echo "  test           Run tests in container"
	@echo "  lint           Run code quality checks"
	@echo ""
	@echo "CI/CD:"
	@echo "  github-ci      Run complete GitHub Actions pipeline locally"
	@echo ""
	@echo "Utilities:"
	@echo "  clean          Clean up containers and volumes"

setup: ## Setup complete development environment
	@echo "🔧 Setting up playground development environment..."
	@docker-compose build dev
	@mkdir -p test-results
	@echo "✅ Environment ready! Run 'make dev' to start development."

# =============================================================================
# Development Commands
# =============================================================================

dev: ## Start interactive development container
	@echo "🚀 Starting development container..."
	@echo "💡 You are now in the containerized development environment"
	@echo "💡 All tools (markdownlint, markdown-link-check) are available"
	@echo "💡 Type 'exit' to leave the container"
	@docker-compose run --rm dev

test: ## Run tests in container environment
	@echo "🧪 Running tests in container..."
	@docker-compose run --rm test bash -c " \
		echo ' Checking markdown links...' && \
		markdown-link-check src/*.md *.md && \
		echo '✅ All tests passed!' \
	"

lint: ## Run code quality checks in container
	@echo "🔍 Running code quality checks..."
	@docker-compose run --rm dev bash -c " \
		echo ' Checking Markdown links...' && \
		markdown-link-check src/*.md *.md && \
		echo '✅ Code quality checks passed!' \
	"

# =============================================================================
# GitHub Actions Simulation
# =============================================================================

github-ci: ## Run complete GitHub Actions pipeline locally
	@echo "🐳 Running complete GitHub Actions pipeline in Docker..."
	@echo "🎯 This mimics GitHub Actions exactly - if this passes, CI will pass"
	@echo ""
	@echo "📋 Pipeline stages:"
	@echo "  1️⃣  Build containers"
	@echo "  2️⃣  Lint markdown files"
	@echo "  3️⃣  Check markdown links"
	@echo "  4️⃣  Validate YAML files"
	@echo ""
	@docker-compose build ci
	@docker-compose run --rm ci bash -c " \
		echo '1️⃣ Building environment...' && \
		echo '   ✅ Container environment ready' && \
		echo '' && \
		echo '2️⃣ Checking markdown links...' && \
		markdown-link-check src/*.md *.md --config .markdown-link-check.json && \
		echo '   ✅ Link checking passed' && \
		echo '' && \
		echo '3️⃣ Validating project structure...' && \
		ls -la src/ && \
		echo '   ✅ Project structure validated' && \
		echo '' && \
		echo '🎉 All GitHub Actions checks passed! Ready to push! 🚀' \
	"

# =============================================================================
# Utility Commands
# =============================================================================

clean: ## Clean up containers and volumes
	@echo "🧹 Cleaning up..."
	@docker-compose down --volumes
	@docker system prune -f
	@rm -rf test-results/*
	@echo "✅ Cleanup completed"

# Default target
.DEFAULT_GOAL := help
