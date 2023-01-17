#!/bin/bash

try=0

while [ ! -S "${PAM_KWALLET5_LOGIN}" ]; do
    [ $try -ge 15 ] && exit
    sleep 1
    try=$(($try+1))
done

ssh-add -q ~/.ssh/id_ed25519 </dev/null
