{
  pkgs ? import ./pkgs.nix,
  ocamlPath ? "ocamlPackages_4_07"
}:
  with pkgs;
  let
    ocamlPackages = lib.getAttrFromPath (lib.splitString "." ocamlPath) ocaml-ng;
    # we use ocamlPackages.ocaml
    # ocamlPackages.... etc
    # but buildOcaml isn't there though...
    # so buildOcaml doesn't use this new ocaml-ng
  in
    buildOcaml {
      name = "OCaml-Demo";
      version = "0.0.1";
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
    }
