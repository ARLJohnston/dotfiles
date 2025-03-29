{
  pkgs,
  config,
  inputs,
  nix-colors,
  ...
}: {
  home.file."./.librewolf".source =
    config.lib.file.mkOutOfStoreSymlink /home/alistair/.mozilla/firefox;

  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;

    profiles = {
      user = {
        isDefault = true;

        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          keepassxc-browser
          auto-tab-discard
          sidebery
          gruvbox-dark-theme
          consent-o-matic
          ublacklist
        ];

        search = {
          default = "ddg";
          force = true;
        };

        search.engines = {
          "Scholar" = {
            urls = [
              {
                template = "https://scholar.google.com/scholar?q={searchTerms}";
              }
            ];
            definedAliases = ["@s"];
          };

          "Go" = {
            urls = [
              {
                template = "https://pkg.go.dev/search?q={searchTerms}";
              }
            ];
            definedAliases = ["@g"];
            icon = builtins.fetchurl {
              url = "https://pkg.go.dev/static/shared/icon/favicon.ico";
              sha256 = "sha256:04pwfxbifdk2jf58q3r3dcpla4ngj88m6vy1xq2x4dblklk826fc";
            };
          };

          "Kubernetes" = {
            urls = [
              {
                template = "https://kubernetes.io/search/?q={searchTerms}";
              }
            ];
            definedAliases = ["@k"];
            icon = builtins.fetchurl {
              url = "https://avatars.githubusercontent.com/u/13629408";
              sha256 = "sha256:0sa78330l1nqrz1kg07gxchnl3kk85jz1l4pzhf3klnp0ahspiap";
            };
          };

          "Home Manager" = {
            urls = [
              {
                template = "https://home-manager-options.extranix.com/";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = builtins.fetchurl {
              url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/33856d7837cb8ba76c4fc9e26f91a659066ee31f/logo/nix-snowflake-colours.svg";
              sha256 = "sha256:1cifj774r4z4m856fva1mamnpnhsjl44kw3asklrc57824f5lyz3";
            };
            definedAliases = ["@hm"];
          };
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = builtins.fetchurl {
              url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/33856d7837cb8ba76c4fc9e26f91a659066ee31f/logo/nix-snowflake-colours.svg";
              sha256 = "sha256:1cifj774r4z4m856fva1mamnpnhsjl44kw3asklrc57824f5lyz3";
            };

            definedAliases = ["@np"];
          };
        };

        # https://old.reddit.com/r/FirefoxCSS/comments/1hicl2l/need_help_to_adjust_with_the_recent_url_bar/m2xzq4h/
        userChrome = ''
          :root {
          --arrowpanel-border-radius: 0px!important;
          }
          #TabsToolbar{
          display: none !important;
          }
          #nav-bar.browser-toolbar {
          margin-top: -40px !important;
          }
          #navigator-toolbox {
          border: none !important;
          }

          #urlbar[breakout][breakout-extend] {
          top: 0vh !important;
          }
          #urlbar-input {
          text-align: center !important;
          }'';

        settings = {
          "webgl.disabled" = false;
          "privacy.resistFingerprinting" = true;
          "privacy.clearOnShutdown.history" = false;
          "privacy.clearOnShutdown.downloads" = false;
          "privacy.clearOnShutdown.cookies" = false;
          # "network.cookie.lifetimePolicy" = 0;
          "middlemouse.paste" = false;
          "general.autoScroll" = true;
          "dom.webgpu.enabled" = true;
          "gfx.webrender.all" = true;
          "layers.gpu-process.enabled" = true;
          "layers.mlgpu.enabled" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.rdd-vpx.enabled" = true; # enable hardware acceleration
          "media.gpu-process-decoder" = true;
          "media.hardware-video-decoding.enabled" = true;
          "browser.startup.page" = 3; # restore previous session
        };

        extraConfig = ''
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          defaultPref("browser.startup.page", 3);
          defaultPref("places.history.enabled", true);
        '';
      };
    };
  };
}
# #navigator-toolbox:not(:hover) {
#   --is-bar-visible: hidden;
#   opacity: 0 !important;
#   height: 15px;
#   transition: height 200ms ease-in-out, opacity 175ms ease-in-out;
# }
# #navigator-toolbox {
#   position: fixed;
#   z-index: 1;
#   height: 10px;
#   overflow: var(--is-bar-visible);
#   right: 0;
#   top: 0;
#   width: calc(100%);
#   background-color: transparent !important;
# }
# #navigator-toolbox:hover {
#   height: 40px;
#   opacity: 1 !important;
#   transition: opacity 175ms ease-in-out;
# }
# #navigator-toolbox:focus-within {
#   height: 40px;
#   opacity: 1 !important;
#   transition: opacity 175ms ease-in-out;
#   --is-bar-visible: visible;
# }

