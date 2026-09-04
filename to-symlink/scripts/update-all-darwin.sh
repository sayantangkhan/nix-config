#!/run/current-system/sw/bin/zsh

# Homebrew update
# Must run before the nix-darwin switch. The homebrew activation invokes
# "brew bundle --force-cleanup", a flag only newer brew versions understand,
# so letting brew go stale makes the switch itself fail.
echo "Updating Homebrew"
brew update
brew upgrade

# Nix update
echo "Updating nix"

nix flake update --flake  /Users/sayantan/Sync/configs/nix-config
sudo nix run nix-darwin -- switch --flake /Users/sayantan/Sync/configs/nix-config
nix-collect-garbage -d


# Rust toolchain update
echo "Updating Rust toolchain"
rustup self update
rustup update

# Lean toolchain update
# elan is Lean's toolchain manager, the rustup equivalent. Guarded because it is
# installed per-machine outside nix, and is absent on some of them.
echo "Updating Lean toolchain"
if command -v elan >/dev/null 2>&1; then
	elan self update
#	elan update
else
	echo "elan not installed, skipping"
fi
