{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./emacs.nix

    ./hardware-configuration.nix
  ];

  pipewire.enable = true;
  boot-config.enable = true;
  powersave.enable = true;
  git.enable = true;

  time.timeZone = "Europe/Dublin";
  console.keyMap = "uk";

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };
  security.pam.services.swaylock = {};

  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
    lidSwitch = "suspend";
  };
  powerManagement.powerUpCommands = "sudo rmmod atkbd; sudo modprobe atkbd reset=1";

  i18n = {defaultLocale = "en_GB.UTF-8";};

  nix = {
    settings = {
      allowed-users = ["@wheel"];
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      cores = 4;

      extra-substituters = ["https://cache.nixos.org/" "https://nix-community.cachix.org/"];
      extra-trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  boot.supportedFilesystems = ["zfs"];
  services.zfs = {
    autoSnapshot.enable = true;
    autoScrub.enable = true;
  };

  services.openssh.enable = true;
  networking = {
    hostId = "0f6ac2e8";
    networkmanager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    alejandra
    curl
    inkscape
    libnotify
    pcmanfm
    rpi-imager
    vlc
    zfs
    zfs-prune-snapshots
  ];

  fonts = {
    packages = with pkgs; [
      emacs-all-the-icons-fonts
      iosevka-comfy.comfy-motion-fixed
    ];

    fontconfig = {
      defaultFonts = {
        serif = ["MonoLisa Nerd Font"];
        sansSerif = ["MonoLisa Nerd Font"];
        monospace = ["MonoLisa Nerd Font"];
      };
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) ["discord" "spotify" "whatsapp"];

  users.users.alistair = {
    isNormalUser = true;
    extraGroups = ["wheel" "video" "networkmanager" "docker"];

    packages = with pkgs; [
      calibre
      discord
      feh
      gh
      gnumake
      godot_4
      keepassxc
      mermaid-cli
      openconnect
      teams-for-linux
      thunderbird
      unzip
    ];
  };

  services.syncthing = {
    enable = true;
    user = "alistair";
    group = "users";
    openDefaultPorts = true;
    configDir = "/home/alistair/.config/syncthing";
    dataDir = "/home/alistair";

    settings = {
      devices = {
        "Pixel3XL" = {
          id = "I6A3YY6-7RNPXIN-2BZG62F-AGET2PC-57ND5V4-QLGBYWN-LNZ7MPY-P2C7FQM";
          introducer = true;
        };
      };
      folders = {
        "Default" = {
          path = "/home/alistair/Sync";
          devices = ["Pixel3XL"];
        };
        "Camera" = {
          path = "/home/alistair/Camera";
          devices = ["Pixel3XL"];
        };
        "Org" = {
          path = "/home/alistair/org";
          devices = ["Pixel3XL"];
        };
      };
    };
  };

  services.xserver.excludePackages = with pkgs; [xterm];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      domain = true;
      userServices = true;
    };
  };

  programs.nm-applet.enable = true;

  virtualisation = {
    containers.enable = true;
    docker = {
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      storageDriver = "zfs";
    };
  };

  hardware.graphics.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
