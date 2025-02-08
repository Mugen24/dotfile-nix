{lib, config, ...}:
with lib;
let 
  cfg = config.virtual_box;
in 
{
  options = {
    virtual_box = {
      enable = mkEnableOption "Enable module";

    };
  };

  config = mkIf cfg.enable {
    virtualisation.virtualbox.host.enable = true;  
  };
}
