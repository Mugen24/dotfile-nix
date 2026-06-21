{options, pkgs, lib, config, pkgs-unstable, ...}:
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


    environment.systemPackages = [ 
        pkgs-unstable.ollama-rocm 
        pkgs.python313
        pkgs.python313Packages.huggingface-hub
        pkgs.pnpm
        pkgs.nodejs_24
        pkgs.claude-code
    ];

    # required for mcp tool use in continue
    programs.npm = {
        enable = true;
    };


    services.ollama = lib.mkMerge [
      {
        enable = true;
        acceleration = "rocm";
        package = pkgs-unstable.ollama-rocm;
        rocmOverrideGfx = "11.0.0";
        # For debugging
        environmentVariables.OLLAMA_DEBUG="1";
      }
      (
        lib.mkIf (options.system.LLM.ollama ? download_path) {
          models = config.system.LLM.ollama.download_path;
        }
      )
    ]; 

    hardware.graphics.enable = true;
    services.open-webui = {
        enable = true;
        port = 9000;
    };
    # //
    # lib.mkIf config.system.LLM.ollama.download_path {
    #   models = config.system.LLM.ollama.download_path;
    # };
  };
}
