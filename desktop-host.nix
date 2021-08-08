{ pkgs, lib, ... }:

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

  containers.cliExample = let
    userName = "myuser";
  in {
    config = {
      imports = [
        (import "${home-manager}/nixos")
        ./desktop.nix
      ];

      users.users."${userName}".extraGroups = lib.mkForce [];

      environment.systemPackages = with pkgs; [ vim ];

      home-manager = {
        useGlobalPkgs = true;
        users.myuser = {
          imports = [ ./home.nix ];
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
