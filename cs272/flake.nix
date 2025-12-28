{
  description = "CS272 instructor toolchain (Go + sqlite + autograder)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            go
            sqlite

            # CGO / native build support (common for sqlite Go drivers)
            gcc
            pkg-config
          ];

          # Make sure Go picks up correct C toolchain settings inside nix shell
          env = {
            CGO_ENABLED = "1";
          };

        };
      });
}
