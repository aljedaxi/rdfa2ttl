{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { nixpkgs, self, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let pkgs = nixpkgs.legacyPackages.${system}; in
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [gnumake nodejs];
        shellHook = ''exec zsh'';
      };
      packages.default = pkgs.buildNpmPackage {
        dontNpmBuild = true;
        name = "rdfa2ttl";
        npmDepsHash = "sha256-sdcg9aiffN6afaTJgKXDlCvO66Hh0gKEz1Tv0fyVDwU=";
        src = ./.;
      };
      apps.default = {
	      type = "app";
	      program = "${self.packages."${system}".default}/lib/node_modules/rdfa2ttl/main.js";
      };
    });
}
