{
  description = "A configuration.nix replacement";
  inputs = {
    # nixpkgs.url = "github:nixOS/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: 
  let 
    system = "x86_64-linux";
    device = "main_pc";
    user = "mugen";
    # home_flake = import /home/mugen/.config/home-manager/flake.nix;
    # home_flake_out = home_flake.outputs {
    #   inherit self;
    #   inherit nixpkgs;
    #   inherit home-manager;
    # };
  in
  {
    nixosConfigurations.${user} = nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = {
        device = device;
        user = user;
      };
      modules = [
        {
          nixpkgs.config.allowUnfree = true;
        }
        ./configuration.nix
        ./modules
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = {
            imports = [];
          };
        }
      ];
    };

  };
}
