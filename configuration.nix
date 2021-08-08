{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./desktop-host.nix
  ];

  networking.hostId = "12345678";
  networking.hostName = "isolationExample";

  system.stateVersion = "21.05";
}
