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
    rev = "1f9aa04f6482a297521a83e4042a888ed87cea35";
    hash = "sha256-6ApGmTVQNpArs7zc3UI1DsKKUmJPTGt/6mZp/ihdU5A=";
  };

  vendorHash = "sha256-Cn1prgHQ8046ziWOBXmX2PlXRDYX8DqwcgYXBz2JPPc=";
}
