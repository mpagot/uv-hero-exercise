.DEFAULT_GOAL := help
.PHONY: help clean check sync run lint typecheck build

help: ## show this help
	@awk 'BEGIN {FS=":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

sync: ## resolve dependencies and create .venv
	uv sync

run: ## run the uv-hero CLI
	uv run uv-hero hello --name=workshop

lint: ## run ruff (installed dev tool)
	uv run ruff check .

typecheck: ## run ty (installed dev tool)
	uv run ty check src/

build: ## build sdist + wheel into ./dist
	uv build

clean: ## remove gitignored files (.venv, dist, caches)
	git clean -fdX

check: ## verify the solution is healthy end-to-end
	@echo "▸ uv sync"
	@uv sync --quiet
	@echo "▸ uv run uv-hero hello"
	@uv run --quiet uv-hero hello | grep -q "Hello, World" || { echo "✘ CLI did not greet"; exit 1; }
	@echo "▸ ruff (dev dep)"
	@uv run --quiet ruff check . >/dev/null || { echo "✘ ruff failed"; exit 1; }
	@echo "▸ ty (dev dep)"
	@uv run --quiet ty check src/ >/dev/null 2>&1 || { echo "✘ ty failed"; exit 1; }
	@echo "▸ uv build"
	@uv build --quiet
	@ls dist/uv_hero-0.1.0-*.whl >/dev/null 2>&1 || { echo "✘ wheel not built"; exit 1; }
	@ls dist/uv_hero-0.1.0.tar.gz >/dev/null 2>&1 || { echo "✘ sdist not built"; exit 1; }
	@echo "✔ solution passes all checks"
