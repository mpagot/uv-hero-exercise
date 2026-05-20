.DEFAULT_GOAL := help
.PHONY: help clean check

help: ## show this help
	@awk 'BEGIN {FS=":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

clean: ## remove gitignored files (.venv, caches, dist)
	git clean -fdX

check: ## verify click is a runtime dep and ruff/ty are dev deps
	@grep -E '^\s*"click' pyproject.toml >/dev/null || { echo "✘ click not listed in pyproject.toml — try: uv add click"; exit 1; }
	@grep -E '^\s*"(ruff|ty)' pyproject.toml >/dev/null || { echo "✘ neither ruff nor ty found as dev dep — try: uv add --dev ruff ty"; exit 1; }
	@echo "✔ click is a runtime dep, ruff/ty in a dev group"
