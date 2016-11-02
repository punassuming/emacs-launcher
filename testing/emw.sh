#!/bin/sh

# This is the waiting version of the scripts (waits for the server to return
# before releasing the command line), hence the "w" in "emw". The difference
# with the "em" script is the absence of the -n flag.

# You may need to change the value of the -name parameter, depending on you unix
# distribution (this works on ubuntu 12.10).
xprop -name emacs@`hostname` >/dev/null 2>/dev/null
if [ "$?" = "1" ]; then
    emacsclient -c -a "" "$@" 2>/tmp/emacs-startup <<EOF
y
EOF
else
    emacsclient -a "" "$@" 2>/tmp/emacs-startup <<EOF
y
EOF
fi
