{
  pkgs ? import ./pkgs.nix,
  ocamlPath ? "ocamlPackages_4_07"
}:
  with pkgs;
  let
    ocamlPackages = lib.getAttrFromPath (lib.splitString "." ocamlPath) ocaml-ng;
  in
    ocamlPackages.buildDunePackage {
      pname = "ocaml-demo";
      version = "0.0.1";
      buildInputs = with ocamlPackages; [
        core
      ];
      src = lib.cleanSourceWith {
        filter = (path: type:
          ! (builtins.any
            (r: (builtins.match r (builtins.baseNameOf path)) != null)
            [
              "\.env"
            ])
        );
        src = lib.cleanSource ./.;
      };
    }
