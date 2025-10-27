# nix run nix-darwin -- --flake .
{
  description = "Personal Operating Environment";

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
    lib = nixpkgs.lib;

    importNixFiles = dir:
      let
        files = builtins.readDir dir;
        nixFiles = lib.filterAttrs (name: type:
          type == "regular" && lib.hasSuffix ".nix" name
        ) files;
      in
        lib.mapAttrs' (name: _:
          lib.nameValuePair
            (lib.removeSuffix ".nix" name)
            (import (dir + "/${name}"))
        ) nixFiles;
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

    homeModules = importNixFiles ./home-manager;

    # personal
    homeConfigurations."context" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { inherit system; };
      extraSpecialArgs = { inherit inputs; };
      modules = [
        ./home.nix
        hosts/fourteen/home.nix
        {
          home.username = "context";
          home.homeDirectory = "/Users/context";
        }
      ];
    };
  };
}
