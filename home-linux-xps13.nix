{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  home.username = "sayantan";
  home.homeDirectory = "/home/sayantan";

  programs.home-manager.enable = true;

  home.stateVersion = "24.11";

  # Do not display news
  news.display = "silent";

  targets.genericLinux.enable = true;

  # nixpkgs.config.allowUnfree = true;

  services = {
    # Syncthing
    syncthing.enable = true;
  };

  home.file = {

    # Single file configs

    "btrbk-config" = {
      source = ./to-symlink/linux-dotfiles/btrbk-xps13.conf;
      target = "/home/sayantan/.config/btrbk/btrbk.conf";
    };

    "btrbk-config-remote" = {
      source = ./to-symlink/linux-dotfiles/btrbk-xps13-remote.conf;
      target = "/home/sayantan/.config/btrbk/btrbk-remote.conf";
    };

    "latexmkrc" = {
      source = ./to-symlink/linux-dotfiles/latexmkrc;
      target = "/home/sayantan/.latexmkrc";
    };

    "bash_aliases" = {
      source = ./to-symlink/linux-dotfiles/bash_aliases;
      target = "/home/sayantan/.bash_aliases";
    };

    "alacritty-config" = {
      source = ./to-symlink/linux-dotfiles/alacritty.toml;
      target = "/home/sayantan/.config/alacritty/alacritty.toml";
    };

    "zprezto" = {
      recursive = true;
      source = ./to-symlink/linux-dotfiles/zprezto;
      target = "/home/sayantan/.zprezto";
    };

    "zlogin" = {
      source = ./to-symlink/linux-dotfiles/zprezto/runcoms/zlogin;
      target = "/home/sayantan/.zlogin";
    };

    "zlogout" = {
      source = ./to-symlink/linux-dotfiles/zprezto/runcoms/zlogout;
      target = "/home/sayantan/.zlogout";
    };

    "zpreztorc" = {
      source = ./to-symlink/linux-dotfiles/zprezto/runcoms/zpreztorc;
      target = "/home/sayantan/.zpreztorc";
    };

    "zprofile" = {
      source = ./to-symlink/linux-dotfiles/zprezto/runcoms/zprofile;
      target = "/home/sayantan/.zprofile";
    };

    "zshenv" = {
      source = ./to-symlink/linux-dotfiles/zprezto/runcoms/zshenv;
      target = "/home/sayantan/.zshenv";
    };

    "zshrc" = {
      source = ./to-symlink/linux-dotfiles/zprezto/runcoms/zshrc;
      target = "/home/sayantan/.zshrc";
    };

    "gpg-agent" = {
      source = ./to-symlink/linux-dotfiles/gpg-agent.conf;
      target = "/home/sayantan/.gnupg/gpg-agent.conf";
    };

  };

  home.packages = with pkgs;
    let
      pythonEnv = (python3.withPackages (ps:
        [
          ps.ipython
          # ps.numpy
          #ps.matplotlib
          #ps.scipy
          #ps.pandas
        ]));

    in [

      # Python with extra packages
      pythonEnv

      # Useful CLI utilities
      wget
      vim
      pass
      tree
      htop
      unzip
      pdftk
      imagemagick
      fzf
      zoxide
      ripgrep
      # Time tracker
      # watson

      # GUI programs
      #zotero
      #transmission-gtk

      # LaTeX setup. Commenting this out because it takes forever to build.
      # texlive.combined.scheme-full

      # Spell check suite
      # aspell
      # aspellDicts.en
      # aspellDicts.en-computers
      # aspellDicts.en-science
      (aspellWithDicts (dicts: with dicts; [ en en-computers ]))

      # Shell scripts
      (writeShellScriptBin "nix-switch"
        (builtins.readFile ./to-symlink/scripts/nix-switch-linux.sh))
      (writeShellScriptBin "nix-update"
        (builtins.readFile ./to-symlink/scripts/nix-update-and-switch-linux.sh))
      (writeShellScriptBin "all-update"
        (builtins.readFile ./to-symlink/scripts/update-all-linux.sh))
      (writeShellScriptBin "btrbk-remote-backup"
        (builtins.readFile ./to-symlink/scripts/linux-remote-backup.sh))

    ];

  programs = {

    git = {
      enable = true;
      userName = "Sayantan Khan";
      userEmail = "sayantangkhan@gmail.com";
      aliases = { co = "checkout"; };
      extraConfig = {
        core = {
          editor = "vim";
          # whitespace = "trailing-space,space-before-tab";
        };
        credential = { helper = "cache --timeout=86400"; };
      };
    };

    tmux = {
      enable = true;
      extraConfig = ''
        # Prefix key.
        set -g prefix C-a
        unbind C-b
        bind C-a send-prefix

        # Keys to switch session.
        bind Q switchc -t0
        bind W switchc -t1
        bind E switchc -t2

        #setw -g utf8 on
        #set -g status-utf8 on

        # Customized keybindings
        unbind %
        bind > split-window -h -c '#{pane_current_path}'
        bind < split-window -v -c '#{pane_current_path}'
        bind c new-window -c "#{pane_current_path}"

        #setw -g automatic-rename

        #set-option -g set-titles on
        #set-option -g set-titles-string '#S:#I.#P #W'
        #set-window-option -g automatic-rename on

        set -g allow-rename on

        # if run as "tmux attach", create a session if one does not already exist
        new-session

        # terminal colors
        set -g default-terminal "screen-256color"

        # Other customizations
        set -g status-bg black
        set -g status-fg white

        # Repeat timings
        set-option repeat-time 100
      '';
    };
  };
}
