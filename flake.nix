{
  description = "OpenWhip desktop app for Linux";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      packageInfo = builtins.fromJSON (builtins.readFile ./package.json);
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          desktopItem = pkgs.makeDesktopItem {
            name = "openwhip";
            desktopName = "OpenWhip";
            comment = packageInfo.description;
            exec = "openwhip";
            icon = "openwhip";
            categories = [ "Utility" ];
            terminal = false;
          };
          openwhip = pkgs.stdenvNoCC.mkDerivation {
            pname = packageInfo.name;
            version = packageInfo.version;

            src = pkgs.lib.fileset.toSource {
              root = ./.;
              fileset = pkgs.lib.fileset.unions [
                ./package.json
                ./main.js
                ./preload.js
                ./overlay.html
                ./icon
                ./sounds
              ];
            };

            nativeBuildInputs = [ pkgs.makeWrapper pkgs.copyDesktopItems ];
            desktopItems = [ desktopItem ];
            dontBuild = true;

            # Linux uses only Electron APIs; koffi is required on Windows only.
            installPhase = ''
              runHook preInstall
              mkdir -p "$out/share/openwhip" "$out/bin"
              cp -r package.json main.js preload.js overlay.html icon sounds "$out/share/openwhip/"
              install -Dm644 icon/Template.png "$out/share/icons/hicolor/512x512/apps/openwhip.png"

              makeWrapper ${pkgs.lib.getExe pkgs.electron} "$out/bin/openwhip" \
                --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.xdotool ]} \
                --add-flags "--ozone-platform=x11 $out/share/openwhip"

              cat > "$out/bin/badclaude" <<EOF
              #!${pkgs.runtimeShell}
              echo '[DEPRECATED] "badclaude" has been renamed to "openwhip".' >&2
              exec "$out/bin/openwhip" "\$@"
              EOF
              chmod +x "$out/bin/badclaude"
              runHook postInstall
            '';

            meta = {
              description = packageInfo.description;
              homepage = packageInfo.homepage;
              license = pkgs.lib.licenses.mit;
              platforms = systems;
              mainProgram = "openwhip";
            };
          };
        in
        {
          inherit openwhip;
          default = openwhip;
        });

      apps = forAllSystems (system:
        let
          openwhip = {
            type = "app";
            program = "${self.packages.${system}.openwhip}/bin/openwhip";
            meta.description = packageInfo.description;
          };
        in
        {
          inherit openwhip;
          default = openwhip;
        });

      devShells = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system; };
        in {
          default = pkgs.mkShellNoCC {
            packages = [ pkgs.nodejs pkgs.electron pkgs.xdotool ];
          };
        });
    };
}
