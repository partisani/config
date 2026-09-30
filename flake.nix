{
  description = "system";

  inputs = {
    # Official package repositories and organization tools
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-next.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Local packages
    local-pkgs = {
      url = ./pkgs;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # External packages
    kew = {
      url = "github:ravachol/kew";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.t460 = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hardware-configuration.nix
          inputs.local-pkgs.nixosModules.somedl
          home-manager.nixosModules.home-manager
          (
            # conf #
            {
              pkgs,
              pkgs-next,
              config,
              inputs,
              ...
            }:

            {
              nix.settings.auto-optimise-store = true;

              services.displayManager.gdm.enable = true;
              services.desktopManager.gnome.enable = true;

              services.gnome.gnome-keyring.enable = true;
              environment.systemPackages = with pkgs; [
                tree
                unrar-free
                wl-clipboard
                wlr-randr
                proton-vpn-cli
                ripgrep
                git
                colorpanes
                ufetch
                nixfmt
                jq
                gh
                pkgs-next.devenv
              ];

              programs.firefox.enable = true;

              services.sshd.enable = true;
              services.flatpak.enable = true;

              services.zerotierone.enable = true;
              services.zerotierone.port = 9994;

              security.polkit.enable = true;

              users.users.partisani = {
                isNormalUser = true;
                description = "partisani";
                extraGroups = [
                  "networkmanager"
                  "wheel"
                  "input"
                  "gamemode"
                ];
              };

              home-manager.backupFileExtension = "bak";
              home-manager.users.partisani = {
                xdg.enable = true;
                home.stateVersion = "25.11"; # Did you read the comment?

                xdg.userDirs.extraConfig = {
                  DESKTOP = "$HOME/files/desktop";
                  DOWNLOAD = "$HOME/files/downloads";
                  TEMPLATES = "$HOME/files/templates";
                  PUBLICSHARE = "$HOME/files/public";
                  DOCUMENTS = "$HOME/files/documents";
                  MUSIC = "$HOME/files/music";
                  PICTURES = "$HOME/files/pictures";
                  VIDEOS = "$HOME/files/videos";
                  PROJECTS = "$HOME/files/projects";
                };
              };

              system.stateVersion = "25.11"; # Did you read the comment? (2x)
            }
          )
          (
            # apps #
            { pkgs, ... }:
            {
              programs.firefox.enable = true;
              
              environment.systemPackages = with pkgs; [
                alacritty
                
                kakoune
                kakoune-lsp
                
                remmina
                
                vesktop
              ];
            }
          )
          (
            # fonts #
            { pkgs, local-pkgs, ... }:
            {
              environment.systemPackages = [ pkgs.font-manager ];
              fonts.packages = with pkgs; [
                # why
                # the
                # swear words go here
                # are
                # font
                # names
                # allll
                # extremely
                # inconsistent
                # with each other?

                ttf-envy-code-r
                hermit
                sudo-font
                _3270font
                spleen
                nanum-gothic-coding
                ocr-a
                monaspace
                commit-mono
                _0xproto
                jetbrains-mono
                agave
                nerd-fonts.space-mono # no default version available
                maple-mono.truetype
                mplus-outline-fonts.githubRelease
                victor-mono
                local-pkgs.deserted-fonts
                local-pkgs.ioskeley
                # external:
                # berkeley mono
                # typestar ocr
              ];

            }
          )
          (
            # dev #
            { pkgs, ... }:
            {
              environment.systemPackages = with pkgs; [
                # C
                gcc
                clang-tools
                just
                gdb
                valgrind

                # Go
                go
                gopls

                # Odin
                odin
                ols

                # Lua
                pkgs.lua-language-server
                (pkgs.lua5_4.withPackages (
                  l: with l; [
                    lua
                    luautf8
                    inspect
                    readline
                    fennel
                    json
                    tomlua
                    cjson
                    tomlua
                    luaposix
                    lyaml
                  ]
                ))

                # Web
                vscode-langservers-extracted
                typescript-language-server

                # Rust
                rustup
              ];
            }
          )
          (
            # music #
            {
              pkgs,
              pkgs-next,
              inputs,
              ...
            }:

            {
              environment.systemPackages = with pkgs; [
                qmmp
                inputs.kew.packages.${pkgs.stdenv.hostPlatform.system}.default

                pkgs-next.yt-dlp
                ffmpeg
                kid3
                kid3-cli
                moreutils
                imagemagick
              ];

              services.syncthing = {
                enable = true;
                user = "partisani";
                dataDir = "/home/partisani";
                openDefaultPorts = true;
              };
            }
          )
          (
            # games #
            { pkgs, ... }:

            {
              environment.systemPackages = with pkgs; [
                # minecraft
                prismlauncher
                lunar-client
                temurin-bin-8
                temurin-bin-17
                temurin-bin-21

                # native games
                #mindustry
                vkquake

                # guess why?
                qbittorrent
              ];

              programs.steam = {
                enable = true;
                remotePlay.openFirewall = true;
                dedicatedServer.openFirewall = true;
                extraCompatPackages = with pkgs; [ proton-ge-bin ];
              };

              programs.gamemode.enable = true;
              programs.gamescope.enable = true;
            }

          )
          (
            # system #
            {
              config,
              pkgs,
              inputs,
              ...
            }:

            {
              nix.settings.experimental-features = [
                "nix-command"
                "flakes"
                "pipe-operators"
              ];

              nixpkgs.config.allowUnfree = true;

              boot = {
                loader = {
                  systemd-boot.enable = true;
                  efi.canTouchEfiVariables = true;
                };

                kernelPackages = pkgs.linuxPackages_zen;
              };

              networking = {
                hostName = "t460";
                networkmanager.enable = true;
                firewall.checkReversePath = false;
              };

              time.timeZone = "America/Bahia";
              i18n.defaultLocale = "en_US.UTF-8";
              i18n.extraLocaleSettings = {
                LC_ADDRESS = "pt_BR.UTF-8";
                LC_IDENTIFICATION = "pt_BR.UTF-8";
                LC_MEASUREMENT = "pt_BR.UTF-8";
                LC_MONETARY = "pt_BR.UTF-8";
                LC_NAME = "pt_BR.UTF-8";
                LC_NUMERIC = "pt_BR.UTF-8";
                LC_PAPER = "pt_BR.UTF-8";
                LC_TELEPHONE = "pt_BR.UTF-8";
                LC_TIME = "pt_BR.UTF-8";
              };

              services.xserver.xkb = {
                layout = "br";
                variant = "thinkpad";
              };

              console.keyMap = "br-abnt2";

              services.printing.enable = true;

              services.pulseaudio.enable = false;
              security.rtkit.enable = true;
              services.pipewire = {
                enable = true;
                alsa.enable = true;
                alsa.support32Bit = true;
                pulse.enable = true;
                # Bluetooth?
                #wireplumber.extraConfig."10-bluez" = {
                #    "monitor.bluez.properties" = {
                #      "bluez5.enable-sbc-xq" = true;
                #      "bluez5.enable-msbc" = true;
                #      "bluez5.enable-hw-volume" = true;
                #      "bluez5.roles" = [
                #        "hsp_hs"
                #        "hsp_ag"
                #        "hfp_hf"
                #        "hfp_ag"
                #      ];
                #    };
                #};
                # If you want to use JACK applications, uncomment this
                #jack.enable = true;
              };

              environment.systemPackages = with pkgs; [
                playerctl
              ];

              # Some programs need SUID wrappers, can be configured further or are
              # started in user sessions.
              # programs.mtr.enable = true;
              # programs.gnupg.agent = {
              #     enable = true;
              #     enableSSHSupport = true;
              # };

              # List services that you want to enable:

              # Enable the OpenSSH daemon.
              # services.openssh.enable = true;

              # Open ports in the firewall.
              # networking.firewall.allowedTCPPorts = [ ... ];
              # networking.firewall.allowedUDPPorts = [ ... ];
            }
          )
          (
            # irc #
            { pkgs, ... }:

            {
              environment.systemPackages = with pkgs; [ catgirl ];
              home-manager.users.partisani.xdg.configFile."catgirl/ionet".text = ''
                host = irc.ionic1k.net
              '';
            }
          )
        ];
        specialArgs = {
          inherit inputs;
          pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${system};
          pkgs-next = inputs.nixpkgs-next.legacyPackages.${system};
          local-pkgs = inputs.local-pkgs.packages.${system};
        };
      };
    };
}
