{
  description = "Jekyll development environment for CS315 course site";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            ruby_3_3
            bundler
            # Native dependencies for gems
            pkg-config
            libffi
            zlib
            # For sassc gem
            libsass
          ];

          shellHook = ''
            export GEM_HOME="$PWD/.gems"
            export PATH="$GEM_HOME/bin:$PATH"
            export BUNDLE_PATH="$GEM_HOME"

            echo "Jekyll development environment"
            echo "Run 'bundle install' to install gems, then 'j' to start the server"
          '';
        };
      }
    );
}
