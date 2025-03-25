{
  pkgs,
  config,
  nix-colors,
  ...
}: {
  programs.fzf = {
    enable = true;

    colors = {
      fg = "${config.colorScheme.palette.base04}";
      "fg+" = "${config.colorScheme.palette.base06}";
      bg = "${config.colorScheme.palette.base00}";
      "bg+" = "${config.colorScheme.palette.base01}";
      hl = "${config.colorScheme.palette.base0D}";
      "hl+" = "${config.colorScheme.palette.base0D}";
      spinner = "${config.colorScheme.palette.base0C}";
      header = "${config.colorScheme.palette.base0D}";
      info = "${config.colorScheme.palette.base05}";
      pointer = "${config.colorScheme.palette.base0C}";
      marker = "${config.colorScheme.palette.base0C}";
      prompt = "${config.colorScheme.palette.base05}";
    };
  };
}
