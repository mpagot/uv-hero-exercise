.DEFAULT_GOAL := help
.PHONY: help clean check build install

help: ## show this help
	@awk 'BEGIN {FS=":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## run `uv build` (expect a warning about the missing upper bound on uv_build)
	uv build

install: ## create .venv if missing, then editable-install this package
	@test -d .venv || uv venv
	uv pip install -e .

clean: ## drop .venv, dist/, caches, sentinel files
	@git clean -fdX

check: ## verify dist/ has both sdist + wheel, editable install works, and the entry point runs
	@test -f dist/uv_hero-0.1.0.tar.gz \
	  || { echo "✘ dist/uv_hero-0.1.0.tar.gz missing — run: uv build"; exit 1; }
	@echo "✔ sdist present: dist/uv_hero-0.1.0.tar.gz"
	@test -f dist/uv_hero-0.1.0-py3-none-any.whl \
	  || { echo "✘ dist/uv_hero-0.1.0-py3-none-any.whl missing — run: uv build"; exit 1; }
	@echo "✔ wheel present: dist/uv_hero-0.1.0-py3-none-any.whl"
	@test -d .venv \
	  || { echo "✘ .venv missing — run: uv venv (then: uv pip install -e .)"; exit 1; }
	@uv pip install -e . --quiet \
	  || { echo "✘ uv pip install -e . failed"; exit 1; }
	@echo "✔ uv pip install -e . succeeded"
	@.venv/bin/uv-hero --name workshop 2>/dev/null | grep -q "Hello, workshop" \
	  || { echo "✘ .venv/bin/uv-hero did not print 'Hello, workshop'"; exit 1; }
	@test -f .hello_workshop \
	  || { echo "✘ .hello_workshop sentinel missing — the installed binary didn't run"; exit 1; }
	@echo "✔ .venv/bin/uv-hero --name workshop → 'Hello, workshop!' (sentinel written)"
