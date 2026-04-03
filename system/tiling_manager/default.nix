args@{config, pkgs, lib, ...}:
let 
  # theme = {
  #   image_path = ./wallpapers/neon_shallows.png;
  # };
  theme = "";
in
{
  imports = [
    (
      import ./qtile 
    )
  ];

}
