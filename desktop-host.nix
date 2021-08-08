{ pkgs, ... }:

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
}
