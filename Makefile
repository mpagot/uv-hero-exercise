.DEFAULT_GOAL := help
.PHONY: help clean check

help: ## show this help
	@awk 'BEGIN {FS=":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

clean: ## remove gitignored files (.venv, caches, dist)
	git clean -fdX

check: ## verify uv init created a runnable project (pyproject + .python-version + main.py)
	@PROJ=$$(find . -maxdepth 3 -name pyproject.toml -not -path './.git/*' -print -quit); \
	  test -n "$$PROJ" || { echo "✘ no pyproject.toml found — try: uv init demo"; exit 1; }; \
	  PROJDIR=$$(dirname "$$PROJ"); \
	  echo "✔ pyproject.toml at $$PROJ"; \
	  test -f "$$PROJDIR/.python-version" || { echo "✘ $$PROJDIR/.python-version missing — uv init normally creates one"; exit 1; }; \
	  echo "✔ .python-version present ($$(cat $$PROJDIR/.python-version))"; \
	  test -f "$$PROJDIR/main.py" || { echo "✘ $$PROJDIR/main.py missing — uv init normally creates a hello main.py"; exit 1; }; \
	  OUT=$$(cd "$$PROJDIR" && uv run --quiet main.py 2>&1) || { echo "✘ uv run main.py failed: $$OUT"; exit 1; }; \
	  test -n "$$OUT" || { echo "✘ uv run main.py produced no output"; exit 1; }; \
	  echo "✔ uv run main.py prints: $$OUT"
