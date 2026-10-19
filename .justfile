# List available commands
default:
    @just --list

alias help := default

# Init git-hooks and autoupdate checks lint, fmt, etc.
[group('System')]
init:
    @pre-commit install
    @pre-commit autoupdate

    @git submodule update --init --recursive

# Check all files
[group('System')]
lint:
    @pre-commit install
    @pre-commit run --all-files

# Check tools
[group('System')]
tools:
    pre-commit --version

    docker -v
    docker buildx version
    hadolint -v
