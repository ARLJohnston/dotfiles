{
  pkgs,
  config,
  nix-colors,
  ...
}: {
  services.mako = {
    enable = true;
    backgroundColor = "#${config.colorScheme.palette.base01}";
    borderColor = "#${config.colorScheme.palette.base0E}";
    textColor = "#${config.colorScheme.palette.base04}";
    layer = "overlay";
    font = "Iosevka Comfy 10";
    defaultTimeout = 5000;
  };
}
