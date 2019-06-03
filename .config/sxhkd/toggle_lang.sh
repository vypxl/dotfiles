#! /bin/sh
L1=us
L2=de
CUR=$(setxkbmap -query | grep layout | cut -f6 -d' ')
if [ "$L1" = "$CUR" ]; then
    setxkbmap $L2
else
    setxkbmap $L1
fi
