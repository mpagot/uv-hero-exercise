# Branch: `exec_6` — `uvx`

**Goal:** run `ruff` and `ty` against this project's source **without**
declaring them as dev dependencies — using `uvx` (ephemeral tool runner).

## What you have on this branch

The same project as `exec_5`'s solution (click CLI, ready to run via
`uv run uv-hero hello`), but `src/uv_hero/cli.py` ships with a couple
of **intentional defects**:

- one lint issue that `ruff` will flag
- one type issue that `ty` will flag

Your job is to spot them with `uvx` and fix them. `pyproject.toml`
declares **no dev dependencies** — that's deliberate: `uvx` fetches
tools on demand into an isolated env, so you don't need them in your
project.

## What you have to do

```bash
uv run uv-hero hello                       # sanity check — should already print Hello, World!
uvx ruff check src/uv_hero/cli.py          # see what ruff complains about, then fix cli.py
uvx ty check --error all src/uv_hero/cli.py  # see what ty complains about, then fix cli.py
```

Edit `src/uv_hero/cli.py` until both tools report a clean run.

After every fix, re-run the two `uvx ...` commands. When both print
`All checks passed!`, run `make check`.

## What you should walk away knowing

- `uvx TOOL` = "fetch TOOL into a one-off env, run it, throw it away".
- Compare to `uv add --dev TOOL` (next time you'd reach for it): with
  `uvx`, the tool is **not** declared in `pyproject.toml` and **not**
  installed in your project's `.venv/`. It's right for ad-hoc tools
  (ruff, ty, black, mypy, http servers, ...) that aren't part of your
  app's runtime or test stack.
- `--error all` on `ty` promotes every rule to error level — handy when
  you want a strict pass/fail signal in a checker.

## When you think you're done

```bash
make check
```

`make check` verifies, in order:

1. `uv run uv-hero hello` still prints `Hello, World!` (you didn't
   break the CLI while fixing it)
2. `uvx ruff check src/uv_hero/cli.py` reports nothing
3. `uvx ty check --error all src/uv_hero/cli.py` reports nothing
4. Neither `ruff` nor `ty` leaked into `pyproject.toml` (proof you used
   `uvx`, not `uv add --dev`)

`make clean` resets the branch (wipes `.venv/`, caches AND `git
restore`s `cli.py`, `pyproject.toml`, `uv.lock` to the seed), so you
can re-run the exercise from scratch. Full instructions live in
`../EXERCISES.md §6`.
