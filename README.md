# DotFiles

Fully automated development environment setup for WSL on Windows. One PowerShell command installs WSL, clones this repo, and configures a complete dev environment with zero manual intervention (except SSH key restoration).

## Quick Start

### New Machine Setup

1. **Restore SSH keys** (if needed):
   - Place your SSH backup at `C:\Users\<username>\ssh_backup\`
   - Files: `id_ed25519`, `id_ed25519.pub`, `known_hosts`

2. **Run bootstrap**:
   ```powershell
   PowerShell -ExecutionPolicy Bypass -File C:\Users\<username>\bootstrap.ps1
   ```

3. **Complete WSL setup** when prompted (username/password)

4. **Done!** Your environment is ready with Neovim, .NET, Node.js, and all tools configured.

### Clean Slate

To remove all WSL distributions and start fresh:
```powershell
PowerShell -ExecutionPolicy Bypass -File C:\Users\<username>\unregister_all_wsl.ps1
```

## What Gets Installed

### Shell Configuration (`.bashrc`)

**Prompt:**
- Two-line colored prompt with username, directory, git branch, and exit code
- Color escapes properly wrapped for correct cursor positioning

**Aliases:**

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

**Functions:**
- `far <find> <replace> <dir>` — find and replace across files using `rg` and `sed`
- `spinner <cmd>` — runs command with a terminal spinner
- `printfln_clr <style> <color> <text>` — prints colored text via ANSI codes
- `preview_clrs` — previews 256 ANSI colors in a grid
- `wbe <name> <entry>` — timestamped workbook entries in `~/workbook/`

**Other:**
- Filters `/mnt` paths from `$PATH` to prevent Windows PATH pollution
- Colored man pages (salmon pink scheme)
- Blinking block cursor

### Neovim (LazyVim-based)

**Installed language support:**
- **C# / F#**: Roslyn LSP, fsautocomplete, requires .NET SDK (auto-installed)
- **TypeScript/JavaScript**: vtsls LSP
- **Markdown**: marksman LSP, markdownlint-cli2, render-markdown.nvim

**Themes:**
- synthwave84 (default)
- cyberdream
- tokyonight

**Features:**
- Treesitter syntax highlighting
- Redundant whitespace highlighting (cursor line only, light brown)
- Transparent background support
- WezTerm integration

### Development Tools

Installed via `setup.sh`:
- **Editors**: Neovim
- **Languages**: .NET SDK (latest), Node.js, npm
- **CLI Tools**: bat, ripgrep, xclip, tree, git, prettier
- **Build Tools**: gcc (build-essential)
- **Testing**: bats (Bash Automated Testing System)

## Repository Structure

```
DotFiles/
├── bootstrap.ps1          # Windows bootstrap script
├── unregister_all_wsl.ps1 # WSL cleanup script  
├── setup.sh               # Linux dependency installer
├── .bashrc                # Shell configuration
├── nvim/                  # Neovim config (LazyVim)
├── .wezterm.lua           # WezTerm terminal config
├── setup.bats             # Setup script tests
├── wbe.bats               # Workbook function tests
└── .gitignore             # Allowlist pattern
```

## Scripts

### `bootstrap.ps1` (Windows)
1. Finds latest Ubuntu LTS via `wsl --list --online`
2. Installs WSL with `wsl --install -d <distro>`
3. Waits for user to complete WSL setup
4. Installs git and clones this repo
5. Copies scripts into WSL
6. Runs `setup.sh`

### `unregister_all_wsl.ps1` (Windows)
- Lists all WSL distributions
- Prompts for confirmation
- Unregisters all distributions (destructive!)
- Verifies cleanup

### `setup.sh` (WSL)
- Updates apt repositories
- Resolves and installs latest .NET SDK dynamically
- Installs all development dependencies
- Creates symlinks for `.bashrc` and `nvim/`
- Runs test suite (8 tests)

## Notes

- **SSH keys**: Manual restoration required from backup
- **Git identity**: Set during bootstrap (Beau Smyth / beau.smyth@outlook.com)
- **First nvim launch**: Treesitter parsers compile asynchronously (~30s), may show transient warnings if opening files immediately
- **Remote**: SSH auth recommended (`git@github.com:beausmyth1990/DotFiles.git`)
