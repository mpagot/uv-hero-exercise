# Branch: `exec_1` — interpreter management

**Goal:** ask `uv` to install a Python 3.13 interpreter (managed by uv, not
your distro).

## What you have on this branch

Nothing but this README and a `Makefile`. There is no project here yet —
this exercise is purely about uv's interpreter management.

## When you think you're done

```bash
make check
```

`make check` passes when `uv python find 3.13` succeeds, meaning uv knows
about a CPython 3.13 it can use. Full instructions live in
`../EXERCISES.md §1`.
