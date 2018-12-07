{
  pkgs ? import ./pkgs.nix,
  ocamlPath ? "ocamlPackages_4_07"
}:
  with pkgs;
  let
    ocamlPackagess = lib.getAttrFromPath (lib.splitString "." ocamlPath) ocaml-ng;
  in
    stdenv.mkDerivation {
      name = "OCaml-Demo";
      version = "0.0.1";
      buildInputs = with ocamlPackages; [ ocaml findlib ocamlbuild camlp4 ];
      src = lib.cleanSourceWith {
        filter = (path: type:
          ! (builtins.any
            (r: (builtins.match r (builtins.baseNameOf path)) != null)
            [
              "\.env"
            ])
        );
        src = lib.cleanSource attrs.src;
      };
      createFindlibDestdir = false;
      dontStrip = true;
    }
