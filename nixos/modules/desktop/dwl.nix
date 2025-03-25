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

    nixpkgs.overlays = [
      (self: super: {
        dwl = super.dwl.overrideAttrs (oldAttrs: rec {
          configFile =
            super.writeText "config.def.h"
            (builtins.readFile (pkgs.substituteAll {src = ./config.h;}));
          patches = [
            (pkgs.fetchpatch {
              url = "https://codeberg.org/dwl/dwl-patches/raw/branch/main/patches/autostart/autostart.patch";
              hash = "sha256-OTQ/0O62wG3OKCzA2FGyFpgbNup5Xmia1techndd4I8=";
            })
          ];
          postPatch =
            oldAttrs.postPatch
            or ""
            + ''

              echo 'Using own config file...'
               cp ${configFile} config.def.h'';
        });
      })
    ];
  };
}
