{
  config,
  lib,
  ...
}: {
  options = {
    git.enable = lib.mkEnableOption "Enable and configure git";
  };

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;

      config = {
        init = {defaultBranch = "main";};
        user = {
          name = "ARLJohnston";
          email = "github@arljohnston.com";
        };
        core = {editor = "emacsclient -c";};
        github = {user = "ARLJohnston";};
      };
    };
  };
}
