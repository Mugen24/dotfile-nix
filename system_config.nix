{
  pkgs, config, ...
}:

let 
  username = "mugen";
in
{
  # imports = [
  #   (import ./system_modules/Readings/default.nix { username = username; pkgs = pkgs; })
  # ];

  imports = [
    ./.
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;

  # For devenv to setup nixcache ??
  nix.settings.trusted-users = [ "root" "mugen" ];

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Autocompletion for systemd in zsh
  programs.zsh.enable = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    zlib # numpy
    libgcc  # sqlalchemy
    # that's where the shared libs go, you can find which one you need using 
    # nix-locate --top-level libstdc++.so.6  (replace this with your lib)
    # ^ this requires `nix-index` pkg
  ];

  environment.shells = with pkgs; [ zsh ];
  environment.pathsToLink = [ "/share/zsh" ];
  users.defaultUserShell = pkgs.zsh;

  # services.xserver.windowManager.qtile = {
  #   configFile = ./config/qtile/config.py;
  # }; 

  virtualisation.docker.enable = true;

  programs.git = {
    enable = true;
    config = {
      user = {
	email = "John.nguyen1022@gmail.com";
	name = "John Nguyen";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    firefox
    home-manager
    kitty
    xorg.xinit
    ntfs3g
    pavucontrol
    clinfo
    unzip
    devenv

    #audio driver ?
    ffado
  ];

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  # users.users.mugen = {
  #   isNormalUser = true;
  #   description = "mugen";
  #   extraGroups = [ "networkmanager" "wheel" ];
  #   packages = with pkgs; [
  #   #  thunderbird
  #   ];
  # };

  #https://www.reddit.com/r/NixOS/comments/185f0x4/how_to_mount_a_usb_drive/
  # Enable auto-mouning usbdrives
  services.devmon.enable = true;
  services.gvfs.enable = true; 
  services.udisks2.enable = true;

  programs.nm-applet.enable = true;
  networking.networkmanager = {
    enable = true;
  };

  programs.java.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8001 8112 8113 8080 8111 8116 ];
  };

  environment.variables = {
      # CALIBRE_DEVELOP_FROM = "/home/mugen/App/calibre/src";
      CALIBRE_RESOURCES_PATH = "/nix/store/vm12mv08h665s1dg14lf513275b0cg24-calibre-7.10.0/share/calibre";
      CALIBRE_PYTHON_PATH = "/home/mugen/App/calibre";
  };

  boot.loader.grub.configurationLimit = 5;
  boot.loader.systemd-boot.configurationLimit = 5;

  services.picom = {
    enable = true;
  };

  #AUDO setup need to make into module
  services.jack = {
    jackd.enable = true;
    # support ALSA only programs via ALSA JACK PCM plugin
    alsa.enable = false;
    # support ALSA only programs via loopback device (supports programs like Steam)
    loopback = {
      enable = true;
      # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
      #dmixConfig = ''
      #  period_size 2048
      #'';
    };
  };

  users.extraUsers.mugen.extraGroups = [ "jackaudio" ];
}
