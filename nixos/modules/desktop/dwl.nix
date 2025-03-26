{
  pkgs,
  lib,
  config,
  ...
}: let
  dwlbar-cmd = "dwlb -font \"MonoLisa Nerd Font:size=10\"";
in {
  options = {
    dwl-desktop.enable =
      lib.mkEnableOption "Enable the DWL tiling window manager";
  };

  config = lib.mkIf config.dwl-desktop.enable {
    environment.systemPackages = with pkgs; [
      dwl

      slurp
      grim
      wl-clipboard
      brightnessctl
      wbg
      somebar
    ];

    security.polkit.enable = true;

    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.dwl}/bin/dwl -s '${dwlbar-cmd}'";
          user = "alistair";
        };
        default_session = initial_session;
      };
    };
  };
}
