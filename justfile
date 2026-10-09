# List recipes
default:
    @just --list

# Debug build
build:
    cargo build

# Release build
release:
    cargo build --release

# Run tt against your real data (~/.local/share/tt), e.g. `just run list --all`
run *args:
    cargo run -- {{args}}

# Run tt against a scratch database in .tt-dev/, e.g. `just dev add "try it"`
dev *args:
    TT_HOME="{{justfile_directory()}}/.tt-dev" cargo run -- {{args}}

# Wipe the scratch database used by `just dev`
dev-reset:
    rm -rf .tt-dev

# Rust tests and the /claim plugin tests
test: test-rust test-plugin

test-rust:
    cargo test

test-plugin:
    claude plugin test claude-mod

# Format check and clippy
lint:
    cargo fmt --check
    cargo clippy --all-targets

# Format the code (settings in rustfmt.toml)
fmt:
    cargo fmt

# Everything CI-shaped: lint then test
check: lint test

# Install tt into ~/.cargo/bin
install:
    cargo install --path .

# Symlink the /claim plugin into ~/.claude/skills
link-plugin:
    ln -sfn "{{justfile_directory()}}/claude-mod" ~/.claude/skills/tt-claim
