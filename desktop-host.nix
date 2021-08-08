{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    ref = "release-21.05";
    rev = "35a24648d155843a4d162de98c17b1afd5db51e4";
  };
in {
  imports = [
    (import "${home-manager}/nixos")
    ./desktop.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    users.myuser = {
      imports = [ ./home-host.nix ];
    };
  };

  containers.graphicalExample = let
    hostCfg = config;
    userName = "myuser";
    userUid = hostCfg.users.users."${userName}".uid;
  in {
    bindMounts = {
      waylandDisplay = rec {
        hostPath = "/run/user/${toString userUid}";
        mountPoint = hostPath;
      };
      x11Display = rec {
        hostPath = "/tmp/.X11-unix";
        mountPoint = hostPath;
        isReadOnly = true;
      };
    };

    config = {
      imports = [
        (import "${home-manager}/nixos")
        ./desktop.nix
      ];

      hardware.opengl = {
        enable = true;
        extraPackages = hostCfg.hardware.opengl.extraPackages;
      };

      users.users."${userName}".extraGroups = lib.mkForce [];

      environment.systemPackages = with pkgs; [
        vim
        jetbrains.idea-community
      ];

      home-manager = {
        useGlobalPkgs = true;
        users.myuser = {
          imports = [ ./home.nix ];

          home.sessionVariables = {
            WAYLAND_DISPLAY                     = "wayland-1";
            QT_QPA_PLATFORM                     = "wayland";
            QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
            SDL_VIDEODRIVER                     = "wayland";
            CLUTTER_BACKEND                     = "wayland";
            MOZ_ENABLE_WAYLAND                  = "1";
            _JAVA_AWT_WM_NONREPARENTING         = "1";
            _JAVA_OPTIONS                       = "-Dawt.useSystemAAFontSettings=lcd";
            XDG_RUNTIME_DIR                     = "/run/user/${toString userUid}";
            DISPLAY                             = ":0";
          };
        };
      };

      systemd.services.fix-nix-dirs = let
        profileDir = "/nix/var/nix/profiles/per-user/${userName}";
        gcrootsDir = "/nix/var/nix/gcroots/per-user/${userName}";
      in {
        script = ''
          #!${pkgs.stdenv.shell}
          set -euo pipefail

          mkdir -p ${profileDir} ${gcrootsDir}
          chown ${userName}:root ${profileDir} ${gcrootsDir}
        '';
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
        };
      };
    };
  };
}
