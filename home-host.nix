{ pkgs, ... }:

{
  imports = [ ./home.nix ];

  # Example user configuration that should not be present in container.
  programs.git = {
    enable = true;
    userName = "My User";
  };

  programs.ssh = {
    enable = true;

    matchBlocks = {
      hostThatShouldNotBeKnownByContainer = {
        user = "secret";
        hostname = "doNotExpose";
        port = 2020;
      };
    };
  };
}
