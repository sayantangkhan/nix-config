#!/usr/bin/env zsh

pass -c $(find /Users/sayantan/.password-store -type f -name "*.gpg" |  sed 's#\.gpg$##' | sed 's#^/Users/sayantan/\.password-store/##' | fzf)