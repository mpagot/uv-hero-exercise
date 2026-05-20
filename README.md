# Branch: `exec_6` — `uvx`

**Goal:** run `ruff` and `ty` against this project **without** declaring
them as dev dependencies — using `uvx` (ephemeral tool runner).

## What you have on this branch

The same project as `exec_5` (click CLI, ready to run), but **no dev
dependencies** declared in `pyproject.toml`. That's deliberate: `uvx`
fetches tools on demand into an isolated env, so you don't need them in
your project.

## When you think you're done

```bash
make check
```

`make check` passes when both `uvx ruff --version` and `uvx ty --version`
succeed. Full instructions live in `../EXERCISES.md §6`.
