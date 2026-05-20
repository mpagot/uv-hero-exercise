# exec_8 — `uv build` + `uv pip install -e .`

Build the `uv-hero` CLI as a distributable package (sdist + wheel), then
install it editable into the project venv and run the entry-point.

## What you have

- `pyproject.toml` — `click>=8.1`, `[project.scripts] uv-hero = "uv_hero.cli:hello"`, `[build-system]` using `uv_build>=0.5`
- `src/uv_hero/cli.py` — minimal click CLI (writes a `.hello_<name>` sentinel)
- `Makefile` — `build`, `install`, `check`

No `uv.lock` is committed — `uv build` will resolve it.

## What to do

```sh
uv build                       # produces dist/uv_hero-0.1.0.tar.gz + .whl
ls dist/
uv venv                        # create .venv (uv pip install -e . needs it to exist)
uv pip install -e .            # editable install of THIS source into .venv
.venv/bin/uv-hero --name workshop   # run the installed script
cat .hello_workshop            # sentinel proves the installed binary ran
make check
```

## Expect a warning from `uv build`

```
warning: `build_system.requires = ["uv_build>=0.5"]` is missing an upper bound on the `uv_build` version such as `<0.12`. Without bounding the `uv_build` version, the source distribution will fail to build if a future, incompatible version is released.
```

`uv_build` is pre-1.0 and the API can break between minor versions. uv asks
you to pin an upper bound so a future release won't silently break your
sdist. The fix is one character in `pyproject.toml`:

```toml
[build-system]
requires = ["uv_build>=0.5,<0.12"]
```

(`make check` does NOT enforce the upper bound — that's a stretch fix; the
warning is the teaching moment.)

## Editable vs regular install

`uv pip install -e .` symlinks your source into the venv's site-packages
instead of copying it. Edit `src/uv_hero/cli.py`, run `uv-hero` again, see
the change immediately — no reinstall needed. The non-editable form
(`uv pip install .`) copies, so changes require a reinstall.

## When you're done

`make check` passes when:
- `dist/uv_hero-0.1.0.tar.gz` exists (sdist)
- `dist/uv_hero-0.1.0-py3-none-any.whl` exists (wheel)
- `uv pip install -e .` succeeds
- `.venv/bin/uv-hero --name workshop` prints `Hello, workshop!`
- `.hello_workshop` sentinel file is on disk

## Reset

```sh
make clean     # drops .venv, dist/, caches, sentinel files
```
