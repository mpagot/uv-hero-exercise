"""Hello-world CLI — copied from exec_5's hello.py and packaged as `uv-hero`."""
from pathlib import Path

import click


@click.command()
@click.option("--name", default="World", help="Who to greet.")
def hello(name: str) -> None:
    """Greet someone (and drop a sentinel file so `make check` can tell you ran it)."""
    msg = f"Hello, {name}!"
    click.echo(msg)
    Path(f".hello_{name.lower()}").write_text(msg + "\n")
