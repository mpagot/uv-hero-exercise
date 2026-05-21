# Branch: `exec_3` — `uv sync`

**Goal:** turn a `pyproject.toml` into a reproducible `.venv/` + `uv.lock`.

## What you have on this branch

- `pyproject.toml` declaring a single dependency (`click`)
- `.python-version` pinning to 3.13

No virtualenv, no lockfile yet — that's what you'll create.

## When you think you're done

```bash
make check
```

`make check` passes when both `.venv/` and `uv.lock` exist.

## Notes

**What is the difference between `uv lock` and `uv sync`?**
uv lock updates the uv.lock file by resolving dependencies from pyproject.toml
and pinning specific versions, while uv sync installs or updates the actual packages
in the virtual environment to match the versions recorded in uv.lock. 

* Scope of Action:
`uv lock`: Only modifies the uv.lock file. It does not install, uninstall, or change any packages in the virtual environment. It is used to update the dependency graph, especially with flags like --upgrade to fetch newer compatible versions.
`uv sync`: Modifies the virtual environment (.venv). It installs missing packages, updates outdated ones, and removes undeclared packages to ensure the environment exactly matches the uv.lock file. 

* Automatic Behavior:
`uv lock`: Runs explicitly when you type the command or implicitly when you use uv add or uv sync (if the lockfile is missing or outdated).
`uv sync`: Often runs automatically under the hood for commands like uv run or uv add to ensure the environment is ready before executing code. 

* Strictness Flags:
`uv sync --locked`: Installs strictly from the existing uv.lock and errors if the lockfile
                    is out of date with pyproject.toml.
                    This is critical for CI/CD pipelines to prevent silent dependency updates.
`uv sync --frozen`: Uses the lockfile without checking if it is up to date,
                    skipping the resolution step entirely for speed. 

* When to Use Which
To refresh dependencies: Run uv lock --upgrade to update uv.lock to the latest compatible versions, then uv sync to install them. 
To ensure environment consistency: Run uv sync (or uv run) to apply the current lockfile to your machine.
