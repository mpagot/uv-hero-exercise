# Branch: `exec_2` — `uv init`

**Goal:** scaffold a brand-new Python project from nothing with `uv init`.

## What you have on this branch

Just this README and a `Makefile`. There is intentionally no
`pyproject.toml`, no `src/`, no `.venv/` — you are starting from zero.

## Hints

- `uv init demo` creates a `demo/` subdir with `pyproject.toml`,
  `.python-version`, `main.py`, `README.md`, and a fresh git repo.
- `uv init -p 3.11 demo-pinned` forces a specific Python version into
  the new project's `requires-python` (instead of inheriting your default).
- Once initialised, you can `cd demo && uv run main.py` to execute the
  generated "hello" script without ever activating a virtualenv.

## When you think you're done

```bash
make check
```

`make check` verifies, in order:

1. A `pyproject.toml` exists (top-level or in a subdir uv created)
2. A `.python-version` sits next to it
3. A `main.py` sits next to it
4. `uv run main.py` from that directory exits 0 and prints something

Full instructions live in `../EXERCISES.md §2`.
