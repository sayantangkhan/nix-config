#!/run/current-system/sw/bin/zsh

nix flake update --flake  /home/sayantan/Sync/configs/nix-config
home-manager switch --flake /home/sayantan/Sync/configs/nix-config
nix-collect-garbage -d
