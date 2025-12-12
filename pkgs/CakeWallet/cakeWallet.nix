{
  stdenv,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  util-linux,
  libgcrypt,
  systemd,
  libgpg-error,
  xz,
  lz4,
  libepoxy,
  fontconfig,
  harfbuzz,
  gtk3,
  pango,
  cairo,
  atk,
  gdk-pixbuf,
  at-spi2-atk,
}:

stdenv.mkDerivation rec {
  pname = "CakeWallet";
  version = "5.5.2";

  src = builtins.fetchTarball {
    url = "https://github.com/cake-tech/cake_wallet/releases/download/v${version}/Cake_Wallet_v${version}_Linux.tar.xz";
    sha256 = "132y3bck17mniryf45qk7qgsbll0aa5afzrm8z6xpjlrl3n1fv90";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    util-linux
    libgcrypt
    systemd
    libgpg-error
    xz
    lz4
    libepoxy
    fontconfig
    harfbuzz
    gtk3
    pango
    cairo
    atk
    gdk-pixbuf
    at-spi2-atk
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "cake_wallet";
      desktopName = "Cake Wallet";
      exec = "cake_wallet";
      comment = "A noncustodial multi-currency wallet";
      categories = [
        "Office"
        "Finance"
      ];
      terminal = false;
      icon = "cake_wallet";
    })
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir $out/app
    cp -ra $src/data $src/lib $out/app
    install -m755 -D cake_wallet $out/app/cake_wallet
    ln -sf $out/app/cake_wallet $out/bin/cake_wallet
    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/share/icons
    install -m644 $src/data/flutter_assets/assets/images/cakewallet_logo.png $out/share/icons/cake_wallet.png
  '';
}
