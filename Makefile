.DEFAULT_GOAL := help
.PHONY: help clean check run

help: ## show this help
	@awk 'BEGIN {FS=":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

run: ## run the script via uv (assumes you already ran: uv add click)
	uv run hello.py --name=workshop

clean: ## reset the branch (drop .venv/uv.lock/sentinels/caches AND restore pyproject.toml)
	@git clean -fdX
	@git restore pyproject.toml

check: ## verify .venv + uv.lock, demo raw python (fails w/o uv add), verify sentinels, finally `uv run hello.py`
	@test -d .venv || { echo "✘ no .venv/ here yet — you haven't materialised the env. Run: uv add click"; exit 1; }
	@echo "✔ .venv/ present"
	@test -f uv.lock || { echo "✘ uv.lock missing — uv add normally writes it"; exit 1; }
	@echo "✔ uv.lock present"
	.venv/bin/python3.13 hello.py
	@test -f .hello_world \
	  || { echo "✘ .hello_world missing — run: uv run hello.py   (the script drops a sentinel so this check knows YOU ran it)"; exit 1; }
	@grep -q "Hello, World" .hello_world \
	  || { echo "✘ .hello_world has unexpected content — re-run: uv run hello.py"; exit 1; }
	@echo "✔ .hello_world present"
	@test -f .hello_workshop \
	  || { echo "✘ .hello_workshop missing — run: uv run hello.py --name=workshop"; exit 1; }
	@grep -q "Hello, workshop" .hello_workshop \
	  || { echo "✘ .hello_workshop has unexpected content — re-run: uv run hello.py --name=workshop"; exit 1; }
	@echo "✔ .hello_workshop present"
	@grep -E '^\s*"click' pyproject.toml >/dev/null \
	  || { echo "✘ click not in pyproject.toml — use: uv add click   (not: uv pip install click)"; exit 1; }
	@echo "✔ click listed in [project.dependencies]"
	uv run hello.py
