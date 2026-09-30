{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "somedl";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chemistryGull";
    repo = "SomeDL";
    rev = "v${version}";
    hash = "sha256-yedy5beiMuD4ZDuKL8tguGx2MyN3rdXsirQgxF3rBSU=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    requests
    pyyaml
    ytmusicapi
    mutagen
    yt-dlp
    tomlkit
    rich
    flask
    waitress
  ];

  meta = with lib; {
    description = "A command line utility to download songs from youtube with metadata from different APIs without the need for API-tokens or login.";
    homepage = "https://github.com/chemistryGull/SomeDL";
    license = licenses.gpl3;
    mainProgram = "somedl";
  };
}
