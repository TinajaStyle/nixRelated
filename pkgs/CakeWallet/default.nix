let
  pkgs = import <nixpkgs> { };
in
{
  cakeWallet = pkgs.callPackage ./cakeWallet.nix { };
}
