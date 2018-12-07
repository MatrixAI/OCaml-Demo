{
  pkgs ? import ./pkgs.nix,
  ocamlPath ? "ocamlPackages_4_07"
}:
  with pkgs;
  let
    ocamlPackages = lib.getAttrFromPath (lib.splitString "." ocamlPath) ocaml-ng;
    drv = (import ./default.nix { inherit pkgs ocamlPath; });
  in
    drv.overrideAttrs (attrs: {
      src = null;
      buildInputs =
        attrs.buildInputs ++
        (with ocamlPackages; [ opam utop ]);
      shellHook = ''
        echo 'Entering ${attrs.name}'
        set -v

        set +v
      '';
    })
