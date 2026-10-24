# DotFiles

A repository of my shell configuration for easy reuse across development environments.

## .bashrc

### Prompt

Two-line prompt built via `PROMPT_COMMAND`:

- Line 1: colored segments — username (blue), current directory (grey), git branch (green, only inside a repo), exit code (red, only on failure)
- Line 2: `❯` — white normally, red on error

### Aliases

| Alias       | Command                |
| ----------- | ---------------------- |
| `ls`        | `ls -la`               |
| `cat`       | `batcat`               |
| `vi`, `vim` | `nvim`                 |
| `gs`        | `git status`           |
| `gc`        | `git commit . -m`      |
| `gp`        | `git pull`             |
| `gpsh`      | `git push`             |
| `gd`        | `git diff`             |
| `tr1`–`tr4` | `tree -L 1..4`         |
| `cb`        | `xclip -sel clipboard` |
| `clr`       | `clear`                |

### Functions

- `far <find> <replace> <dir>` — find and replace across files using `rg` and `sed`
- `spinner <cmd>` — runs a command in the background with a terminal spinner
- `printfln_clr <style> <color> <text>` — prints colored text via ANSI codes
- `preview_clrs` — previews ANSI color combinations 0–100
- `wbe <name> <entry>` — appends a timestamped entry to a named workbook file in `~/workbook/`

### Other

- Filters `/mnt` paths from `$PATH` to prevent Windows PATH pollution
- Colored man pages via `LESS_TERMCAP_*` (salmon pink scheme)
- Cursor set to blinking block on shell start
