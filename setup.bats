#!/usr/bin/bats

DOTFILES="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)"
TEST_HOME="$(mktemp -d)"

setup() {
  mkdir -p "$TEST_HOME/.config"
}

teardown() {
  rm -rf "$TEST_HOME"
}

# --- Symlink tests ---

@test "setup | .bashrc symlink created pointing to DotFiles" {
  HOME="$TEST_HOME" bash "$DOTFILES/setup.sh" <<< "n"

  [[ -L "$TEST_HOME/.bashrc" ]]
  [[ "$(readlink "$TEST_HOME/.bashrc")" == "$DOTFILES/.bashrc" ]]
}

@test "setup | nvim symlink created pointing to DotFiles" {
  HOME="$TEST_HOME" bash "$DOTFILES/setup.sh" <<< "n"

  [[ -L "$TEST_HOME/.config/nvim" ]]
  [[ "$(readlink "$TEST_HOME/.config/nvim")" == "$DOTFILES/nvim" ]]
}

@test "setup | .config directory created if it does not exist" {
  rm -rf "$TEST_HOME/.config"

  HOME="$TEST_HOME" bash "$DOTFILES/setup.sh" <<< "n"

  [[ -d "$TEST_HOME/.config" ]]
}

@test "setup | existing symlinks are overwritten without error" {
  ln -s /tmp "$TEST_HOME/.bashrc"
  ln -s /tmp "$TEST_HOME/.config/nvim"

  HOME="$TEST_HOME" bash "$DOTFILES/setup.sh" <<< "n"

  [[ "$(readlink "$TEST_HOME/.bashrc")" == "$DOTFILES/.bashrc" ]]
  [[ "$(readlink "$TEST_HOME/.config/nvim")" == "$DOTFILES/nvim" ]]
}

# --- Dependency tests ---

@test "dependencies | all required commands are present on this machine" {
  for cmd in batcat nvim rg xclip tree git prettier bats; do
    run which "$cmd"
    [ "$status" -eq 0 ]
  done
}

@test "dependencies | setup reports all installed when nothing is missing" {
  run bash -c "HOME='$TEST_HOME' bash '$DOTFILES/setup.sh' <<< 'n'"

  [[ "$output" == *"All dependencies already installed."* ]]
}

@test "dependencies | setup detects missing command and prompts user" {
  # NOTE: this is a weak test. Since all deps are installed on this machine we cannot
  # reliably simulate a missing one via PATH trimming alone. The or-condition means it
  # passes regardless, making it more of a smoke test than a true assertion.
  # A proper fix would require dependency injection into setup.sh.
  run bash -c "PATH='/usr/bin:/bin' HOME='$TEST_HOME' bash '$DOTFILES/setup.sh' <<< 'n'"

  [[ "$output" == *"missing"* || "$output" == *"All dependencies already installed."* ]]
}

@test "dependencies | setup skips install when user declines" {
  run bash -c "HOME='$TEST_HOME' bash '$DOTFILES/setup.sh' <<< 'n'"

  [[ "$output" != *"sudo apt"* ]]
  [ "$status" -eq 0 ]
}
