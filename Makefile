.DEFAULT_GOAL := help
.PHONY: help clean check run

help: ## show this help
	@awk 'BEGIN {FS=":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

run: ## run the CLI via uv (auto-syncs first)
	uv run uv-hero hello --name=workshop

clean: ## remove gitignored files (.venv, caches, dist)
	git clean -fdX

check: ## verify .venv exists, then three uv run patterns: console script, arg passthrough, ephemeral --with
	@test -d .venv || { echo "✘ no .venv/ here yet — you haven't materialised the env. Run: uv run uv-hero hello   (or: uv sync)"; exit 1; }
	@echo "✔ .venv/ present (you ran uv sync or uv run at least once)"
	@uv run --quiet uv-hero hello 2>/dev/null | grep -q "Hello, World" \
	  || { echo "✘ default greeting failed — try: uv run uv-hero hello"; exit 1; }
	@echo "✔ uv run uv-hero hello → 'Hello, World!'"
	@uv run --quiet uv-hero hello --name=workshop 2>/dev/null | grep -q "Hello, workshop" \
	  || { echo "✘ arg pass-through failed — try: uv run uv-hero hello --name=workshop"; exit 1; }
	@echo "✔ uv run uv-hero hello --name=workshop → 'Hello, workshop!'"
	@uv run --quiet --with rich python3 -c "from rich import print; print('ok')" >/dev/null 2>&1 \
	  || { echo "✘ --with rich failed — try: uv run --with rich python3 -c 'from rich import print; print(\"hi\")'"; exit 1; }
	@echo "✔ uv run --with rich python3 ... → ephemeral dep ran"
	@if grep -q '"rich' pyproject.toml; then \
	  echo "✘ rich leaked into pyproject.toml — --with must NOT modify dependencies"; exit 1; \
	fi
	@echo "✔ rich did NOT leak into pyproject.toml"
