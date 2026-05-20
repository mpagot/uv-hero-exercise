.DEFAULT_GOAL := help
.PHONY: help clean check

help: ## show this help
	@awk 'BEGIN {FS=":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

clean: ## remove gitignored files (the global uv interpreter dir is untouched)
	git clean -fdX

check: ## verify uv, the .python-version pin, and that uv honours it
	@command -v uv >/dev/null 2>&1 || { echo "✘ uv not on PATH — see §0 of EXERCISES.md"; exit 1; }
	@echo "✔ uv is on PATH ($$(uv --version))"
	@test -f .python-version || { echo "✘ .python-version missing — create it: echo \"3.13\" > .python-version"; exit 1; }
	@PIN=$$(cat .python-version); echo "✔ .python-version pins $$PIN"; \
	  uv python find "$$PIN" >/dev/null 2>&1 || { echo "✘ uv cannot find $$PIN — try: uv python install $$PIN"; exit 1; }; \
	  uv python pin >/dev/null 2>&1 || { echo "✘ 'uv python pin' did not pick up .python-version"; exit 1; }; \
	  echo "✔ uv honours the pin: $$(uv python find "$$PIN")"
