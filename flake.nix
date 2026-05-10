{
  description = "A configuration.nix replacement";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # For converting docker to nixos compatible 
    compose2nix.url = "github:aksiksi/compose2nix/v0.3.0";
    compose2nix.inputs.nixpkgs.follows = "nixpkgs";
    airi-pkgs = {
        url = "github:moeru-ai/airi";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap = {
        # System key remapper
        url = "github:xremap/nix-flake";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nixpkgs-unstable,
      compose2nix,
      # airi-pkgs,
      ...
    }:
    let
      globals = rec {
        user = "mugen";
        fullName = "John Nguyen";
        gitName = fullName;
        email = "john.nguyen1022@gmail.com";
        systemOption = "standalone"; # standalone | nixos
        device = "nixos";
      };
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};

      home-manager-modules = [
        ./home-manager

        inputs.xremap.homeManagerModules.default

        {
          home.stateVersion = "25.11";
          home.username = globals.user;
          home.homeDirectory = "/home/${globals.user}";
          programs.home-manager.enable = true;
        }

        {
          home.packages = [
            # Nix lsp
            pkgs.nil
            pkgs.nixfmt
          ];
        }

        {
          #TODO: testing only move this to a proper place
          programs.vscode = {
            enable = true;
          };
        }

      ];
    in
    {
      nixosConfigurations.${globals.user} = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {
          # device = device;
          # user = globals.user;
          globals = globals;
          pkgs-unstable = pkgs-unstable;
        };


        modules = [
          ./system
          ./configuration.nix
          {
            nixpkgs.config.allowUnfree = true;
            environment.systemPackages = [
              compose2nix.packages.x86_64-linux.default
              # airi-pkgs.packages.x86_64-linux.default
            ];
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit globals; };
            home-manager.backupFileExtension = "backup";
            home-manager.users.${globals.user} = {
              imports = home-manager-modules ++ [
                ./default-home-manager.nix
              ];
            };
          }

          # Has to be loaded last so all the configs is built
          ./default.nix # configs that is shared between machines
          ./system/general_config
        ];
      };

      homeConfigurations."${globals.user}" = home-manager.lib.homeManagerConfiguration rec {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit globals; };
        modules = home-manager-modules ++ [
            ./default-home-manager.nix
        ];
      };
    };
}
