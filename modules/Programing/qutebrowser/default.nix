{config, pkgs, user, ...}:
{
  imports = {
  };

  options = {
    
  };

  config = {
    environment.systemPackages = with pkgs; [
      qutebrowser
    ];

  };
}


