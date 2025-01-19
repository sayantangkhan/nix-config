{ config, pkgs, ... }:

with pkgs;
let
  myEmacs = emacs.pkgs.withPackages (epkgs:
    (with epkgs; [
      monokai-theme
      twilight-bright-theme
      bind-key
      undo-tree
      async
      separedit
      flycheck
      nix-mode
      magit
      use-package
      dashboard
      yasnippet
      evil
      evil-nerd-commenter
      evil-leader
      helm
      markdown-mode
      auctex
      auctex-latexmk
      smartparens
      all-the-icons
      haskell-mode
      reformatter
      haskell-snippets
      ormolu
    ]));
in {

  services = {

    emacs = {
      enable = true;
      package = myEmacs;
    };
  };

  programs = {
    emacs = {
      enable = true;
      package = myEmacs;
    };
  };

}
