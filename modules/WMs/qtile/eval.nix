# let
#   nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
#   options = {
#     environment = {
#       variables = [];
#     };
#   };
#   pkgs = import nixpkgs { options = options; config = {}; overlays = []; };
# in
# pkgs.lib.evalModules {
#   specialArgs = {
#     inherit pkgs;
#   };
#   modules = [
#     ./main.nix
#   ];
# }
