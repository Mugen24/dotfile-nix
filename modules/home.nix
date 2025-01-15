{ config, pkgs, ... }:

let
  userEmail = "John.nguyen1022@gmail.com";
  name = "John Nguyen";
in
{
  imports = [
    ./Shell/zsh.nix
  ];
  


  # systemd.user.services.polybar = {
  #   Install.WantedBy = [ "graphical-session.target" ];
  # };
  # services.polybar = {
  #   enable = true;
  #   script = "polybar &";
  #   config = /home/mugen/.config/home-manager/config/polybar/config.ini;
  # };
  # systemd.user.services.polybar = {
  #   Install.WantedBy = [ "graphical-session.target" ];
  # };
  # services.polybar = {
  #   enable = true;
  #   script = "polybar &";
  #   config = /home/mugen/.config/home-manager/config/polybar/config.ini;
  # };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mugen";
  home.homeDirectory = "/home/mugen";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    firefox
    rofi
    arandr
    kitty
    wget
    curl
    python3
    gparted
    kdePackages.okular
    pdfarranger
    libsForQt5.dolphin
    cinnamon.nemo
    cinnamon.nemo-fileroller

    btop
    onlyoffice-bin
    libreoffice-qt6-fresh
    vlc
    gpick
    brightnessctl
    chromium
    networkmanagerapplet
    obsidian

    #Photo viewer
    digikam
    # screenshot
    ksnip

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # Indexing nix store
    nix-index
  ];

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
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mugen/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-sleuth
      mason-nvim
      nvim-lspconfig 
    ];
    defaultEditor = true;
    extraConfig = ''
      inoremap jj <Esc>
      syntax on " Syntax highlighting
      set showmatch " Shows matching brackets
      set ruler " Always shows location in file (line#)
      set smarttab " Autotabs for certain code
      set shiftwidth=4
      set tabstop=4
      lua << EOF
      require("mason").setup()
      require'lspconfig'.hls.setup{}
      EOF
    '';
  };

  programs.vscode = {
    enable = true;
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.git = {
    enable = true;
    userEmail= "${userEmail}";
    userName = "${name}";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
