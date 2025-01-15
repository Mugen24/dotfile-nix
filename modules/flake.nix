{
  description = "Home Manager configuration of mugen";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-24.05";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = "${system}";
        config.allowUnfree = true;
        config.allowBroken = true;
      };

    in {
      homeConfigurations."mugen" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ 
          ./home.nix 
          ./Programing/web_development/configuration.nix
          ./Programing/haskell.nix
          ./Programing/uni.nix
          ./Programing/database.nix
          ./Other/photoshop.nix
          ./Programing/python.nix
          ./Programing/Editor/nvim.nix
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };

    };
}
