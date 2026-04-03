{
  description = "A configuration.nix replacement";
  inputs = {
    # nixpkgs.url = "github:nixOS/nixpkgs/nixos-24.11";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nur, nixpkgs, home-manager, ... }@input: 
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
          nixpkgs.overlays = [ nur.overlays.default ];
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
