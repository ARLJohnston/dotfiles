{
  description = "My system configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = {url = "github:misterio77/nix-colors";};

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dwl-source = {
      url = "git+https://codeberg.org/dwl/dwl";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixos-wsl,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {inherit system;};
  in {
    nixosConfigurations = {
      thinkpad = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs system;
          overlays = import ./overlays;
        };
        modules = [
          {nixpkgs.hostPlatform = "x86_64-linux";}
          ./nixos/configuration.nix
          ./modules
        ];
      };
      windows = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs system;
          overlays = import ./overlays;
        };
        modules = [
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "25.05";
            wsl.enable = true;
            nixpkgs.hostPlatform = "x86_64-linux";
          }
          ./modules
          ./hosts/wsl.nix
			    ./nixos/emacs.nix
        ];
      };
    };

    homeConfigurations = {
      alistair = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs system;};
        modules = [./nixos/home.nix];
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [alejandra nixd];
    };
  };
}
