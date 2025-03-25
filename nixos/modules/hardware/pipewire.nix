{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    pipewire.enable = lib.mkEnableOption "enables pipewire with pamixer";
  };

  config = lib.mkIf config.pipewire.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    environment.systemPackages = with pkgs; [pamixer];
  };
}
