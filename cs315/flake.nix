{
  description = "CS315 toolchain (C with gcc/gdb/make + Digital logic simulator)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Fetch and wrap the Digital logic simulator
        digital = pkgs.stdenv.mkDerivation rec {
          pname = "digital";
          version = "0.31";

          src = pkgs.fetchurl {
            url = "https://github.com/hneemann/Digital/releases/download/v${version}/Digital.zip";
            sha256 = "sha256-EvAUyLmRQFVPj3Rk68dxu+PeavOcg8IEY0kry4kq/Gk=";
          };

          nativeBuildInputs = [ pkgs.unzip pkgs.makeWrapper ];
          buildInputs = [ pkgs.jre ];

          unpackPhase = ''
            unzip $src
          '';

          installPhase = ''
            mkdir -p $out/share/digital $out/bin
            cp -r Digital/* $out/share/digital/
            makeWrapper ${pkgs.jre}/bin/java $out/bin/digital \
              --add-flags "-jar $out/share/digital/Digital.jar"
          '';
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # C toolchain
            gcc
            gdb
            gnumake

            # Java runtime for Digital
            jre

            # Digital logic simulator
            digital
          ];

          shellHook = ''
            if [ ! -d "$HOME/courses/cs315/cs315_dev" ]; then
              echo "Cloning cs315_dev repository..."
              git clone git@github.com:/gdbenson/cs315_dev.git "$HOME/courses/cs315/cs315_dev"
            fi
            echo "CS315 dev environment loaded"
            echo "  - Run 'digital' to launch the Digital logic simulator"
          '';
        };
      });
}
