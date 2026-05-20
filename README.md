# Branch: `exec_5` — `uv run`

**Goal:** internalise three patterns of `uv run` against a real,
pre-wired project — without ever running `source .venv/bin/activate`.

## What's pre-wired on this branch

A complete (if tiny) `click` CLI you can invoke immediately:

- `pyproject.toml` declares `click` as a runtime dep and exposes a
  `[project.scripts]` entry named `uv-hero` pointing at
  `uv_hero.cli:main`.
- `src/uv_hero/cli.py` is the actual `click` app (you do **not** need
  to understand `click` — treat it as a black-box "hello" CLI).
- `uv.lock` is committed; `.venv/` is NOT — you have to materialise it
  yourself, either by `uv sync` or implicitly by `uv run`.

## Three patterns you should be able to run

| # | Command | What it teaches |
|---|---------|-----------------|
| 1 | `uv run uv-hero hello` | invoke a project console-script (no `activate`) — also creates `.venv/` on first call |
| 2 | `uv run uv-hero hello --name=workshop` | extra args pass straight through to the script |
| 3 | `uv run --with rich python3 -c "from rich import print; print('[bold]hi[/]')"` | use an ephemeral dep that is NOT in `pyproject.toml` |

After running pattern 3, check `grep rich pyproject.toml` — you should
get nothing. `--with` injects the dep into a one-off env; your project
file stays clean.

## What you should walk away knowing

- `uv run` = "sync `.venv` to `uv.lock`, then exec" — every time.
- There is no "did I activate the right venv?" question, ever.
- The same `uv run CMD` line works in dev, CI, git hooks, and cron with
  no extra setup.
- `--with PKG` is the escape hatch for one-off tools without polluting
  your dependency declaration.

## When you think you're done

```bash
make check
```

`make check` verifies, in order:

1. `.venv/` exists (proof you ran `uv sync` or `uv run` at least once —
   `make clean` wipes it, so this fails on a freshly-checked-out branch)
2. The default greeting prints `Hello, World!`
3. `--name=workshop` is passed through and produces `Hello, workshop!`
4. `--with rich` lets a non-project dep run AND `rich` does NOT appear
   in `pyproject.toml` afterwards

`make clean` resets the branch (wipes `.venv/`), so you can re-run the
exercise from scratch. Full instructions live in `../EXERCISES.md §5`.
