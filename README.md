# Playground - Shift-Left DevOps with Container Parity

Testing playground for CI/CD with **100% Environment Parity** between local development and GitHub Actions 🚀

## 🎯 Overview

This repository demonstrates modern **Shift-Left DevOps practices** with perfect environment parity between local development and CI/CD. The core principle: **if it works locally in containers, it will work in GitHub Actions**.

### Key Features
- **🐳 Container-First Development**: Primary development happens in Docker containers
- **🎯 Environment Parity**: Local containers are identical to GitHub Actions environment  
- **🔄 Shift-Left Testing**: All validation moved into development workflow
- **⚡ Fast Feedback**: Catch issues in development, not in CI

## 🚀 Quick Start

### First-Time Setup
```bash
# 1. Clone and setup
git clone <repository-url>
cd playground
make setup
```

### Daily Development Workflow
```bash
# Option A: Container-First Development (Recommended)
make dev           # Start development container
# Inside container: edit, test, develop
exit               # Exit container
make github-ci     # Validate full pipeline before push

# Option B: Quick Local Edits  
# Edit files locally
make test          # Test in container
make github-ci     # Validate before push
```

## 🛠️ Available Commands

| Command | Description |
|---------|-------------|
| `make help` | Show all available commands |
| `make setup` | Setup development environment |
| `make dev` | Start interactive development container |
| `make test` | Run tests in container |
| `make lint` | Run code quality checks |
| `make github-ci` | **🎯 Run complete GitHub Actions pipeline locally** |
| `make clean` | Clean up containers and volumes |

## 🎯 The Magic: 100% Environment Parity

### Before Every Push - Run This:
```bash
make github-ci
```

This command runs the **exact same environment and commands** as GitHub Actions. If it passes locally, it will pass in CI.

### Container Stages
- **Development**: Full environment with all tools (`playground:dev`)
- **CI**: Minimal testing environment (`playground:ci`) 
- **Production**: Optimized for deployment (`playground:prod`)

## 📁 Project Structure

## 🏗️ CI/CD Pipeline
Our GitHub Actions pipeline implements a comprehensive shift-left strategy:

### 🔒 Security-First Approach
- Trivy vulnerability scanning
- GitGuardian secret detection
- SARIF security reporting
- Least-privilege permissions

### 📊 Quality Gates
- Markdown linting for documentation
- YAML validation for configurations
- Link checking and validation
- Automated code quality checks

### 🚀 Deployment Strategy
- **Feature branches** → Staging environment
- **Main branch** → Production environment
- Artifact-based deployments
- Post-deployment validation

## 📁 Project Structure
```
playground/
├── .github/
│   ├── workflows/
│   │   └── ci-cd-pipeline.yml     # Main CI/CD pipeline
│   ├── ISSUE_TEMPLATE/            # Issue templates
│   └── pull_request_template.md   # PR template
├── src/
│   ├── main.md                    # Main documentation
│   └── devops.md                  # DevOps practices guide
├── .markdownlint.json             # Markdown linting config
├── .yamllint.yml                  # YAML linting config
├── .markdown-link-check.json      # Link checking config
└── README.md                      # This file
```

## 🚦 Getting Started

### Prerequisites
- Git
- GitHub account
- Basic knowledge of markdown

### Development Workflow
1. **Create feature branch**: `git checkout -b feature/your-feature`
2. **Make changes**: Edit documentation or configurations
3. **Commit changes**: Use conventional commit messages
4. **Push branch**: `git push -u origin feature/your-feature`
5. **Create PR**: Use the provided PR template
6. **Review & Merge**: Automated CI/CD will validate changes

## 🔧 Local Development

### Running Quality Checks Locally
```bash
# Install tools
npm install -g markdownlint-cli
pip install yamllint

# Run checks
markdownlint "**/*.md" --config .markdownlint.json
yamllint -c .yamllint.yml **/*.yml **/*.yaml
```

## 📈 Pipeline Status
The CI/CD pipeline runs on:
- ✅ Every push to any branch
- ✅ Every pull request
- ✅ Manual workflow dispatch

## 🤝 Contributing
1. Fork the repository
2. Create a feature branch
3. Follow the development workflow
4. Ensure all CI/CD checks pass
5. Submit a pull request

## 📚 Documentation
- [DevOps Practices](src/devops.md) - Comprehensive guide to our DevOps approach
- [Main Documentation](src/main.md) - Project main documentation

## 🏷️ License
This project is for educational and testing purposes.

---
**Built with ❤️ using shift-left DevOps principles**
