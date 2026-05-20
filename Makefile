.DEFAULT_GOAL := help
.PHONY: help clean check sync

help: ## show this help
	@awk 'BEGIN {FS=":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

sync: ## resolve dependencies and create .venv + uv.lock
	uv sync

clean: ## remove gitignored files (.venv, caches, dist)
	git clean -fdX

check: ## verify .venv and uv.lock both exist
	@test -d .venv || { echo "✘ .venv/ missing — try: uv sync"; exit 1; }
	@test -f uv.lock || { echo "✘ uv.lock missing — try: uv sync"; exit 1; }
	@echo "✔ .venv and uv.lock both present"
