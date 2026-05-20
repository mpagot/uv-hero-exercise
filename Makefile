.DEFAULT_GOAL := help
.PHONY: help clean check

help: ## show this help
	@awk 'BEGIN {FS=":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

clean: ## remove gitignored files (.venv, caches, dist)
	@git clean -fdX
	@git restore pyproject.toml

check: ## verify click is a runtime dep, ruff/ty are dev deps, and click is importable
	@grep -E '^\s*"click' pyproject.toml >/dev/null || { echo "✘ click not listed in pyproject.toml — try: uv add click"; exit 1; }
	@echo "✔ click listed in [project.dependencies]"
	@grep -E '^\s*"(ruff|ty)' pyproject.toml >/dev/null || { echo "✘ neither ruff nor ty found as dev dep — try: uv add --dev ruff ty"; exit 1; }
	@echo "✔ ruff and/or ty listed in [dependency-groups.dev]"
	@uv run --quiet python3 -c $$'import click\nfrom importlib.metadata import version\nprint(f"click {version(\'click\')} importable")' \
	  || { echo "✘ click is declared but not installed — run: uv sync"; exit 1; }
	@test -d .venv || { echo "✘ .venv/ missing — uv add normally creates it; run: uv sync"; exit 1; }
	@echo "✔ .venv/ present"
	@test -f uv.lock || { echo "✘ uv.lock missing — uv add normally writes it; run: uv sync"; exit 1; }
	@echo "✔ uv.lock present"
