{ pkgs, ... }:

{
  users.users.myuser = {
    uid = 1000;
    isNormalUser = true;
    initialPassword = "secret";
    extraGroups = [ "wheel" ];
  };

  fonts.fonts = with pkgs; [
    dejavu_fonts  # Default font used by Alacritty.
  ];
}
