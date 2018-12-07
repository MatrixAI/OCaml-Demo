{
  pkgs ? import ./pkgs.nix,
  ocamlPath ? "ocamlPackages_4_07"
}:
  with pkgs;
  let
    drv = (import ./default.nix { inherit pkgs ocamlPath; });
  in
    drv.overrideAttrs (attrs: {
      src = null;
      shellHook = ''
        echo 'Entering ${attrs.name}'
        set -v

        set +v
      '';
    })
