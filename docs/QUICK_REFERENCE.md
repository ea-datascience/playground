# Quick Reference: Container-First DevOps Commands

## 🚀 Essential Commands

### Daily Development
```bash
make dev           # Start interactive development container
make github-ci     # ⭐ Run complete CI pipeline locally (MUST before push)
make test          # Quick container testing
make lint          # Code quality checks
```

### Setup & Maintenance
```bash
make setup         # First-time environment setup
make build         # Build all container stages
make clean         # Cleanup containers and volumes
make help          # Show all available commands
```

## 🎯 The Golden Rule

**Before every git push, run:**
```bash
make github-ci
```

If this passes locally, it will pass in GitHub Actions. **100% guaranteed.**

## 🐳 Container Stages

| Stage | Purpose | Command | Usage |
|-------|---------|---------|-------|
| `development` | Interactive coding | `make dev` | Active development |
| `ci` | Testing & validation | `make github-ci` | CI/CD pipeline |
| `production` | Deployment ready | `docker build --target production` | Production deploy |

## 🔄 Typical Workflow

```bash
# 1. Start development
git checkout -b feature/my-feature
make dev

# 2. Inside container: code, test, develop
# ... edit files ...
exit

# 3. Validate before push (CRITICAL STEP)
make github-ci

# 4. If passed, commit and push
git add .
git commit -m "feat: add new feature"
git push origin feature/my-feature
```

## 📊 Pipeline Stages

When you push to GitHub, this pipeline runs automatically:

1. **🏗️ Build Containers** - Same containers as your local environment
2. **🔍 Quality Checks** - Markdown linting, link validation
3. **🎯 Parity Validation** - Ensures local/CI equivalence  
4. **🔒 Security Scan** - Trivy vulnerability scanning
5. **🚀 Deployment Ready** - Production readiness check

## 🎪 Key Features

- **✅ 100% Environment Parity**: Local == CI/CD
- **⚡ Fast Feedback**: Catch issues in development
- **🔒 Security First**: Vulnerability scanning built-in
- **📝 Quality Gates**: Documentation and code quality enforced
- **🐳 Container First**: All development in containers

## 🆘 Troubleshooting

### "make github-ci" fails
1. Check error messages carefully
2. Run `make dev` to debug interactively
3. Fix issues inside container
4. Re-run `make github-ci`

### Container build issues
```bash
make clean        # Clean up old containers
make build        # Rebuild all stages
```

### Permission issues
```bash
# On macOS/Linux, ensure Docker has proper permissions
docker ps         # Should work without sudo
```

---
**💡 Pro Tip**: Always run `make github-ci` before pushing. It runs the exact same checks as GitHub Actions!
