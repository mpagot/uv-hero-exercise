.DEFAULT_GOAL := help
.PHONY: help clean check

help: ## show this help
	@awk 'BEGIN {FS=":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

clean: ## remove gitignored files (.venv, caches, dist)
	git clean -fdX

check: ## verify a pyproject.toml was created
	@find . -name pyproject.toml -not -path './.git/*' | grep -q . || { echo "✘ no pyproject.toml found — try: uv init"; exit 1; }
	@echo "✔ pyproject.toml present: $$(find . -name pyproject.toml -not -path './.git/*' | head -1)"
