# {
#   config,
#   lib,
#   pkgs,
#   globals,
#   nixosConfig,
#   ...
# }:
# {
#   options.extra-keybinds = {
#     enable = lib.mkEnableOption "enable";
#   };
# 
#   config = lib.mkIf config.extra-keybinds.enable (
#     {
#       services.xremap = {
#         withX11 = true;
#         debug = true;
#         enable = true;
#         # Modmap for single key rebinds
#         # config.modmap = [{
#         #   name = "Global";
#         #   remap = { "CapsLock" = "Esc"; };
#         # }];
# 
#         # Keymap for key combo rebinds
#         config.keymap = [
#             {
#               name = "Map ctrl-n to down key";
#               remap = { "C-n" = "Down"; };
#             }
#             {
#               name = "Map ctrl-p to up key";
#               remap = { "C-p" = "Up"; };
#             }
#         ];
#       };
#     } 
#   );
# }
