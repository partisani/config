{
  description = "local packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system} = {
        hellpaper = pkgs.callPackage ./hellpaper.nix { };
        somedl = pkgs.callPackage ./somedl.nix { };
        deserted-fonts = pkgs.callPackage ./deserted-fonts.nix { };
        ioskeley = pkgs.callPackage ./ioskeley.nix { };
      };

      nixosModules.somedl =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          cfg = config.services.somedl;
          appPkg = self.packages.${system}.somedl;
        in
        {
          options.services.somedl = {
            enable = lib.mkEnableOption "Whether to enable SomeDL.";
            user = lib.mkOption {
              type = lib.types.str;
              default = "somedl";
              description = "User account under which SomeDL runs.";
            };
          };

          config = lib.mkIf cfg.enable {
            environment.systemPackages = [
              appPkg
              pkgs.ffmpeg
            ];

            systemd.services.somedl = {
              description = "SomeDL web ui daemon";
              after = [ "network.target" ];
              wantedBy = [ "multi-user.target" ];

              serviceConfig = {
                ExecStart = "${appPkg}/bin/somedl web --no-browser";
                User = cfg.user;
                Restart = "on-failure";

                ProtectSystem = "strict";
                PrivateTmp = true;
              };
            };
          };
        };
    };
}
