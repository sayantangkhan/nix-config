{
  description = "Configuration for my macOS machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  # Overlay notes
  # https://fasterthanli.me/series/building-a-rust-service-with-nix has an example of how to do overlays with flakes

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }: {
    darwinConfigurations."Sayantans-Mac-mini" = nix-darwin.lib.darwinSystem {
      modules = [
        ./darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.sayantan = import ./home-darwin.nix;
        }
      ];
    };
    darwinConfigurations."Sayantans-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        ./darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.sayantan = import ./home-darwin.nix;
        }
      ];
    };
    # Home config for my linux systems
    homeConfigurations = let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      "sayantan@t420s-server" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home-linux-t420s.nix ./emacs.nix ];
      };
      "sayantan@xps13" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home-linux-xps13.nix ./emacs.nix ];
      };
    };
  };
}
