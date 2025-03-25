{
  pkgs,
  config,
  ...
}: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      add_newline = false;
      "$schema" = "https://starship.rs/config-schema.json";
    };
  };
}
