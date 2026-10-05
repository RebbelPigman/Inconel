{
  description = "Inconel";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAll = f: nixpkgs.lib.genAttrs systems (system: f (import nixpkgs { inherit system; }));
    in {
      packages = forAll (pkgs:
        let
          python = pkgs.python3.withPackages (ps: [ ps.pygobject3 ]);
        in {
          default = pkgs.stdenv.mkDerivation {
            pname = "inconel";
            version = "0.0.1";
            src = pkgs.lib.cleanSource ./.;
            nativeBuildInputs = [
              pkgs.wrapGAppsHook4
              pkgs.gobject-introspection
              pkgs.makeWrapper
            ];
            buildInputs = [
              python
              pkgs.gtk4
              pkgs.libadwaita
              pkgs.glib
            ];
            dontWrapGApps = true;
            installPhase = ''
              runHook preInstall
              mkdir -p $out/share/inconel
              cp app.py $out/share/inconel/app.py
              runHook postInstall
            '';
            preFixup = ''
              makeWrapper ${python}/bin/python3 $out/bin/inconel \
                "''${gappsWrapperArgs[@]}" \
                --add-flags "$out/share/inconel/app.py"
            '';
            meta = {
              description = "Inconel";
              mainProgram = "inconel";
            };
          };
        });

      apps = forAll (pkgs: {
        default = {
          type = "app";
          program = "${self.packages.${pkgs.system}.default}/bin/inconel";
        };
      });

      devShells = forAll (pkgs:
        let
          python = pkgs.python3.withPackages (ps: [ ps.pygobject3 ]);
        in {
          default = pkgs.mkShell {
            packages = [
              python
              pkgs.gtk4
              pkgs.libadwaita
              pkgs.gobject-introspection
            ];
          };
        });
    };
}
