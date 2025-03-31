{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  git.enable = true;

  wsl = {
    enable = true;
    defaultUser = "Alistair";
    startMenuLaunchers = true;
    useWindowsDriver = true;
    docker-desktop.enable = true;
    wslConf = {
      automount.root = "/home/nixos";
    };
  };

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };

  environment.systemPackages = with pkgs; [
    alejandra
    keepassxc
  ];

  virtualisation = {
    containers.enable = true;
    docker = {
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  fonts = {
    packages = with pkgs; [
      emacs-all-the-icons-fonts
      fira-code
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Fira Code"];
      };
    };
  };

  nix = {
    settings = {
      allowed-users = ["@wheel"];
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;

      extra-substituters = ["https://cache.nixos.org/" "https://nix-community.cachix.org/"];
      extra-trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
