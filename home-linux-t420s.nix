{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "18.09";

  # Do not display news
  news.display = "silent";

  targets.genericLinux.enable = true;

  # Defining the community Emacs overlay
  nixpkgs.overlays = [
    (prev: final: {
      localPackages = import ./pkgs { inherit pkgs; };
    })
  ];

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
      source = "/home/sayantan/home-manager-nix/podman-systemd/jellyfin.container";
      target = ".config/containers/systemd/jellyfin.container";
    };

    "homepage-service" = {
      source = "/home/sayantan/home-manager-nix/podman-systemd/homepage.container";
      target = ".config/containers/systemd/homepage.container";
    };

    "podgrab-service" = {
      source = "/home/sayantan/home-manager-nix/podman-systemd/podgrab.container";
      target = ".config/containers/systemd/podgrab.container";
    };

    #"transmission-service" = {
    #  source = "/home/sayantan/home-manager-nix/podman-systemd/transmission.container";
    #  target = ".config/containers/systemd/transmission.container";
    #};

    "org-to-things.service" = {
      source = "/home/sayantan/home-manager-nix/podman-systemd/org-to-things.service";
      target = ".config/systemd/user/org-to-things.service";
    };

    "btrfs-balance.service" = {
      source = "/home/sayantan/home-manager-nix/podman-systemd/btrfs-balance.service";
      target = ".config/systemd/user/btrfs-balance.service";
    };

    "btrfs-balance.timer" = {
      source = "/home/sayantan/home-manager-nix/podman-systemd/btrfs-balance.timer";
      target = ".config/systemd/user/btrfs-balance.timer";
    };

    "btrfs-backup.service" = {
      source = "/home/sayantan/home-manager-nix/podman-systemd/btrfs-backup.service";
      target = ".config/systemd/user/btrfs-backup.service";
    };

    "btrfs-backup.timer" = {
      source = "/home/sayantan/home-manager-nix/podman-systemd/btrfs-backup.timer";
      target = ".config/systemd/user/btrfs-backup.timer";
    };

    "config-backup.service" = {
      source = "/home/sayantan/home-manager-nix/podman-systemd/config-backup.service";
      target = ".config/systemd/user/config-backup.service";
    };

    "config-backup.timer" = {
      source = "/home/sayantan/home-manager-nix/podman-systemd/config-backup.timer";
      target = ".config/systemd/user/config-backup.timer";
    };

    "zathurarc" = {
      source = "/home/sayantan/home-manager-nix/files/zathurarc";
      target = ".config/zathura/zathurarc";
    };

    "git-config" = {
      source = "/home/sayantan/home-manager-nix/files/git-config";
      target = ".config/git/config";
    };

    "latexmkrc" = {
      source = "/home/sayantan/home-manager-nix/files/latexmkrc";
      target = ".latexmkrc";
    };

    "bash_aliases" = {
      source = "/home/sayantan/home-manager-nix/files/bash_aliases";
      target = ".bash_aliases";
    };

    "alacritty-config" = {
      source = "/home/sayantan/home-manager-nix/files/alacritty.yml";
      target = "/home/sayantan/.config/alacritty/alacritty.yml";
    };

    #"zfunc" = {
    #  recursive = true;
    #  source = "/home/sayantan/home-manager-nix/files/zfunc";
    #  target = ".zfunc";
    #};

    "zprezto" = {
      recursive = true;
      source = "/home/sayantan/home-manager-nix/files/zprezto";
      target = ".zprezto";
    };

    "zlogin" = {
      source = "/home/sayantan/home-manager-nix/files/zprezto/runcoms/zlogin";
      target = ".zlogin";
    };

    "zlogout" = {
      source = "/home/sayantan/home-manager-nix/files/zprezto/runcoms/zlogout";
      target = ".zlogout";
    };


    "zpreztorc" = {
      source = "/home/sayantan/home-manager-nix/files/zprezto/runcoms/zpreztorc";
      target = ".zpreztorc";
    };


    "zprofile" = {
      source = "/home/sayantan/home-manager-nix/files/zprezto/runcoms/zprofile";
      target = ".zprofile";
    };


    "zshenv" = {
      source = "/home/sayantan/home-manager-nix/files/zprezto/runcoms/zshenv";
      target = ".zshenv";
    };


    "zshrc" = {
      source = "/home/sayantan/home-manager-nix/files/zprezto/runcoms/zshrc";
      target = ".zshrc";
    };

    "gpg-agent" = {
      source = "/home/sayantan/Sync/configs/t420s-workstation/files/gpg-agent.conf";
      target = "/home/sayantan/.gnupg/gpg-agent.conf";
    };

  };

  home.packages = with pkgs; let
    pythonEnv = (python3.withPackages (ps: [
      ps.ipython
      #ps.numpy
      #ps.matplotlib
      #ps.scipy
      #ps.pandas
    ]));

    jupyterWithStuff = pkgs.jupyter.override {
      definitions = {
        python3 = let
          env = pythonEnv;
        in {
          displayName = "Python 3";
          argv = [
            "${env.interpreter}"
            "-m"
            "ipykernel_launcher"
            "-f"
            "{connection_file}"
          ];
          language = "python";
          logo32 = "${env.sitePackages}/ipykernel/resources/logo-32x32.png";
          logo64 = "${env.sitePackages}/ipykernel/resources/logo-64x64.png";
        };
      };
    };

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

  ];

  programs = {

    emacs = {
      enable = true;
      package = pkgs.localPackages.emacs;
    };

    # emacs = {
    #   enable = true;
    #   extraPackages = epkgs: (with epkgs; [
    #     monokai-theme
    #     magit
    #     bind-key
    #     use-package
    #     # dashboard
    #     yasnippet
    #     evil
    #     evil-nerd-commenter
    #     evil-leader
    #     helm
    #     markdown-mode
    #     auctex-latexmk
    #     all-the-icons
    #     nix-mode
    #     auctex
    #     elpy
    #     flycheck
    #     blacken
    #     # rustic
    #     company
    #     # lsp-mode
    #     # lsp-ui
    #     # hydra
    #     # company-lsp
    #     # helm-lsp
    #     smartparens
    #   ]) ++ (let
    #     pythonEnv = (pkgs.python3.withPackages (ps: [
    #       ps.pip
    #       ps.black
    #       ps.ipython
    #       ps.flake8
    #     ]));
    #   in [pythonEnv]);
    # };

    tmux = {
      enable = true;
      extraConfig =
        ''
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
