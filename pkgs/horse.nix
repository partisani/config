{
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  lib
}:

buildGoModule {
  name = "horse";

  src = fetchFromGitHub {
    owner = "if-not-nil";
    repo = "horse";
    rev = "26f611a6ee0c3d1c64d6b0a620cd592b8059e95a";
    hash = "sha256-ABkMhAPqPeMGEqJ6xMjbGIJq5OITV2A66px2B8CB/8U=";
  };

  vendorHash = "sha256-Cn1prgHQ8046ziWOBXmX2PlXRDYX8DqwcgYXBz2JPPc=";
}
