{ config, pkgs, ... }:

{
  home.username = "sayantan";
  home.homeDirectory = "/home/sayantan";

  home.stateVersion = "24.11"; # Please read the comment before changing.

  # Do not display news
  news.display = "silent";

  programs.home-manager.enable = true;

  targets.genericLinux.enable = true;

  services = {
    # Syncthing
    syncthing = {
      enable = true;
      extraOptions = [ "--gui-address=TODO-TAILSCALE-IP:8384" ];
    };
  };

  home.file = {
    "jellyfin-service" = {
      source = ./to-symlink/podman-containers/jellyfin-nas.container;
      target = "/home/sayantan/.config/containers/systemd/jellyfin.container";
    };

    "homepage-service" = {
      source = ./to-symlink/podman-containers/homepage-nas.container;
      target = "/home/sayantan/.config/containers/systemd/homepage.container";
    };

    "podgrab-service" = {
      source = ./to-symlink/podman-containers/podgrab-nas.container;
      target = "/home/sayantan/.config/containers/systemd/podgrab.container";
    };

    "git-config" = {
      source = ./to-symlink/linux-dotfiles/git-config;
      target = "/home/sayantan/.config/git/config";
    };

    "bash_aliases" = {
      source = ./to-symlink/linux-dotfiles/bash_aliases;
      target = "/home/sayantan/.bash_aliases";
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

  home.packages = with pkgs; [
    wget
    vim
    ripgrep
    tree
    htop
    tmux
    unzip
    borgbackup
    fzf
    zoxide
    yt-dlp
    ffmpeg
    btrbk

    # Shell scripts
    (writeShellScriptBin "nix-switch"
      (builtins.readFile ./to-symlink/scripts/nix-switch-linux.sh))
    (writeShellScriptBin "nix-update"
      (builtins.readFile ./to-symlink/scripts/nix-update-and-switch-linux.sh))
    (writeShellScriptBin "all-update"
      (builtins.readFile ./to-symlink/scripts/update-all-tumbleweed-nas.sh))
  ];

  programs = {
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

        # Customized keybindings
        unbind %
        bind > split-window -h -c '#{pane_current_path}'
        bind < split-window -v -c '#{pane_current_path}'
        bind c new-window -c "#{pane_current_path}"

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
