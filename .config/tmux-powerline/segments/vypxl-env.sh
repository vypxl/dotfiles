run_segment() {
  tty=$(tmux display-message -p "#{pane_tty}")
  pid=$(ps -o pid= -t "$tty" | tail -n 1 | xargs echo)
  cmdline=$(cat "/proc/$pid/cmdline" | tr '\0' ' ')
  cmd=$(echo $cmdline | cut -d' ' -f1)

  if [[ -n "$IN_NIX_SHELL" ]]; then
    echo "nix"
  fi

  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo "venv: $VIRTUAL_ENV"
  fi

  if echo $cmd | grep -qwe "^docker"; then
    echo "docker"
  fi

  if echo $cmd | grep -qwe "^ssh"; then
    ssh_info=$(echo $cmdline | awk '{print $NF}')
    echo "> $ssh_info"
  fi
}
