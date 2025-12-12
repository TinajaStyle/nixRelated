let
  pkgs = import <nixpkgs> { };
in
{
  tari = pkgs.callPackage ./tari.nix { };
}

