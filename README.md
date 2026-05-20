# Branch: `exec_4` — `uv add` (runtime + dev deps)

**Goal:** add `click` as a runtime dependency, and add `ruff` and `ty` to a
dev dependency group — all via `uv add` (no hand-editing of
`pyproject.toml`).

## What you have on this branch

- `pyproject.toml` with an empty `dependencies` list
- `.python-version` pinning to 3.13

## When you think you're done

```bash
make check
```

`make check` passes when `click` appears under `[project] dependencies`
AND a dev group lists `ruff` or `ty`. Full instructions live in
`../EXERCISES.md §4`.
