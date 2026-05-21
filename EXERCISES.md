# uv hero — Exercises

Hands-on companion to the [uv hero](https://docs.astral.sh/uv/) workshop.
Each exercise lives on its own branch of this repo.
The workshop runs "continuous interleave": after each topic explanation you get ~5 min to
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
| `exec_4` | `uv add` — edit dependencies through uv | ~5 min |
| `exec_5` | `uv run` — execute scripts without activating the venv | ~5 min |
| `exec_6` | `uvx` — lint & typecheck without declaring the tools | ~5 min |
| `exec_7` | `uv add --dev` — declare tools as project deps (vs §6) | ~5 min |
| `exec_8` | `uv build` + `uv pip install -e .` — package the CLI | ~5 min |
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
   cat demo/main.py
   ```
2. Run the generated script (creates `.venv` on first call):
   ```bash
   (cd demo && uv run main.py)
   ```
3. Force a specific Python with `-p` (otherwise uv uses your default):
   ```bash
   uv init -p 3.11 demo-pinned
   diff demo/pyproject.toml demo-pinned/pyproject.toml
   ```
4. Self-grade:
   ```bash
   make check
   ```

**Expected:** `demo-pinned/pyproject.toml` has `requires-python = ">=3.11"`;
`demo/` uses whatever your default is. `make check` prints three ✔ lines
(pyproject + .python-version + main.py) plus the greeting that
`uv run main.py` produced.

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

**Goal:** execute a script with its dependencies without ever activating
a virtualenv — and prove to yourself you did it. The check refuses to
pass unless YOU actually invoked the script (sentinel files prove it).

**Steps:**

1. Inspect what the branch ships: a top-level `hello.py` (not a package)
   plus a `pyproject.toml` with **no runtime deps**. `hello.py` imports
   `click`, so `uv sync` alone doesn't help.
   ```bash
   cat hello.py
   grep dependencies pyproject.toml
   ```
2. Add the dep, then run via `uv run` — twice, with different names:
   ```bash
   uv add click
   uv run hello.py
   uv run hello.py --name=workshop
   ```
3. Note the sentinel files `hello.py` dropped on each call:
   ```bash
   ls .hello_*           # .hello_world  .hello_workshop
   ```
4. Bonus — ephemeral dep with `--with` that does NOT leak into
   `pyproject.toml`:
   ```bash
   uv run --with rich python3 -c \
     "from rich import print; print('[bold green]hi[/]')"
   grep rich pyproject.toml || echo "not in pyproject — correct"
   ```
5. Self-grade:
   ```bash
   make check
   ```

**Expected:** `Hello, World!` then `Hello, workshop!`; both
`.hello_world` and `.hello_workshop` sentinels on disk; `rich` did NOT
land in `pyproject.toml`.

**Stretch:** `uv run --python 3.11 hello.py` — switch interpreter for a
single invocation; `uv` materialises a parallel `.venv` for 3.11.

---

## §6 — `uvx`   ⏱ ~5 min

```bash
git checkout exec_6
cat README.md
```

**Goal:** lint + typecheck a real source file using tools that are NOT
declared in your project. `uvx` fetches them on demand into a throwaway
env and leaves `pyproject.toml` untouched.

The branch ships the click CLI from §5 with **two deliberate bugs** in
`src/uv_hero/cli.py` — one that `ruff` will flag, one that `ty` will
flag.

**Steps:**

1. Sanity-check the CLI still runs:
   ```bash
   uv run uv-hero hello
   ```
2. Run the tools via `uvx` and read the diagnostics:
   ```bash
   uvx ruff check src/uv_hero/cli.py            # one F401
   uvx ty check --error all src/uv_hero/cli.py  # one invalid-return-type
   ```
3. Edit `src/uv_hero/cli.py` until both report `All checks passed!`.
   Re-run the two commands after each edit.
4. Confirm nothing leaked into your project deps:
   ```bash
   grep -E '"(ruff|ty)' pyproject.toml && echo "leaked!" || echo "clean"
   ```
5. Self-grade:
   ```bash
   make check
   ```

**Expected:** both `uvx` commands print `All checks passed!` once
`cli.py` is fixed; `pyproject.toml` is unchanged from the seed.

**Stretch:** `time uvx ruff --version` twice — the second run is a cache
hit, sub-100 ms. Or `uv tool install ruff` to make it permanent as
just `ruff`.

---

## §7 — `uv add --dev`   ⏱ ~5 min

```bash
git checkout exec_7
cat README.md
```

**Goal:** same broken CLI as §6, but this time declare `ruff` + `ty` as
**project-tracked dev deps** so every contributor and your CI get the
exact same versions, locked in `uv.lock`.

**Steps:**

1. Add ruff + ty to the dev group:
   ```bash
   uv add --dev ruff ty
   ```
2. Confirm they landed in `[dependency-groups]` (NOT in
   `[project.dependencies]` — that would mean you forgot `--dev`):
   ```bash
   grep -A5 'dependency-groups' pyproject.toml
   ```
3. Now drive the tools via `uv run` (they come from `.venv/` this time,
   not from a `uvx` throwaway env):
   ```bash
   uv run ruff check src/uv_hero/cli.py
   uv run ty check --error all src/uv_hero/cli.py
   ```
4. Fix `src/uv_hero/cli.py` until both pass.
5. Self-grade:
   ```bash
   make check
   ```

**Expected:** `[dependency-groups]` exists with `ruff` and `ty`;
`uv.lock` updated atomically; both checks clean.

**Gotcha — `make diagnose`:** if `.venv/bin/ruff` is missing but
`/usr/bin/ruff` is on `PATH` (openSUSE ships `python311-ruff`), `uv run
ruff` will silently use the system copy and lint passes for the wrong
reason. `make diagnose` catches this and names the offending package
(`rpm -qf`). Run it standalone any time you're unsure which `ruff` is
firing.

**`uvx` (§6) vs `uv add --dev` (§7):** `uvx` is right for ad-hoc tools
you don't want tracked. `uv add --dev` is right for tools your team and
CI depend on — locked into `uv.lock`, reproducible everywhere.

**Stretch:** run `uv add ruff` (no `--dev`) by mistake, then `make
check`. The check tells you exactly how to recover
(`uv remove ruff && uv add --dev ruff`). Same exercise also catches the
double-add case (ruff in both `[project.dependencies]` AND
`[dependency-groups].dev`).

---

## §8 — `uv build` + `uv pip install -e .`   ⏱ ~5 min

```bash
git checkout exec_8
cat README.md
```

**Goal:** turn the click CLI into a real distributable package (sdist +
wheel) with `uv build`, then install it editable into a venv and run
the entry-point.

**Steps:**

1. Build the package — pay attention to the warning uv prints:
   ```bash
   uv build
   ls dist/
   ```
   You'll see:
   > warning: `build_system.requires = ["uv_build>=0.5"]` is missing an
   > upper bound on the `uv_build` version such as `<0.12`.

   `uv_build` is pre-1.0 and can break between minor versions. Fix:
   ```toml
   [build-system]
   requires = ["uv_build>=0.5,<0.12"]
   ```
2. Create a venv and install editable:
   ```bash
   uv venv
   uv pip install -e .
   ```
3. Run the installed console script:
   ```bash
   .venv/bin/uv-hero --name workshop
   cat .hello_workshop
   ```
4. Self-grade:
   ```bash
   make check
   ```

**Expected:** `dist/uv_hero-0.1.0.tar.gz` and
`dist/uv_hero-0.1.0-py3-none-any.whl` both present;
`.venv/bin/uv-hero --name workshop` prints `Hello, workshop!`; the
sentinel file proves the installed binary ran (not the source script).

**Editable vs regular install:** `uv pip install -e .` symlinks your
source into the venv's `site-packages` — edit `cli.py`, re-run
`uv-hero`, see the change immediately. `uv pip install .` would copy
and require a reinstall after every edit.

**Stretch:** install from the wheel into a throwaway venv to prove the
artifact works on its own:
```bash
uv venv /tmp/uv-hero-test
/tmp/uv-hero-test/bin/python -m pip install dist/uv_hero-0.1.0-py3-none-any.whl
/tmp/uv-hero-test/bin/uv-hero --name "from-wheel"
```

---

## After the workshop

```bash
git checkout full_solution
cat README.md
make check                  # runs sync, lint, typecheck, build, CLI
```

The `full_solution` branch is the complete `click` CLI — same theme you
saw on `exec_5`..`exec_8`, plus dev tools wired into the Makefile and a
buildable package layout.

## Further reading

- Official docs: <https://docs.astral.sh/uv/>
- Source: <https://github.com/astral-sh/uv>
- PEP 723 single-file scripts: <https://docs.astral.sh/uv/guides/scripts/>
- Real-world `uv build` example: <https://github.com/mpagot/openqa_log_local>
