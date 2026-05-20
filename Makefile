.DEFAULT_GOAL := help
.PHONY: help clean check

help: ## show this help
	@awk 'BEGIN {FS=":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

clean: ## remove gitignored files (uv interpreter dir is global, not touched)
	git clean -fdX

check: ## verify uv has a 3.13 interpreter it can use
	@uv python find 3.13 >/dev/null 2>&1 || { echo "✘ uv cannot find a 3.13 interpreter — try: uv python install 3.13"; exit 1; }
	@echo "✔ uv knows about Python 3.13: $$(uv python find 3.13)"
