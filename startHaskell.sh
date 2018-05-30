#! /usr/bin/env bash
cd Desktop/Haskell/
firefox -browser &
# sleep 2
xterm ghci &
# sleep 1
xterm nvim &
exit
