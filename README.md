# Branch: `exec_5` — `uv run`

**Goal:** internalise `uv run` as the answer to "how do I execute a
Python script with its dependencies" — without ever running
`source .venv/bin/activate`.

## What's pre-wired on this branch

- `hello.py` (top-level, NOT a package) — a tiny `click` script. Treat
  `click` as a black-box "hello" library; you don't need to read its
  docs. The script also drops a small `.hello_<name>` sentinel file
  next to itself so `make check` can tell that YOU invoked it (not just
  the test harness).
- `pyproject.toml` — declares the project but lists **no** runtime
  dependencies. `uv sync` alone does nothing useful here.
- No `.venv/`, no `uv.lock` — you have to materialise both yourself.

## What you have to do

```bash
uv add click                          # adds click to pyproject + installs + writes uv.lock
uv run hello.py                       # → Hello, World!  (drops .hello_world)
uv run hello.py --name=workshop       # → Hello, workshop!  (drops .hello_workshop)
```

Notice you never typed `source .venv/bin/activate`. `uv run` syncs
`.venv/` to `uv.lock` then exec's your command — every time.

## Bonus pattern: `uv run --with PKG` (ephemeral dep)

When you want a package for a one-off command but **not** as a project
dependency:

```bash
uv run --with rich python3 -c "from rich import print; print('[bold]hi[/]')"
grep rich pyproject.toml              # nothing — rich did NOT leak in
```

`--with` injects the dep into a one-off env; your project file stays
clean. This is the escape hatch for "I just want to try this real quick".

## What you should walk away knowing

- `uv add PKG` writes `pyproject.toml`, creates `.venv/`, writes
  `uv.lock` — all in one step.
- `uv run CMD` = "sync `.venv` to `uv.lock`, then exec CMD" — every time.
- There is no "did I activate the right venv?" question, ever.
- The same `uv run` line works in dev, CI, git hooks, and cron with no
  extra setup.
- `--with PKG` is the escape hatch for one-off tools without polluting
  your dependency declaration.

## When you think you're done

```bash
make check
```

`make check` verifies, in order:

1. `.venv/` exists (proof you ran `uv add` or `uv sync`)
2. `uv.lock` exists (proof `uv add` ran)
3. `click` is listed in `pyproject.toml [project.dependencies]`
4. `.hello_world` exists and contains `Hello, World!` (proof you ran
   `uv run hello.py`)
5. `.hello_workshop` exists and contains `Hello, workshop!` (proof you
   ran `uv run hello.py --name=workshop`)

Note `make check` itself never invokes `uv run` — the sentinels force
YOU to do it.

`make clean` resets the branch (wipes `.venv/`, `uv.lock`, sentinels,
caches AND restores `pyproject.toml` to the empty-deps seed), so you
can re-run the exercise from scratch. Full instructions live in
`../EXERCISES.md §5`.
