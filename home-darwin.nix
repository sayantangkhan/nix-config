# home.nix

{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowUnfreePredicate = (_: true);

  # The home.packages option allows you to install Nix packages into your
  # environment.

  home.packages = with pkgs; let
    pythonEnv = (python3.withPackages (ps: [
      ps.ipython
      # ps.numpy
      #ps.matplotlib
      #ps.scipy
      #ps.pandas
    ]));

  in [

    # Python with extra packages
    pythonEnv

    # Jupyter with extra packages
    # jupyterWithStuff

    # Useful CLI utilities
    wget
    vim
    pass
    gnupg
    pinentry_mac
    tree
    htop
    unzip
    fzf
    zoxide
    ripgrep

    # Nix binary cache
    cachix

    # Shell scripts
    (writeShellScriptBin "nix-switch" (builtins.readFile ./to-symlink/scripts/nix-switch-darwin.sh))
    (writeShellScriptBin "nix-update" (builtins.readFile ./to-symlink/scripts/nix-update-and-switch-darwin.sh))
    (writeShellScriptBin "all-update" (builtins.readFile ./to-symlink/scripts/update-all-darwin.sh))
    (writeShellScriptBin "qpass" (builtins.readFile ./to-symlink/scripts/password-prompt.sh))
    (writeShellScriptBin "spass" (builtins.readFile ./to-symlink/scripts/password-prompt-no-copy.sh))

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

  ];


  programs = {

    git = {
      enable = true;
      userName = "Sayantan Khan";
      userEmail = "sayantangkhan@gmail.com";
      aliases = {
      co = "checkout";
      };
     extraConfig = {
       core = {
         editor = "vim";
         # whitespace = "trailing-space,space-before-tab";
       };
       credential = {
         helper = "cache --timeout=86400";
       };
     };
    };

    fzf = {
      enable = true;
    };

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
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # Ghostty config
    ghostty = {
      source = ./to-symlink/ghostty/config;
      target = "/Users/sayantan/.config/ghostty/config";
    };

    # Zsh config
    "zprezto" = {
      recursive = true;
      source = ./to-symlink/zprezto;
      target = ".zprezto";
    };

    "zlogin" = {
      source = ./to-symlink/zprezto/runcoms/zlogin;
      target = ".zlogin";
    };

    "zlogout" = {
      source = ./to-symlink/zprezto/runcoms/zlogout;
      target = ".zlogout";
    };

    "zpreztorc" = {
      source = ./to-symlink/zprezto/runcoms/zpreztorc;
      target = ".zpreztorc";
    };


    "zprofile" = {
      source = ./to-symlink/zprezto/runcoms/zprofile;
      target = ".zprofile";
    };


    "zshenv" = {
      source = ./to-symlink/zprezto/runcoms/zshenv;
      target = ".zshenv";
    };


    "zshrc" = {
      source = ./to-symlink/zprezto/runcoms/zshrc;
      target = ".zshrc";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
