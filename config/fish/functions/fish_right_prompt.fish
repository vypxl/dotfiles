set dur (format_command_duration)
if test -n $dur
  set_color -o cyan
  echo "$dur "
end

set_color -o yellow
date +"[ %H:%M:%S ]"
set_color normal
