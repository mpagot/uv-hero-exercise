# Branch: `exec_5` — `uv run`

**Goal:** invoke the project's CLI script (`uv-hero hello`) through `uv run`
without ever activating a virtualenv yourself.

## What you have on this branch

A fully wired-up project:

- `pyproject.toml` with `click`, a `[project.scripts]` entry, and a build
  system
- `src/uv_hero/cli.py` — the tiny `click` app (you do **not** need to
  understand click)
- `uv.lock` already generated

## When you think you're done

```bash
make check
```

`make check` passes when `uv run uv-hero hello` exits 0 and prints
something containing "Hello". Full instructions live in
`../EXERCISES.md §5`.
