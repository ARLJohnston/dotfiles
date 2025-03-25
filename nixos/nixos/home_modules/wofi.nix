{
  pkgs,
  config,
  nix-colors,
  ...
}: {
  home.packages = with pkgs; [
    wofi
  ];

  programs.wofi = {
    enable = true;
    style = ''
      * {
        font-family: "MonoLisa Nerd Font", monospace;
      }

      window {
        background-color: #${config.colorScheme.palette.base07};
      }

      #input {
        margin: 5px;
        border-radius: 0px;
        border: none;
        background-color: #${config.colorScheme.palette.base03};
        color: white;
      }

      #inner-box {
        background-color: #${config.colorScheme.palette.base01};
      }

      #outer-box {
        margin: 2px;
        padding: 10px;
        background-color: #${config.colorScheme.palette.base00};
      }

      #scroll {
        margin: 5px;
      }

      #text {
        padding: 4px;
        color: #${config.colorScheme.palette.base05};
      }

      #entry:nth-child(even){
        background-color: #${config.colorScheme.palette.base02};
      }

      #entry:selected {
        background-color: #${config.colorScheme.palette.base00};
      }

      #text:selected {
        color: #${config.colorScheme.palette.base0B};
        background: transparent;
      }
    '';

    settings = {
      font = "MonoLisa Nerd Font 10";
      case-sensitive = false;
      #fuzzy-match = true;
      show-icons = true;
      icon-theme = "Papirus";
      icon-size = 16;
    };
  };
}
