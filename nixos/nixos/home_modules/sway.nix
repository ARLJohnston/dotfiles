{
  pkgs,
  config,
  ...
}: let
  cfg = config.wayland.windowManager.sway.config;
in {
  home.packages = with pkgs; [
    autotiling-rs
    grim
    j4-dmenu-desktop
    mako
    slurp
    swaybg
    swayidle
    wl-clipboard
  ];

  wayland.windowManager.sway = {
    enable = true;
    extraConfig = ''
      workspace number 1
      seat * hide_cursor when-typing enable
    '';
    swaynag = {
      enable = true;
    };
    config = {
      modifier = "Mod4";
      terminal = "foot";
      # output = {
      #   eDP-1 = {
      #     bg = "/home/alistair/wallpaper.jpg fill";
      #   };
      # };
      bars = [
        {
          statusCommand = "i3status-rs $HOME/.config/i3status-rust/config-bottom.toml";
          mode = "hide";
          extraConfig = "height 16";

          #Appearance
          fonts = ["MonoLisa Nerd Font 10"];
          colors = {
            background = "#${config.colorScheme.palette.base00}";
            statusline = "#${config.colorScheme.palette.base05}";
            focusedWorkspace = {
              background = "#${config.colorScheme.palette.base0F}";
              border = "#${config.colorScheme.palette.base07}";
              text = "#${config.colorScheme.palette.base05}";
            };
            inactiveWorkspace = {
              background = "#${config.colorScheme.palette.base00}";
              border = "#${config.colorScheme.palette.base00}";
              text = "#${config.colorScheme.palette.base05}";
            };
          };
        }
      ];
      startup = [
        {
          command = "${pkgs.autotiling-rs}/bin/autotiling-rs";
        }
        {
          command = "${pkgs.swaynag-battery}/bin/swaynag-battery --threshold 10";
        }
        {
          command = "${pkgs.swayidle}/bin/swayidle -w timeout 300 'swaylock -f -c 000000' timeout 600 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"' before-sleep 'swaylock -f -c 000000";
        }
      ];
      input = {
        "1:1:AT_Translated_Set_2_keyboard" = {
          xkb_layout = "gb";
          xkb_options = "ctrl:nocaps";
        };
      };

      keybindings = {
        "${cfg.modifier}+q" = "kill";
        "${cfg.modifier}+d" = "exec j4-dmenu-desktop --no-generic";
        "${cfg.modifier}+w" = "exec librewolf";
        "${cfg.modifier}+Control+L" = "exec swaylock";
        "${cfg.modifier}+Shift+Return" = "exec ${cfg.terminal}";

        # Focusing
        "${cfg.modifier}+h" = "focus left";
        "${cfg.modifier}+j" = "focus down";
        "${cfg.modifier}+k" = "focus up";
        "${cfg.modifier}+l" = "focus right";
        "${cfg.modifier}+Left" = "focus left";
        "${cfg.modifier}+Down" = "focus down";
        "${cfg.modifier}+Up" = "focus up";
        "${cfg.modifier}+Right" = "focus right";

        # Moving
        "${cfg.modifier}+Shift+h" = "move left";
        "${cfg.modifier}+Shift+j" = "move down";
        "${cfg.modifier}+Shift+k" = "move up";
        "${cfg.modifier}+Shift+l" = "move right";
        "${cfg.modifier}+Shift+Left" = "move left";
        "${cfg.modifier}+Shift+Down" = "move down";
        "${cfg.modifier}+Shift+Up" = "move up";
        "${cfg.modifier}+Shift+Right" = "move right";

        # Workspaces
        "${cfg.modifier}+1" = "workspace number 1";
        "${cfg.modifier}+2" = "workspace number 2";
        "${cfg.modifier}+3" = "workspace number 3";
        "${cfg.modifier}+4" = "workspace number 4";
        "${cfg.modifier}+5" = "workspace number 5";
        "${cfg.modifier}+6" = "workspace number 6";
        "${cfg.modifier}+7" = "workspace number 7";
        "${cfg.modifier}+8" = "workspace number 8";
        "${cfg.modifier}+9" = "workspace number 9";
        "${cfg.modifier}+0" = "workspace number 10";

        # Move workspaces
        "${cfg.modifier}+Shift+1" = "move to workspace number 1";
        "${cfg.modifier}+Shift+2" = "move to workspace number 2";
        "${cfg.modifier}+Shift+3" = "move to workspace number 3";
        "${cfg.modifier}+Shift+4" = "move to workspace number 4";
        "${cfg.modifier}+Shift+5" = "move to workspace number 5";
        "${cfg.modifier}+Shift+6" = "move to workspace number 6";
        "${cfg.modifier}+Shift+7" = "move to workspace number 7";
        "${cfg.modifier}+Shift+8" = "move to workspace number 8";
        "${cfg.modifier}+Shift+9" = "move to workspace number 9";
        "${cfg.modifier}+Shift+0" = "move to workspace number 10";

        "${cfg.modifier}+Tab" = "workspace back_and_forth";

        "${cfg.modifier}+space" = "floating toggle";
        "${cfg.modifier}+Shift+space" = "move position center";

        "${cfg.modifier}+e" = "fullscreen";
        "Print" = "exec 'grim -g \"\$(slurp)\" - | wl-copy -t image/png'";

        # Scratchpad
        "${cfg.modifier}+Shift+minus" = "move scratchpad";
        "${cfg.modifier}+minus" = "scratchpad show";

        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";

        "${cfg.modifier}+XF86MonBrightnessDown" = "exec brightnessctl set 1%-";
        "${cfg.modifier}+XF86MonBrightnessUp" = "exec brightnessctl set 1%+";

        "XF86AudioRaiseVolume" = "exec 'pamixer --increase 5'";
        "XF86AudioLowerVolume" = "exec 'pamixer --decrease 5'";
        "XF86AudioMute" = "exec 'pamixer --toggle-mute'";
      };
    };
  };

  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
        blocks = [
          {
            block = "memory";
            format = " $icon $mem_used_percents ";
            format_alt = " $icon $swap_used_percents ";
          }
          {
            block = "cpu";
            interval = 1;
            format = "$utilization $frequency ";
          }
          {
            block = "sound";
          }
          {
            block = "battery";
            device = "BAT0";
            format = "INT $percentage $time ";
          }
          {
            block = "battery";
            device = "BAT1";
            format = "EXT $percentage $time ";
          }
          {
            block = "net";
            format = " $icon $ssid $signal_strength $ip ↓$speed_down ↑$speed_up ";
            interval = 2;
          }
          {
            block = "time";
            interval = 1;
            format = " $timestamp.datetime(f:'%F %T') ";
          }
        ];
        theme = "nord-dark";
        icons = "none";
      };
    };
  };

  programs.swaylock = {
    package = pkgs.swaylock-effects;
    enable = true;
    settings = {
      font = "MonoLisa Nerd Font";
      image = "/home/alistair/wallpaper.jpg";
      scaling = "fill";
      clock = true;
      fade-in = 0.2;
      indicator = true;
      indicator-radius = 65;

      bs-hl-color = "#${config.colorScheme.palette.base08}";
      key-hl-color = "#${config.colorScheme.palette.base0C}";

      inside-color = "#${config.colorScheme.palette.base01}";
      inside-clear-color = "#${config.colorScheme.palette.base01}";
      inside-ver-color = "#${config.colorScheme.palette.base01}";
      inside-wrong-color = "#${config.colorScheme.palette.base01}";

      line-color = "#${config.colorScheme.palette.base00}";
      line-ver-color = "#${config.colorScheme.palette.base00}";
      line-clear-color = "#${config.colorScheme.palette.base00}";
      line-wrong-color = "#${config.colorScheme.palette.base00}";

      ring-color = "#${config.colorScheme.palette.base03}";
      ring-clear-color = "#${config.colorScheme.palette.base0C}";
      ring-ver-color = "#${config.colorScheme.palette.base0C}";
      ring-wrong-color = "#${config.colorScheme.palette.base08}";

      separator-color = "00000000";

      text-color = "#${config.colorScheme.palette.base06}";
      text-clear-color = "#${config.colorScheme.palette.base05}";
      text-ver-color = "#${config.colorScheme.palette.base04}";
      text-wrong-color = "#${config.colorScheme.palette.base08}";
    };
  };
}
