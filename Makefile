.DEFAULT_GOAL := help
.PHONY: help clean check lint typecheck run diagnose

help: ## show this help
	@awk 'BEGIN {FS=":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

run: ## sanity-check the CLI still runs (works on a fresh clone with no setup)
	@uv run --quiet uv-hero hello 2>/dev/null | grep -q "Hello, World" \
	  || { echo "✘ uv run uv-hero hello failed — cli.py is broken at the import/syntax level"; exit 1; }
	@echo "✔ uv run uv-hero hello → 'Hello, World!'"

diagnose: ## verify ruff/ty are in .venv (not shadowed by /usr/bin or anywhere on PATH)
	@for tool in ruff ty; do \
	  if [ -x .venv/bin/$$tool ]; then \
	    echo "✔ .venv/bin/$$tool present ($$(.venv/bin/$$tool --version 2>&1 | head -1))"; \
	  else \
	    echo "✘ .venv/bin/$$tool MISSING — 'uv run $$tool' would fall back to PATH and lie to you:"; \
	    SYS=$$(command -v $$tool 2>/dev/null || true); \
	    if [ -n "$$SYS" ]; then \
	      echo "    which $$tool   → $$SYS"; \
	      OWN=$$(rpm -qf "$$SYS" 2>/dev/null); \
	      case "$$OWN" in *"not owned"*|*"is not owned"*|"") OWN="" ;; esac; \
	      [ -n "$$OWN" ] && echo "    rpm -qf       → $$OWN"; \
	      echo "    fix:           uv add --dev $$tool   (declare it as a project dev dep)"; \
	      [ -n "$$OWN" ] && echo "    or remove the shadowing copy:  sudo zypper remove $$OWN"; \
	    else \
	      echo "    (nothing on PATH either — fix: uv add --dev $$tool)"; \
	    fi; \
	    exit 1; \
	  fi; \
	done

lint: ## lint the CLI via uv run (assumes you ran: uv add --dev ruff)
	uv run ruff check src/uv_hero/cli.py

typecheck: ## typecheck the CLI via uv run (assumes you ran: uv add --dev ty)
	uv run ty check --error all src/uv_hero/cli.py

clean: ## reset the branch (drop .venv/caches AND restore cli.py + pyproject + uv.lock to seed)
	@git clean -fdX
	@git restore src/uv_hero/cli.py pyproject.toml uv.lock

check: run diagnose lint typecheck ## verify uv run works, no system shadow, lint/typecheck clean, ruff+ty in dev ONLY
	@for tool in ruff ty; do \
	  in_dev=$$(awk -v t="$$tool" '/^\[dependency-groups\]/{d=1;next} /^\[/{d=0} d && $$0 ~ "\"" t {print 1; exit}' pyproject.toml); \
	  in_prj=$$(awk -v t="$$tool" '/^\[project\]/{p=1;next} /^\[/{p=0;r=0} p && /^dependencies/{r=1} p && r && $$0 ~ "\"" t {print 1; exit} r && /\]/{r=0}' pyproject.toml); \
	  if [ -n "$$in_dev" ] && [ -n "$$in_prj" ]; then \
	    echo "✘ $$tool is in BOTH [project.dependencies] AND [dependency-groups].dev"; \
	    echo "    happens when you run 'uv add $$tool' first, then 'uv add --dev $$tool' — leftover in project deps"; \
	    echo "    fix:  uv remove $$tool        (removes from project deps; dev entry stays)"; \
	    exit 1; \
	  elif [ -n "$$in_dev" ]; then \
	    echo "✔ $$tool in [dependency-groups] only"; \
	  elif [ -n "$$in_prj" ]; then \
	    echo "✘ $$tool is in [project.dependencies] — you ran 'uv add $$tool' instead of 'uv add --dev $$tool'"; \
	    echo "    fix:  uv remove $$tool && uv add --dev $$tool"; \
	    exit 1; \
	  else \
	    echo "✘ $$tool not declared — fix: uv add --dev $$tool"; \
	    exit 1; \
	  fi; \
	done
