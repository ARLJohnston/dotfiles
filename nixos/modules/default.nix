{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware/pipewire.nix
    ./hardware/boot.nix
    ./hardware/power-saving.nix
    ./desktop/dwl.nix
    ./editors/git.nix
  ];
}
