function run_segment() {
  cd $(tmux display -p -F "#{pane_current_path}") || exit 0
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    exit 0
  fi

  if [ -n "$(git stash list)" ]; then
    echo -n "$"
  fi

  if [ -n "$(git diff --name-only)" ]; then
    echo -n "!"
  fi

  if [ -n "$(git diff --name-only --staged)" ]; then
    echo -n "+"
  fi

  if [ -n "$(git ls-files --others --exclude-standard)" ]; then
    echo -n "?"
  fi

  if [ -n "$(git rev-list @{u}..HEAD)" ]; then
    echo -n "↑"
  fi

  if [ -n "$(git rev-list HEAD..@{u})" ]; then
    echo -n "↓"
  fi
}
