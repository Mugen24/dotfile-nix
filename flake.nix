{
  description = "A configuration.nix replacement";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixvim, ... }: 
  let 
    globals = rec {
      user = "mugen";
      fullName = "John Nguyen";
      gitName = fullName;
    };
    system = "x86_64-linux";
  in
  {
    homeConfigurations."${globals.user}" = home-manager.lib.homeManagerConfiguration rec {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = { inherit globals; };
      modules = [ 
        (import ./home-manager)
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
      ];
    };
  };
}
