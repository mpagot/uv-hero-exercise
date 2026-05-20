.DEFAULT_GOAL := help
.PHONY: help clean check lint typecheck

help: ## show this help
	@awk 'BEGIN {FS=":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

lint: ## lint via uvx (no dev dep needed)
	uvx ruff check .

typecheck: ## typecheck via uvx (no dev dep needed)
	uvx ty check src/

clean: ## remove gitignored files (.venv, caches, dist)
	git clean -fdX

check: ## verify uvx can run ruff and ty
	@uvx --quiet ruff --version >/dev/null 2>&1 || { echo "✘ uvx ruff failed — try: uvx ruff --version"; exit 1; }
	@uvx --quiet ty --version >/dev/null 2>&1 || { echo "✘ uvx ty failed — try: uvx ty --version"; exit 1; }
	@echo "✔ uvx can run both ruff and ty"
