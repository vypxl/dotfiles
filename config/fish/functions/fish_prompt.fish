set last_status $status
echo

set_color -o yellow
echo -n thomas

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
