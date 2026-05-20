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

`make check` verifies, in order:

1. `click` appears under `[project.dependencies]`
2. A `[dependency-groups]` dev list contains `ruff` or `ty`
3. `import click` actually works inside the project venv
4. `.venv/` exists (uv add syncs as it goes)
5. `uv.lock` exists (uv add rewrites the lockfile after each edit)

`make clean` resets the branch back to the empty-deps seed (drops
`.venv/`, `uv.lock`, and undoes your `pyproject.toml` edits). Full
instructions live in `../EXERCISES.md §4`.
