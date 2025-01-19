#!/bin/env bash

# Install all nix top level graphical apps
if [[ -d ~/.local/state/nix/profiles/home-manager/home-path/Applications ]]; then
	(cd ~/.local/state/nix/profiles/home-manager/home-path/Applications;
	for f in *.app ; do
		mkdir -p ~/Applications/
		rm -f "$HOME/Applications/$f"
		# Mac aliases don’t work on symlinks
		f="$(readlink -f "$f")"
		# Use Mac aliases because Spotlight doesn’t like symlinks
		osascript -e "tell app \"Finder\" to make new alias file at POSIX file \"$HOME/Applications\" to POSIX file \"$f\"" ; done
	)
fi
