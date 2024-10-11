run_segment() {
  if [[ -n "$IN_NIX_SHELL" ]]; then
    echo "nix"
  fi

  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo "venv: $VIRTUAL_ENV"
  fi

  if [ -f /.dockerenv ]; then
    echo "docker"
  fi

  if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
    echo $(whoami)@$(hostname)
  fi
}
