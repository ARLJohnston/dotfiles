{
  pkgs,
  config,
  nix-colors,
  ...
}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Iosevka Comfy:size=10";
      };
      mouse = {
        hide-when-typing = "yes";
      };
      colors = {
        alpha = 0.8;

        foreground = "${config.colorScheme.palette.base05}";
        background = "${config.colorScheme.palette.base00}";

        regular0 = "${config.colorScheme.palette.base03}";
        regular1 = "${config.colorScheme.palette.base08}";
        regular2 = "${config.colorScheme.palette.base0B}";
        regular3 = "${config.colorScheme.palette.base05}";
        regular4 = "${config.colorScheme.palette.base0D}";
        regular5 = "${config.colorScheme.palette.base08}";
        regular6 = "${config.colorScheme.palette.base0C}";
        regular7 = "${config.colorScheme.palette.base06}";

        bright0 = "${config.colorScheme.palette.base0D}";
        bright1 = "${config.colorScheme.palette.base08}";
        bright2 = "${config.colorScheme.palette.base0B}";
        bright3 = "${config.colorScheme.palette.base0A}";
        bright4 = "${config.colorScheme.palette.base09}";
        bright5 = "${config.colorScheme.palette.base0E}";
        bright6 = "${config.colorScheme.palette.base0C}";
        bright7 = "${config.colorScheme.palette.base07}";
      };
    };
  };
}
