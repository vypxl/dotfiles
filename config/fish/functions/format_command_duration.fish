set ms $CMD_DURATION
set s (math "floor($ms / 1000)")
set m (math "floor($s / 60)")

set res ""

if test $m -gt 0
  set res "$m"m
else if test $s -gt 0
  set res "$s"s
else if test $ms -gt 40
  set res "$ms"ms
end

if test -n $res
  echo -n "took $res"
end
