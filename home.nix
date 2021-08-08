{ pkgs, ... }:

{
  programs.bash.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = {
      # Use Alt/Meta instead of Super to decrease chance of conflict with host key mappings.
      modifier = "Mod1";

      # And use terminal with some sane defaults.
      terminal = "alacritty";
    };
  };

  home.packages = with pkgs; [
    alacritty
  ];

  gtk.enable = true;
}
