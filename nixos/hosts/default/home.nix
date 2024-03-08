{ config, pkgs, lib, ... }:

let
  alacrittySettings = import ../../modules/home-manager/programs/terminal/alacritty/alacritty-settings.nix;
  zshSettings = import ../../modules/home-manager/programs/shell/zsh-settings.nix;
in

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "daniel";
  home.homeDirectory = "/home/daniel";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  programs.zsh = zshSettings;
  programs.alacritty = alacrittySettings;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "GeistMono" ]; })
  ];

  home.file."${config.xdg.configHome}/nvim" = {
    source = ../../modules/home-manager/programs/nvim;
    recursive = true;
  };

  home.file."/home/daniel/.tmux" = {
    source = ../../../tmux;
  };

  home.file."/home/daniel/.tmux.conf" = {
    source = ../../../tmux/tmux.conf;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/daniel/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  gtk = {

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "palenight";
      package = lib.mkDefault pkgs.palenight-theme;
    };

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  home.sessionVariables.GTK_THEME = "palenight";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
