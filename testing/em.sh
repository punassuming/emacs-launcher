#!/bin/sh

# You may need to change the value of the -name parameter, depending on you Unix
# distribution (this works on Ubuntu 12.10).
xprop -name emacs@`hostname` >/dev/null 2>/dev/null
if [ "$?" = "1" ]; then
    emacsclient -c -n -a "" "$@" 2>/tmp/emacs-startup <<EOF
y
EOF
else
    emacsclient -n -a "" "$@" 2>/tmp/emacs-startup <<EOF
y
EOF
fi
