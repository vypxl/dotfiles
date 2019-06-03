#! /bin/bash
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar -q --reload example &
  done
else
  polybar -q --reload example &
fi
