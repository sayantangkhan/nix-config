#!/run/current-system/sw/bin/zsh

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
echo "Updating Lean toolchain"
