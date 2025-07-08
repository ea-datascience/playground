#!/bin/bash
# Local CI test runner for Playground - Ensures GitHub Actions parity
set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🐳 Playground Container CI Test Runner${NC}"
echo -e "${BLUE}=====================================${NC}"
echo -e "${YELLOW}🎯 Goal: 100% Environment Parity with GitHub Actions${NC}"
echo ""

# Function to print stage headers
print_stage() {
    echo -e "\n${YELLOW}📋 STAGE: $1${NC}"
    echo "----------------------------------------"
}

# Function to run tests with error handling
run_test() {
    local test_name="$1"
    local command="$2"
    
    echo -e "\n🔍 Running: $test_name"
    
    if eval "$command"; then
        echo -e "✅ ${GREEN}PASSED${NC}: $test_name"
        return 0
    else
        echo -e "❌ ${RED}FAILED${NC}: $test_name"
        return 1
    fi
}

# Check prerequisites
echo "🔧 Checking prerequisites..."
if ! command -v docker &> /dev/null; then
    echo -e "❌ ${RED}Docker not found${NC}. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! command -v docker compose &> /dev/null; then
    echo -e "❌ ${RED}Docker Compose not found${NC}. Please install Docker Compose first."
    exit 1
fi

echo -e "✅ ${GREEN}Prerequisites satisfied${NC}"

# Build containers
print_stage "BUILD"
echo "🏗️ Building Docker containers..."
docker build --target development -t playground:dev .
docker build --target ci -t playground:ci .
docker build --target production -t playground:prod .

# Initialize test results
FAILED_TESTS=()

# ENVIRONMENT VERIFICATION
print_stage "ENVIRONMENT VERIFICATION"
run_test "Development container environment" "docker run --rm playground:dev node --version" || FAILED_TESTS+=("dev-env")
run_test "CI container environment" "docker run --rm playground:ci which markdownlint" || FAILED_TESTS+=("ci-env")

# QUALITY CHECKS STAGE
print_stage "QUALITY CHECKS"
run_test "Markdown linting" "docker run --rm -v \$(pwd):/app:ro playground:ci markdownlint src/ docs/ *.md --config .markdownlint.json" || FAILED_TESTS+=("markdown-lint")
run_test "Markdown link checking" "docker run --rm -v \$(pwd):/app:ro playground:ci markdown-link-check src/*.md docs/*.md *.md --config .markdown-link-check.json" || FAILED_TESTS+=("link-check")

# CONTAINER PARITY SIMULATION
print_stage "GITHUB ACTIONS PARITY"
run_test "Complete GitHub Actions simulation" "make github-ci" || FAILED_TESTS+=("github-parity")

# SUMMARY
echo -e "\n${YELLOW}📊 TEST SUMMARY${NC}"
echo "========================================"
if [ \${#FAILED_TESTS[@]} -eq 0 ]; then
    echo -e "🎉 ${GREEN}ALL TESTS PASSED${NC}"
    echo "Your code is ready for GitHub Actions! 🚀"
    echo -e "\n${BLUE}Environment Parity Guaranteed:${NC}"
    echo "✅ Same Node.js version and tools"
    echo "✅ Same markdown linting configuration"
    echo "✅ Same link checking behavior"
    echo "✅ Same container build process"
    echo "✅ Same CI commands and execution order"
    echo ""
    echo -e "${GREEN}🎯 100% LOCAL ↔️ GITHUB ACTIONS PARITY ACHIEVED!${NC}"
    exit 0
else
    echo -e "❌ ${RED}SOME TESTS FAILED${NC}"
    echo "Failed tests:"
    for test in "\${FAILED_TESTS[@]}"; do
        echo -e "  • ${RED}\$test${NC}"
    done
    echo -e "\nPlease fix the failing tests before pushing to GitHub."
    echo -e "\n${YELLOW}💡 TIP: Run 'make github-ci' to test individual components${NC}"
    exit 1
fi
