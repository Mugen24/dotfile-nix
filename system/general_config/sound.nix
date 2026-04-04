{pkgs, globals, ...}:
{
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

  hardware.pulseaudio.enable = false; # Use Pipewire, the modern sound subsystem
  security.rtkit.enable = true; # Enable RealtimeKit for audio purposes

  # Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  environment.systemPackages = [
    pkgs.pavucontrol
    pkgs.pavucontrol # PulseAudio Volume Control
    pkgs.pamixer # Command-line mixer for PulseAudio

    pkgs.bluez # Bluetooth support
    pkgs.bluez-tools # Bluetooth tools
  ];
  users.extraUsers."${globals.user}".extraGroups = [ 
    "audio"
  ];
}