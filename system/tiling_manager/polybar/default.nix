{pkgs, ...}: 
{
  # imports = [
  #   ./polybar-themes
  # ];
  environment.systemPackages = with pkgs; [
    polybar
    rofi
    pywal
    calc
    networkmanager_dmenu
    killall
  ];
  environment = {
    etc."polybar/colors.ini" = {
      source = ./polybar-themes/neon/colors.ini;
    };
    etc."polybar/config.ini" = {
      source = ./polybar-themes/neon/config.ini;
    };
    etc."polybar/modules.ini" = {
      source = ./polybar-themes/neon/modules.ini;
    };
    # etc."polybar/launch.sh" = {
    #   source = ./polybar-themes/neon/launch.sh;
    # };
  };

  # systemd.services.polybar_launch = {
  #   description = "Run polybar launch script";
  #   wantedBy = [ "multi-user.target" ]; # Starts the service during boot
  #   serviceConfig = {
  #     Type = "oneshot";
  #     User = "mugen"; # Or your username
  #   };
  #   script = builtins.readFile ./polybar-themes/neon/launch.sh;
  # };
}