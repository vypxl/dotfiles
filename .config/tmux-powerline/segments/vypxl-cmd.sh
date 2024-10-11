run_segment() {
  tty=$(tmux display-message -p "#{pane_tty}")
  pid=$(ps -o pid= -t "$tty" | tail -n 1)
  cmdline=$(cat /proc/$pid/cmdline | tr '\0' ' ')
  cmd=$(echo $cmdline | cut -d' ' -f1)

  echo -n $cmd
  if echo "cargo docker make just go ssh" | grep -qw "$cmd"; then
    echo $(echo $cmdline | cut -d' ' -f-2)
  elif ! echo "fish bash sh" | grep -qw "$cmd"; then
    echo $cmd
  fi
}
