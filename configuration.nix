# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./system_config.nix
    ];
  
  qtile_mod = {
    enable = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ 
    "amdgpu" 
  ];
  boot.kernelParams = [
  ];

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ 
      v4l2loopback 
    ];

    kernelModules = [ 
      "v4l2loopback" 
      "firewire-core"
      "firewire-ohci"
      "snd-firewire-motu"
    ];

    extraModprobeConfig = ''
        # example settings
	# options yourmodulename optionA=valueA optionB=valueB # syntax
	options v4l2loopback video_nr=9 card_label=Video-Loopback exclusive_caps=1
        # blacklist snd-fireworks
        # blacklist snd-bebob
        # blacklist snd-oxfw
        # blacklist snd-dice
        # blacklist snd-firewire-digi00x
        # blacklist snd-firewire-tascam
        # blacklist snd-firewire-lib
        # blacklist snd-firewire-transceiver
        # blacklist snd-fireface
        # blacklist snd-firewire-motu
    '';
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
      amdvlk
    ];
};
	
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Autocompletion for systemd in zsh
  programs.zsh.enable = true;
  # Adhoc execution of binaries;
  programs.nix-ld.enable = true;

  environment.shells = with pkgs; [ zsh ];
  environment.pathsToLink = [ "/share/zsh" ];
  users.defaultUserShell = pkgs.zsh;

 


  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.displayManager = {
    enable = true;
  };

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.windowManager.qtile.enable = true;

  # services.xserver.windowManager.qtile.backend = "wayland";

  # Configure keymap in X11
 services.xserver = {
   enable = true;  
   videoDrivers = ["amdgpu"];
   xkb = {
     layout = "au";
   };
 };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  #https://www.reddit.com/r/NixOS/comments/185f0x4/how_to_mount_a_usb_drive/
  # Enable auto-mouning usbdrives
  services.devmon.enable = true;
  services.gvfs.enable = true; 
  services.udisks2.enable = true;

  # Enable sound with pipewire.
  # hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;

    # alsa.enable = true;
    # alsa.support32Bit = true;

    pulse.enable = true;
    audio.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    wireplumber = {
      enable = true;
    };
    # package = pkgs.pipewire.override {
    #   # ffadoSupport = true;
    #   # ffado = pkgs.ffado;
    # };

    # extraConfig.pipewire."10-ffado" = {
    #   "context.modules" = [
    #     {   
    #       "name" = "libpipewire-module-ffado-driver";
    #       "args" = {
    #         "driver.mode"       = "duplex";
    #         "ffado.devices"     = [ "hw:0" ];
    #         "ffado.period-size" = 1024;
    #         "ffado.period-num"  = 3;
    #         "ffado.sample-rate" = 48000;
    #         "ffado.slave-mode"  = false;
    #         "ffado.snoop-mode"  = false;
    #         "ffado.verbose"     = 0;
    #         "ffado.rtprio"      = 65;
    #         "ffado.realtime"    = true;
    #         "latency.internal.input"  = 0;
    #         "latency.internal.output" = 0;
    #         "audio.position"    = [ "FL" "FR" ];
    #         "source.props" = {
    #     	# extra sink properties
    #         };
    #         "sink.props" = {
    #     	# extra sink properties
    #         };
    #       };
    #     }
    #   ];
    # };

  };

  security.pam.loginLimits = [
      { domain = "@audio"; item = "memlock"; type = "-"   ; value = "unlimited"; }
      { domain = "@audio"; item = "rtprio" ; type = "-"   ; value = "99"       ; }
      { domain = "@audio"; item = "nofile" ; type = "soft"; value = "99999"    ; }
      { domain = "@audio"; item = "nofile" ; type = "hard"; value = "99999"    ; }
    ];

  services.udev.extraRules = ''
      KERNEL=="rtc0", GROUP="audio"
      KERNEL=="hpet", GROUP="audio"
      KERNEL=="fw*", GROUP="audio", MODE="0664"
  '';


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mugen = {
    isNormalUser = true;
    description = "Mugen";
    extraGroups = [ "networkmanager" "wheel" "docker" "audio" "root" "users" ];
    packages = with pkgs; [
    #  thunderbird
    qjackctl
    ];
  };


  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "mugen";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs.firefox = {
    enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
  environment.systemPackages = with pkgs; [
    # Required to get steam permission working
    # when adding more storage location
    # xdg-desktop-portal
    xdg-desktop-portal-gtk
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    firefox
    home-manager
    kitty
    xorg.xinit
    ntfs3g
    # pavucontrol
    pwvucontrol
    alsa-utils
    # (ffado.override {
    #   withMixer=true;
    # })
    kdePackages.dolphin
    pciutils
    busybox
    cura-appimage

    # notification manager
    dunst
    libnotify
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  programs.git = {
    enable = true;
    config = {
      user = {
	email = "John.nguyen1022@gmail.com";
	name = "John Nguyen";
      };
    };
  };

  
  fileSystems."/media/Linux_storage" = {
    device = "/dev/disk/by-uuid/730269e9-6f16-47a1-814e-e62cf3fd72bb";
    options = [ "users" "nofail" "exec" ];
  };

  # v4l2loopback video_nr=9 card_label=Video-Loopback exclusive_caps=1

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
