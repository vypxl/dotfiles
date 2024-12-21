run_segment() {
  tty=$(tmux display-message -p "#{pane_tty}")
  pid=$(ps -o pid= -t "$tty" | tail -n 1 | xargs echo)
  cmdline=$(cat "/proc/$pid/cmdline" | tr '\0' ' ')
  cmd=$(echo $cmdline | cut -d' ' -f1)

  if echo "cargo docker make just go" | grep -qw "$cmd"; then
    echo $(echo $cmdline | cut -d' ' -f-2)
  elif ! echo "fish bash sh ssh" | grep -qw "$cmd"; then
    echo $cmd
  fi
}
