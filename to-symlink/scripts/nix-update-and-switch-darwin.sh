#!/run/current-system/sw/bin/zsh

nix flake update --flake  /Users/sayantan/Sync/configs/nix-config
sudo nix run nix-darwin -- switch --flake /Users/sayantan/Sync/configs/nix-config
nix-collect-garbage -d
