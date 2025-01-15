{ username, pkgs, ... }:
{
    imports = [
        (import ./Komga.nix { username = username; pkgs = pkgs;})
        (import ./Calibre.nix { username = username; pkgs = pkgs;})
    ];
}
