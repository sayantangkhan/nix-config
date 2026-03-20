#!/run/current-system/sw/bin/zsh

# Updates openSUSE Tumbleweed packages
echo "Updating Tumbleweed packages"
sudo zypper dup
echo "Done updating Tumbleweed packages"
sleep 2

# Nix update
echo "Updating nix"
nix flake update --flake /home/sayantan/Sync/configs/nix-config
home-manager switch --flake /home/sayantan/Sync/configs/nix-config
nix-collect-garbage -d

echo "Getting list of firmware updates"
fwupdmgr get-updates
