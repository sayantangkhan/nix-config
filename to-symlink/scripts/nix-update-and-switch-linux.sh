#!/run/current-system/sw/bin/zsh

nix flake update --flake  /home/sayantan/Sync/configs/nix-config
nix run nix-darwin -- switch --flake /home/sayantan/Sync/configs/nix-config
nix-collect-garbage -d
