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
      specialArgs = { inherit self inputs; };
      modules = [
        nix-darwin/configuration.nix
        hosts/fourteen/darwin.nix
      ];
    };

    darwinConfigurations.shogun = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit self inputs; };
      modules = [
        nix-darwin/configuration.nix
        hosts/shogun/darwin.nix
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations.fourteen.pkgs;

    homeConfigurations."context@fourteen" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { inherit system; };
      modules = [
        ./home.nix
        hosts/fourteen/home.nix
        {
          home.username = username;
          home.homeDirectory = "/Users/context";
        }
      ];
    };

    homeConfigurations."context@shogun" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { inherit system; };
      modules = [
        ./home.nix
        hosts/shogun/home.nix
        {
          home.username = username;
          home.homeDirectory = "/Users/context";
        }
      ];
    };
  };
}
