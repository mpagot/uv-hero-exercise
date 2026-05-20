# uv hero — Exercises

Hands-on companion to the [uv hero](https://docs.astral.sh/uv/) workshop.
Each exercise lives on its own branch of this repo. The workshop runs
"continuous interleave" — after each topic on the slides you get ~5 min to
do the matching exercise.

## How this scaffold works

```bash
git branch -a                  # see the branches
git checkout exec_1            # jump to exercise 1's starting state
cat README.md                  # quick reminder of what files you have
# … follow §1 below …
make check                     # self-grade when you think you're done
```

Two things to keep in mind:

- **Switching branches discards uncommitted work.** Each exercise is
  self-contained on its branch; you do not carry results forward.
- **`make clean` removes only files git is ignoring** (`.venv/`, `dist/`,
  caches). Your edits to tracked files are safe — use `git checkout .` to
  revert those.

A complete reference is on the `full_solution` branch. Peek at it AFTER you
try the exercise, not before.

| Branch | Topic | Time |
|--------|-------|------|
| `exec_1` | `uv python install` — managed interpreters | ~3 min |
| `exec_2` | `uv init` — bootstrap a project | ~5 min |
| `exec_3` | `uv sync` — materialise the venv from the lockfile | ~5 min |
| `exec_4` | `uv add` / `uv add --dev` — edit dependencies | ~5 min |
| `exec_5` | `uv run` — execute without activating the venv | ~5 min |
| `exec_6` | `uvx` — run tools without installing them | ~5 min |
| `full_solution` | reference: the finished click CLI | — |

---

## §0 — Setup (do this BEFORE the workshop)   ⏱ ~2 min

**Goal:** have a working `uv` on your machine and a local clone of this
scaffold before the clock starts.

**Steps:**

1. Install uv. On openSUSE / SLE, use the packaged build:
   ```bash
   sudo zypper in python313-uv
   ```
   Upstream also offers a one-liner if you'd rather pull from Astral
   directly:
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```
2. Verify:
   ```bash
   uv --version
   ```
3. Clone (or copy) this scaffold and `cd` in. Everything else in this file
   assumes you are at the scaffold root with a clean working tree.

**Expected:** `uv --version` prints something like `uv 0.11.x`.

---

## §1 — Python interpreters via `uv`   ⏱ ~3 min

```bash
git checkout exec_1
cat README.md
```

**Goal:** see that `uv` can install Python interpreters without touching
the system Python, then **manually** pin one for this directory with a
`.python-version` file.

**Steps:**

1. Tour the `uv python` subcommands — list, locate, install, upgrade:
   ```bash
   uv python list                  # versions available + already installed
   uv python dir                   # where uv keeps managed interpreters
   uv python install 3.13          # downloads CPython 3.13, no root
   uv python upgrade               # bump installed CPython to latest patch
   uv python find 3.13             # resolve the path uv would use
   ```
2. Confirm nothing leaked into the system:
   ```bash
   which python3
   rpm -q python313 2>/dev/null || echo "not from zypper — good"
   ls ~/.local/share/uv/python/
   ```
3. Manually pin this directory to 3.13 (no `uv init`, no `pyproject.toml`
   — just the version file):
   ```bash
   echo "3.13" > .python-version
   uv python pin                   # uv prints the pin it just read
   ```
4. Self-grade:
   ```bash
   make check
   ```

**Expected:** `make check` prints four ✔ lines (uv on PATH, pin file
exists, the pinned version is installed, `uv python pin` reads it).
System `python3` is unchanged.

**Stretch:** `uv python install 3.11 3.12` — install two more in one call.
The second run is instant (cached).

---

## §2 — `uv init`   ⏱ ~5 min

```bash
git checkout exec_2
cat README.md
```

**Goal:** bootstrap a project and inspect what `uv init` creates.

**Steps:**

1. Default init into a fresh subdir:
   ```bash
   uv init demo
   ls -a demo
   cat demo/pyproject.toml
   cat demo/.python-version
   cat demo/hello.py
   ```
2. Run the generated script (creates `.venv` on first call):
   ```bash
   (cd demo && uv run hello.py)
   ```
3. Try the pinned variant:
   ```bash
   uv init demo-pinned -p 3.13
   diff demo/pyproject.toml demo-pinned/pyproject.toml
   ```
4. Self-grade:
   ```bash
   make check
   ```

**Expected:** `demo-pinned/pyproject.toml` has `requires-python = ">=3.13"`;
`demo/` uses whatever your default is.

**Stretch:** `uv init --lib demo-lib` — `--lib` creates a `src/` layout
suited for publishing.

---

## §3 — `uv sync` + `uv.lock`   ⏱ ~5 min

```bash
git checkout exec_3
cat README.md
```

**Goal:** materialise a `.venv` from a checked-in `pyproject.toml`, and
watch how `uv sync` behaves on repeat runs.

**Steps:**

1. First sync — creates `.venv/` and writes `uv.lock`:
   ```bash
   uv sync
   ls -la .venv uv.lock
   ```
2. Peek at the lockfile (plain TOML, designed to diff cleanly):
   ```bash
   head -30 uv.lock
   ```
3. Run sync again — should be near-instant (nothing to do):
   ```bash
   time uv sync
   ```
4. Force a re-resolution against the latest compatible versions:
   ```bash
   uv sync --upgrade
   ```
5. Self-grade:
   ```bash
   make check
   ```

**Expected:** step 1 prints "Resolved / Installed". Step 3 is sub-50 ms.
`uv.lock` is human-readable TOML.

**Stretch:** `rm -rf .venv && uv sync` — the lockfile alone is enough to
rebuild the env.

---

## §4 — `uv add` / `uv add --dev`   ⏱ ~5 min

```bash
git checkout exec_4
cat README.md
```

**Goal:** edit dependencies through `uv` instead of hand-editing
`pyproject.toml`.

**Steps:**

1. Add a runtime dependency:
   ```bash
   uv add click
   ```
2. Add dev-only tools:
   ```bash
   uv add --dev ruff ty
   ```
3. Try a named group, then back out:
   ```bash
   uv add --group docs sphinx
   uv remove --group docs sphinx
   ```
4. Inspect:
   ```bash
   cat pyproject.toml
   head -30 uv.lock
   ```
5. Self-grade:
   ```bash
   make check
   ```

**Expected:** `pyproject.toml` has `click` under
`[project.dependencies]` and `ruff` + `ty` under
`[dependency-groups.dev]`. `uv.lock` updated atomically.

**Stretch:** `uv add 'rich>=13,<14'` — note how `uv.lock` pins to a single
resolved version even when your constraint allows a range.

---

## §5 — `uv run`   ⏱ ~5 min

```bash
git checkout exec_5
cat README.md
```

**Goal:** execute the project's CLI without activating its virtualenv.

**Steps:**

1. Run the installed console script (auto-syncs first):
   ```bash
   uv run uv-hero hello
   uv run uv-hero hello --name="$USER"
   ```
2. Run an ephemeral package that is NOT a project dep:
   ```bash
   uv run --with rich python -c \
     "from rich import print; print('[bold green]hi[/]')"
   ```
3. Confirm `rich` did NOT get added to your project:
   ```bash
   grep rich pyproject.toml || echo "not in pyproject — correct"
   ```
4. Self-grade:
   ```bash
   make check
   ```

**Expected:** step 1 prints `Hello, World!` then `Hello, <you>!`. Step 3
confirms `rich` stayed ephemeral.

**Stretch:** `uv run --python 3.11 uv-hero hello` — switch interpreter for
a single invocation; `uv` materialises a parallel `.venv` for 3.11.

---

## §6 — `uvx`   ⏱ ~5 min

```bash
git checkout exec_6
cat README.md
```

**Goal:** run developer tools without polluting the project (or your
system).

**Steps:**

1. One-shot tool execution:
   ```bash
   uvx cowsay -t "hi from uv"
   ```
2. Lint the current project — no project setup needed:
   ```bash
   uvx ruff check .
   ```
3. Typecheck via Astral's type checker `ty`:
   ```bash
   uvx ty check src/
   ```
4. Pin the Python the tool runs under:
   ```bash
   uvx --python 3.11 python -V
   ```
5. When the package name differs from the command name:
   ```bash
   uvx --from httpie http GET httpbin.org/get
   ```
6. Self-grade:
   ```bash
   make check
   ```

**Expected:** every command works without touching `pyproject.toml` and
without leaving artefacts in your dir.

**Stretch:** `time uvx cowsay -t hi` twice — the second run is a cache
hit, sub-100 ms. Or `uv tool install ruff` to make it permanent as just
`ruff`.

---

## After the workshop

```bash
git checkout full_solution
cat README.md
make check                  # runs sync, lint, typecheck, build, CLI
```

The `full_solution` branch is the complete `click` CLI — same theme you
saw on `exec_5` / `exec_6`, plus dev tools wired into the Makefile and a
buildable package layout.

## Further reading

- Official docs: <https://docs.astral.sh/uv/>
- Source: <https://github.com/astral-sh/uv>
- PEP 723 single-file scripts: <https://docs.astral.sh/uv/guides/scripts/>
- Real-world `uv build` example: <https://github.com/mpagot/openqa_log_local>
