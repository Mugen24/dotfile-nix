{pkgs, lib, config, pkgs-unstable, ...}:
{
  options.system.LLM.ollama = {
    enable = lib.mkEnableOption "Enable";
    download_path = lib.mkOption {
      type = lib.types.str;
      description = ''
        Location to install the local LLM
      '';
    };
  };

  config = lib.mkIf config.system.LLM.ollama.enable {
    services.ollama = {
      enable = true;
      acceleration = "rocm";
      package = pkgs-unstable.ollama-rocm;
    } //
    lib.mkIf config.system.LLM.ollama.download_path {
      models = config.system.LLM.ollama.download_path;
    };
  };
}
