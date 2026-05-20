.DEFAULT_GOAL := help
.PHONY: help clean check lint typecheck run

help: ## show this help
	@awk 'BEGIN {FS=":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

run: ## sanity-check the CLI still runs (works on a fresh clone with no setup)
	@uv run --quiet uv-hero hello 2>/dev/null | grep -q "Hello, World" \
	  || { echo "✘ uv run uv-hero hello failed — cli.py is broken at the import/syntax level"; exit 1; }
	@echo "✔ uv run uv-hero hello → 'Hello, World!'"

lint: ## lint the CLI via uvx (no dev dep needed)
	uvx ruff check src/uv_hero/cli.py

typecheck: ## typecheck the CLI via uvx, with every rule promoted to error
	uvx ty check --error all src/uv_hero/cli.py

clean: ## reset the branch (drop .venv/caches AND restore cli.py + pyproject + uv.lock to seed)
	@git clean -fdX
	@git restore src/uv_hero/cli.py pyproject.toml uv.lock

check: run lint typecheck## verify uv run works, then uvx ruff/ty have no complaints, ruff/ty not in pyproject
	@if grep -E '^\s*"(ruff|ty)' pyproject.toml >/dev/null; then \
	  echo "✘ ruff/ty leaked into pyproject.toml — uvx must NOT add them as deps. Try: uv remove --dev ruff ty"; \
	  exit 1; \
	fi
	@echo "✔ ruff/ty NOT in pyproject (you used uvx, not uv add --dev)"
