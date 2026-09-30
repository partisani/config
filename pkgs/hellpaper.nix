{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  raylib,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "hellpaper";
  src = fetchFromGitHub {
    owner = "danihek";
    repo = "hellpaper";
    rev = "d8af3ff83b567869c11ba31e39c3c10e4bee53e6";
    hash = "sha256-1vX1hC4RVNmmIn0j7giAqrzGV12zk2FMesUOX/iI1eY=";
  };
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ raylib ];
  postPatch = ''
    substituteInPlace hellpaper.c --replace "entry->d_type != DT_REG" \
      "entry->d_type != DT_REG && entry->d_type != DT_LNK"
  '';
  installPhase = ''
    install -Dm755 hellpaper -t $out/bin
  '';
  meta = {
    homepage = "https://github.com/danihek/hellpaper";
    description = "Wallpaper picker for Linux";
    longDescription = ''
      Wallpaper picker for Linux
    '';
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ danihek ];
    mainProgram = "hellpaper";
  };
})
