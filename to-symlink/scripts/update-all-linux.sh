#!/run/current-system/sw/bin/zsh

# Back up home directory
echo "Backing up before updating"
sudo --preserve-env=PATH env btrbk -c /home/sayantan/.config/btrbk/btrbk.conf -v run
echo "Finished backup"
sleep 2

# Updates Fedora packages
echo "Updating Fedora packages"
sudo dnf check-update
sudo dnf update
echo "Done updating Fedora packages"
sleep 2

# Nix update
echo "Updating nix"

nix flake update --flake  /home/sayantan/Sync/configs/nix-config
home-manager switch --flake /home/sayantan/Sync/configs/nix-config
nix-collect-garbage -d

# Rust toolchain update
echo "Updating Rust toolchain"
rustup self update
rustup update

# Lean toolchain update
echo "Updating Lean toolchain"

echo "Getting list of firmware update"
fwupdmgr get-updates
