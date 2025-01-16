{ config, pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      ghc 
      haskell-language-server
      haskellPackages.cabal-install
      haskellPackages.hlint
    ];
    home.file.ghci = {
      target = ".haskeline";
      text = ''
        editMode: Vi
      '';
    };
  };
}

