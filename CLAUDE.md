# tt

Todo tree TUI + CLI linked to Claude Code sessions. Rust binary in `src/`, plus a Claude Code plugin (`/claim`) in `claude-mod/`. User-facing docs are in README.md.

## Build and run

Use the justfile (`just` lists recipes):

- `just build` / `just release`
- `just dev [args]`: run against a scratch database in `.tt-dev/` (sets `TT_HOME`). Use this when trying changes; `just dev-reset` wipes it.
- `just run [args]`: run against the real database in `~/.local/share/tt`. Don't use this to test changes; it touches the user's actual todos.
- `just test`: `cargo test` plus `claude plugin test claude-mod`
- `just fmt`: format the code
- `just lint`: format check plus clippy
- `just install`: `cargo install --path .`
- `just link-plugin`: symlink `claude-mod/` to `~/.claude/skills/tt-claim`

The TUI (`tt` with no args) needs a real terminal, so check behavior through CLI subcommands (`just dev list --json`, `just dev add ...`) and unit tests. Don't run the TUI from a tool call.

## Layout

- `src/main.rs`: clap CLI; no subcommand launches the TUI
- `src/domain.rs`: `Todo`, `Tree`, row flattening
- `src/store.rs`: SQLite store (`TT_HOME` or `~/.local/share/tt/tt.db`); `Store::in_memory()` for tests
- `src/sessions.rs`: read-only view of `~/.claude` sessions; starts and resumes `claude`, tmux windows
- `src/suggest.rs`: after a reflection, runs `claude -p` to suggest which todos look done
- `src/tui.rs`: ratatui app
- `claude-mod/hooks/`: `/claim` picker (TSX); tests in `claude-mod/tests/`

## Conventions

- Run `just fmt` after editing Rust. `rustfmt.toml` sets wide lines (140) with `use_small_heuristics = "Max"`.
- Toolchain is pinned in `rust-toolchain.toml`.
- When you change TUI keys or CLI commands, update the tables in README.md.
