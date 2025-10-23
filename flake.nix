# nix run nix-darwin -- --flake .
{
  description = "My Personal Operational Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, home-manager, nix-darwin, nixvim, nixpkgs }:
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

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations.fourteen.pkgs;

    homeConfigurations."context@fourteen" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { inherit system; };
      extraSpecialArgs = { inherit inputs; };
      modules = [
        ./home.nix
        hosts/fourteen/home.nix
        {
          home.username = username;
          home.homeDirectory = "/Users/context";
        }
      ];
    };
  };
}
