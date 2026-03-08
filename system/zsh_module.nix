{
  globals,
  lib,
  pkgs,
  config,
  ...
}:
{
  options.system.zsh = {
    enable = lib.mkEnableOption "Enable";
  };

  config = lib.mkIf config.system.zsh.enable (lib.mkMerge [
    {
      programs.zsh.enable = true;
      users.users.${globals.user} = {
        shell = pkgs.zsh;
      };
    }
  ]);
}
