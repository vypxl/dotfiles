set last_status $status
echo

set_color -o yellow
echo -n (prompt_pwd)

if git rev-parse --is-inside-work-tree &>/dev/null
  set_color -o brmagenta
  echo -n '  '
  echo -n (git rev-parse --abbrev-ref HEAD 2>/dev/null)
  echo -n ' '
  set_color -o red
  git compact-status
end

set_color -o green
if test $last_status -ne 0
  set_color -o red
end

switch $fish_bind_mode
  case default
    echo -n ' ❮ '
  case visual
    echo -n ' V '
  case '*'
    echo -n ' λ '
end

set_color normal
