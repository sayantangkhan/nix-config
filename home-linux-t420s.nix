{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "sayantan";
  home.homeDirectory = "/home/sayantan";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  # Do not display news
  news.display = "silent";

  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;

  services = {
    # Emacs server
    # emacs.enable = true;

    # Syncthing
    syncthing = {
      enable = true;
      extraOptions = [ "--gui-address=100.117.240.59:8384" ];
    };
  };

  home.file = {
    "jellyfin-service" = {
      source = ./to-symlink/podman-containers/jellyfin.container;
      target = "/home/sayantan/.config/containers/systemd/jellyfin.container";
    };

    "homepage-service" = {
      source = ./to-symlink/podman-containers/homepage.container;
      target = "/home/sayantan/.config/containers/systemd/homepage.container";
    };

    "podgrab-service" = {
      source = ./to-symlink/podman-containers/podgrab.container;
      target = "/home/sayantan/.config/containers/systemd/podgrab.container";
    };

    # "org-to-things.service" = {
    #   source = ./to-symlink/podman-containers/org-to-things.service;
    #   target = "/home/sayantan/.config/systemd/user/org-to-things.service";
    # };

    "btrfs-balance.service" = {
      source = ./to-symlink/podman-containers/btrfs-balance.service;
      target = "/home/sayantan/.config/systemd/user/btrfs-balance.service";
    };

    "btrfs-balance.timer" = {
      source = ./to-symlink/podman-containers/btrfs-balance.timer;
      target = "/home/sayantan/.config/systemd/user/btrfs-balance.timer";
    };

    "btrfs-backup.service" = {
      source = ./to-symlink/podman-containers/btrfs-backup.service;
      target = "/home/sayantan/.config/systemd/user/btrfs-backup.service";
    };

    "btrfs-backup.timer" = {
      source = ./to-symlink/podman-containers/btrfs-backup.timer;
      target = "/home/sayantan/.config/systemd/user/btrfs-backup.timer";
    };

    "config-backup.service" = {
      source = ./to-symlink/podman-containers/config-backup.service;
      target = "/home/sayantan/.config/systemd/user/config-backup.service";
    };

    "config-backup.timer" = {
      source = ./to-symlink/podman-containers/config-backup.timer;
      target = "/home/sayantan/.config/systemd/user/config-backup.timer";
    };

    "btrbk-config" = {
      source = ./to-symlink/linux-dotfiles/btrbk-t420s.conf;
      target = "/home/sayantan/.config/btrbk/btrbk.conf";
    };

    "git-config" = {
      source = ./to-symlink/linux-dotfiles/git-config;
      target = "/home/sayantan/.config/git/config";
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

    #"zfunc" = {
    #  recursive = true;
    #  source = "./to-symlink/linux-dotfiles/zfunc";
    #  target = ".zfunc";
    #};

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
          #ps.numpy
          #ps.matplotlib
          #ps.scipy
          #ps.pandas
        ]));

      # Link into ipythonEnv package to avoid polluting $PATH with python deps
      # ipythonPackage = pkgs.runCommand "ipython-stripped" {} ''
      # mkdir -p $out/bin
      # ln -s ${ipythonEnv}/bin/ipython $out/bin/ipython
      # '';
    in [

      # Python with extra packages
      pythonEnv

      # Jupyter with extra packages
      # jupyterWithStuff

      # Useful CLI utilities
      wget
      vim
      ripgrep
      #pass
      #git
      tree
      htop
      tmux
      unzip
      pdftk
      imagemagick
      #watson
      borgbackup
      fzf
      zoxide
      #guile
      #ctags
      #cabal2nix
      #cachix
      yt-dlp
      ffmpeg
      btrbk
      pandoc

      # GUI programs
      # zotero

      # LaTeX setup. Commenting this out because it takes forever to build.
      # texlive.combined.scheme-full

      # Spell check suite
      # aspell
      # aspellDicts.en
      # aspellDicts.en-computers
      # aspellDicts.en-science

      # Shell scripts
      (writeShellScriptBin "nix-switch"
        (builtins.readFile ./to-symlink/scripts/nix-switch-linux.sh))
      (writeShellScriptBin "nix-update"
        (builtins.readFile ./to-symlink/scripts/nix-update-and-switch-linux.sh))
      (writeShellScriptBin "all-update"
        (builtins.readFile ./to-symlink/scripts/update-all-linux.sh))

    ];

  programs = {

    # emacs = with pkgs; let
    #   myEmacs = emacs.pkgs.withPackages (epkgs: (with epkgs; [
    #       monokai-theme
    #       twilight-bright-theme
    #       bind-key
    #       undo-tree
    #       async
    #       separedit
    #       flycheck
    #       nix-mode
    #       magit
    #       use-package
    #       dashboard
    #       yasnippet
    #       evil
    #       evil-nerd-commenter
    #       evil-leader
    #       helm
    #       markdown-mode
    #       auctex
    #       auctex-latexmk
    #       smartparens
    #       all-the-icons
    #       haskell-mode
    #       reformatter
    #       haskell-snippets
    #       ormolu
    #   ]));
    # in
    #   {
    #     enable = true;
    #     package = myEmacs;
    #   };

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

    # zathura = {
    #   enable = true;
    #   extraConfig =
    #     ''
    #     set selection-clipboard clipboard
    #     map = zoom in
    #     map + zoom default
    #     map <PageDown> scroll half-down
    #     map <PageUp> scroll half-up
    #     map <Left> scroll full-up
    #     map <Right> scroll full-down
    #     '';
    # };

  };

}
