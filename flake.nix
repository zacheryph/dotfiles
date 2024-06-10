# nix run nix-darwin -- --flake .
{
  description = "My Personal Operational Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs }:
  let
    system = "aarch64-darwin";
    username = "context";
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .
    darwinConfigurations.fourteen = nix-darwin.lib.darwinSystem {
      modules = [
        ./nix-darwin/configuration.nix
        # configuration
        # home-manager.darwinModules.home-manager {
        #   nixpkgs = { config.allowUnfree = true; };

        #   home-manager.useGlobalPkgs = true;
        #   home-manager.useUserPackages = true;
        #   home-manager.users.${username} = import ./home.nix;
        # }
      ];
      specialArgs = { inherit self inputs; };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations.fourteen.pkgs;

    homeConfigurations.context = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { inherit system; };
      modules = [
        ./home.nix
        {
          home.username = username;
          home.homeDirectory = "/Users/context";
        }
      ];
    };
  };
}
