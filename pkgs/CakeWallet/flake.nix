{
  description = "Cake Wallet";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.pkg = pkgs.callPackage ./cakeWallet.nix { };
      defaultPackage.${system} = self.packages.${system}.pkg;
    };
}
