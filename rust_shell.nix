let
  rustVersion = "1.91.1";
  rust_overlay = import (
    builtins.fetchGit {
      url = "https://github.com/oxalica/rust-overlay.git";
      ref = "master";
      rev = "93316876c2229460a5d6f5f052766cc4cef538ce";
    }
  );
  pkgs = import <nixpkgs> {
    overlays = [
      rust_overlay
      (_: prev: {
        my-rust = prev.rust-bin.stable.${rustVersion}.default.override {
          extensions = [
            "rust-src"
            "rust-analyzer"
          ];
          targets = [
            "x86_64-unknown-linux-gnu"
            "x86_64-unknown-linux-musl"
          ];
        };
      })
    ];

  };
in
pkgs.mkShell {
  strictDeps = true;
  # compilers & linkers & dependecy finding programs
  nativeBuildInputs = [
    pkgs.my-rust
    pkgs.pkg-config
  ];
  # libraries
  buildInputs = [
    pkgs.openssl
  ];

  RUST_BACKTRACE = 1;
}
