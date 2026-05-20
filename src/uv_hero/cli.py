"""Hello-world CLI to anchor the uv workshop."""

import click


@click.group()
def main() -> None:
    """uv-hero workshop CLI."""


@main.command()
@click.option("--name", default="World", help="Who to greet.")
def hello(name: str) -> None:
    """Greet someone."""
    click.echo(f"Hello, {name}!")
