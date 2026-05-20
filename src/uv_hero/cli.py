"""Hello-world CLI to anchor the uv workshop."""
import os

import click


@click.group()
def main():
    """uv-hero workshop CLI."""


@main.command()
@click.option("--name", default="World", help="Who to greet.")
def hello(name) -> None:
    """Greet someone."""
    click.echo(f"Hello, {name}!")
    return 0
