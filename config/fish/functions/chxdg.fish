if test (count $argv) -lt 1
  chxdg -h
else if test (count $argv) = 1
  if test $argv[1] = -h
    echo "Usage: chxdg <basedir> [cmd]"
  else
    chxdg $argv[1] fish
  end
else if test (count $argv) = 2
  set base $argv[1]
  set -lx XDG_CONFIG_HOME $base/.config
  set -lx XDG_CACHE_HOME $base/.cache
  set -lx XDG_DATA_HOME $base/.local/share
  $argv[2]
else
  chxdg -h
end
