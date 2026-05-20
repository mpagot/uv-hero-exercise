# Branch: `exec_3` — `uv sync`

**Goal:** turn a `pyproject.toml` into a reproducible `.venv/` + `uv.lock`.

## What you have on this branch

- `pyproject.toml` declaring a single dependency (`click`)
- `.python-version` pinning to 3.13

No virtualenv, no lockfile yet — that's what you'll create.

## When you think you're done

```bash
make check
```

`make check` passes when both `.venv/` and `uv.lock` exist. Full
instructions live in `../EXERCISES.md §3`.
