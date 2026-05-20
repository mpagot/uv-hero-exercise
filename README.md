# exec_7 — `uv add --dev`: declare your tools

Same broken CLI as **exec_6**, but this time you fix it with `ruff` and `ty`
declared as **dev dependencies in `pyproject.toml`** — not run ad-hoc with
`uvx`. The contrast is the whole point.

## What you have

- `pyproject.toml` — `click>=8.1` only, no dev deps yet
- `src/uv_hero/cli.py` — same broken `import os` + bad `return 0` as exec_6
- `uv.lock` — locked against the seed pyproject (no dev deps)
- `Makefile` — `make check` runs `uv run ruff …` and `uv run ty …` (not `uvx`)

## What to do

```sh
uv add --dev ruff ty           # writes [dependency-groups] dev to pyproject + uv.lock
uv run ruff check src/uv_hero/cli.py
uv run ty check --error all src/uv_hero/cli.py
# fix cli.py so both pass
make check
```

## When you're done

`make check` passes when:
- `uv run uv-hero hello` prints `Hello, World!`
- `uv run ruff check` is clean
- `uv run ty check --error all` is clean
- **both** `ruff` and `ty` appear in `pyproject.toml` (this is the exec_7 twist)

## `uvx` (exec_6) vs `uv add --dev` (exec_7)

|                       | `uvx ruff`               | `uv add --dev ruff`              |
| --------------------- | ------------------------ | -------------------------------- |
| Tracked in pyproject  | no                       | yes (`[dependency-groups]`)      |
| Reproducible in CI    | only via pinned version  | yes — locked in `uv.lock`        |
| Use when              | ad-hoc, one-off          | project-wide, every contributor  |

If everyone on the team needs the tool, declare it. If it's just you poking at
something once, `uvx` keeps `pyproject.toml` clean.

## Reset

```sh
make clean     # drops .venv/caches AND restores cli.py + pyproject + uv.lock
```
