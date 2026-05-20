.DEFAULT_GOAL := help
.PHONY: help clean check lint typecheck run

help: ## show this help
	@awk 'BEGIN {FS=":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

run: ## sanity-check the CLI still runs (works on a fresh clone with no setup)
	@uv run --quiet uv-hero hello 2>/dev/null | grep -q "Hello, World" \
	  || { echo "✘ uv run uv-hero hello failed — cli.py is broken at the import/syntax level"; exit 1; }
	@echo "✔ uv run uv-hero hello → 'Hello, World!'"

lint: ## lint the CLI via uv run (assumes you ran: uv add --dev ruff)
	uv run ruff check src/uv_hero/cli.py

typecheck: ## typecheck the CLI via uv run (assumes you ran: uv add --dev ty)
	uv run ty check --error all src/uv_hero/cli.py

clean: ## reset the branch (drop .venv/caches AND restore cli.py + pyproject + uv.lock to seed)
	@git clean -fdX
	@git restore src/uv_hero/cli.py pyproject.toml uv.lock

check: run lint typecheck ## verify uv run works, uv run ruff/ty have no complaints, ruff AND ty ARE in pyproject
	@grep -E '^\s*"ruff' pyproject.toml >/dev/null \
	  || { echo "✘ ruff not declared as a dev dep — run: uv add --dev ruff"; exit 1; }
	@echo "✔ ruff declared in pyproject (dev group)"
	@grep -E '^\s*"ty' pyproject.toml >/dev/null \
	  || { echo "✘ ty not declared as a dev dep — run: uv add --dev ty"; exit 1; }
	@echo "✔ ty declared in pyproject (dev group)"
