{ pkgs, ... }:

{
  # In real configuration use file generated by nixos-generate-config.
  virtualisation = {
    writableStoreUseTmpfs = false;

    memorySize = "2g";
    qemu = {
      options = [
        "-vga virtio"
        "-display gtk,gl=on"
      ];
    };
  };

  hardware.opengl = {
    enable = true;
  };
}
