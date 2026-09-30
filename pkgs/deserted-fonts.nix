{
  stdenv,
  fetchFromGitHub,
  python314,
  imagemagick,
  ttfautohint,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "deserted-fonts";

  srcs = [
    (fetchFromGitHub {
      owner = "wooosh";
      repo = "deserted-font";
      rev = "c356064b7b6973d34a2518d5ff364e58e19e7be1";
      hash = "sha256-mTgIZetgbKiXu287pxbyfKP4+fiuOD8HP7tM/uK+Cug=";
      name = "deserted-font";
    })
    (fetchFromGitHub {
      owner = "Tblue";
      repo = "mkttf";
      rev = "f54356cd481b9f2c6b52c9cd010cfe3e38924e6a";
      hash = "sha256-LyySOOcRqNxYi5yoUtN8/CvJOBboDnMPT8HrDzQoMB4=";
      name = "mkttf";
    })
  ];

  sourceRoot = "deserted-font";

  nativeBuildInputs = [
    (python314.withPackages (ps: [ ps.fontforge ]))
    imagemagick
  ];

  installPhase = ''
    mkdir -p $out/share/fonts
    chmod +x ../mkttf/mkttf.py
    find build -type f -name "*.bdf" | xargs -I {} python ../mkttf/mkttf.py {}
    install *.ttf $out/share/fonts
  '';
})
