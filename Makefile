.DEFAULT_GOAL := help
.PHONY: help clean check run

help: ## show this help
	@awk 'BEGIN {FS=":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

run: ## run the CLI via uv (it syncs on demand)
	uv run uv-hero hello --name=workshop

clean: ## remove gitignored files (.venv, caches, dist)
	git clean -fdX

check: ## verify the CLI greets when invoked via uv run
	@uv run --quiet uv-hero hello 2>/dev/null | grep -q "Hello" || { echo "✘ uv-hero hello did not greet — try: uv run uv-hero hello"; exit 1; }
	@echo "✔ uv run uv-hero hello greets correctly"
