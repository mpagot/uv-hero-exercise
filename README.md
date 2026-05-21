# uv hero — workshop scaffold


A hands-on scaffold for learning **[uv](https://docs.astral.sh/uv/)** —
Astral's Python package & project manager.
Each exercise is an **orphan branch** with its own seed state and a
`make check` that self-grades when you think you're done.

## Branches

- `main` — this landing page + [`EXERCISES.md`](EXERCISES.md)
- `exec_1` … `exec_8` — one orphan branch per exercise, seeded with the
  starting state for that topic
- `full_solution` — the finished reference project

## Quick start

```sh
git checkout exec_1
cat README.md       # per-branch hints (what files you have, what to do)
make check          # self-grade when you think you're done
```

Full walkthrough — setup, per-step commands, expected output, stretch
goals — lives in **[`EXERCISES.md`](EXERCISES.md)**.

## Switching branches

Each branch is independent (orphan), so switching is destructive to
uncommitted work. `make clean` on any branch drops gitignored files
(`.venv/`, `dist/`, caches); use `git restore .` to undo edits to
tracked files.
