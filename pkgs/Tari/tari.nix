{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  udev,
}:

stdenv.mkDerivation rec {
  pname = "minotari-cli";
  version = "5.1.0";
  commitHead = "633e5ae";

  src = fetchzip {
    url =
      "https://github.com/tari-project/tari/releases/download/v${version}"
      + "/tari_suite-${version}-mainnet-${commitHead}-linux-x86_64.zip";
    hash = "sha256-v8hbZQ1qYaN64TzsTFtpGsGWQGRjdTEuhZ4EM/aVPaY=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    udev
  ];

  preInstall = ''
    sha256sum -c tari_suite-${version}-mainnet-${commitHead}-linux-x86_64.sha256
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 -D minotari_console_wallet $out/bin/minotari_console_wallet
    install -m755 -D minotari_merge_mining_proxy $out/bin/minotari_merge_mining_proxy
    install -m755 -D minotari_miner $out/bin/minotari_miner
    install -m755 -D minotari_node $out/bin/minotari_node
    install -m755 -D minotari_node-metrics $out/bin/minotari_node-metrics
    runHook postInstall
  '';
}
