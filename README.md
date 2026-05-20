# Branch: `full_solution`

The completed `click`-based "hello world" CLI — the state you'd reach
after working through `exec_1` through `exec_6`.

## What you have

```
.
├── .python-version           # 3.13
├── pyproject.toml            # click runtime + ruff/ty dev
├── src/uv_hero/
│   ├── __init__.py
│   └── cli.py                # `uv-hero hello --name=…`
├── uv.lock                   # committed
└── Makefile                  # help / sync / run / lint / typecheck / build / clean / check
```

## Try it

```bash
make help         # list all targets
make check        # runs sync, the CLI, ruff, ty, and uv build end-to-end
make run          # just run the CLI
make build        # produce wheel + sdist in ./dist
```

To inspect a different exercise's starting state, `git checkout exec_N`.
The workshop hand-out is on the `main` branch (`git checkout main && cat
EXERCISES.md`).
