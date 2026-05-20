# Branch: `exec_1` — interpreter management

**Goal:** make `uv` install a Python 3.13 for you (not your distro's
Python), then **manually** pin it for this project with a
`.python-version` file.

## What you have on this branch

Just this README and a `Makefile`. No `pyproject.toml`, no
`.python-version` — you'll create the version file yourself with `echo`.

## Useful `uv python` subcommands to explore

| Command | What it does |
|---------|--------------|
| `uv python list` | every version uv knows about (installed or available) |
| `uv python install 3.13` | download CPython 3.13 to uv's interpreter dir |
| `uv python dir` | print where uv keeps managed interpreters |
| `uv python upgrade` | bump installed CPython to the latest patch |
| `uv python find 3.13` | resolve which 3.13 uv would use; exit 0 if any |
| `uv python pin` | print (or set) the version pinned for this dir |

## When you think you're done

```bash
make check
```

`make check` verifies, in order:

1. `uv` is on your `PATH`
2. `.python-version` exists in this directory (you created it)
3. The version it names is actually installed (`uv python find $PIN`)
4. `uv` honours the pin (`uv python pin` returns it)

Full instructions live in `../EXERCISES.md §1`.
