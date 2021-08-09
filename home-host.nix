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

  systemd.user.services.polkit-agent = {
    Unit = {
      Description = "Runs polkit authentication agent";
      PartOf = "graphical-session.target";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      RestartSec = 5;
      Restart = "always";
    };
  };
}
