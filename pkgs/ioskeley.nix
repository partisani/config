{
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ioskeley";
  version = "2.0.0";

  src = fetchzip {
    url = "https://github.com/ahatem/IoskeleyMono/releases/download/v${finalAttrs.version}/IoskeleyMono.zip";
    hash = "sha256-EJDlA18XZPq7vhtpw/74n5s1NmTy0/DLu2oYB7OuvbA=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -r $src/* $out/share/fonts
  '';
})
