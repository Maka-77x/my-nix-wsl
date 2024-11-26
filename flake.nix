{
  description = "NixOS configuration";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  inputs.nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

  inputs.home-manager.url = "github:nix-community/home-manager/release-24.05";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
  inputs.lix-module.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nur.url = "github:nix-community/NUR";

  inputs.nixos-wsl.url = "github:nix-community/NixOS-WSL";
  inputs.nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

  inputs.nix-index-database.url = "github:Mic92/nix-index-database";
  inputs.nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

  inputs.jeezyvim.url = "github:LGUG2Z/JeezyVim";
  inputs.vscode-server.url = "github:nix-community/nixos-vscode-server";
  inputs.vscode-server.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      lix-module,
      home-manager,
      nixos-wsl,
      nur,
      vscode-server,
      jeezyvim,
      nix-index-database,
      ...
    }:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");
      #
      #
      nixpkgsWithOverlays = import nixpkgs {

        inherit system;

        config = {
          allowUnfree = true;
          permittedInsecurePackages = _: true;
        };

        overlays = [
          (_final: prev: {
            unstable = import nixpkgs-unstable {
              inherit (prev) system;
              inherit (prev) config;
            };
          })
        ];
      };
      #
      #
      configurationDefaults = args: {
        nixpkgs = nixpkgsWithOverlays;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hm-backup";
        home-manager.extraSpecialArgs = args;
      };
      #
      #
      argDefaults = {
        inherit
          secrets
          inputs
          self
          nix-index-database
          ;
        channels = {
          inherit nixpkgs nixpkgs-unstable;
        };
      };
      #
      #
      mkNixosConfiguration =
        {
          system ? "x86_64-linux",
          hostname,
          username,
          args ? { },
          modules,
        }:
        let
          specialArgs =
            argDefaults
            // {
              inherit
                inputs
                outputs
                hostname
                username
                ;
            }
            // args;
        in
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            (configurationDefaults specialArgs)
            home-manager.nixosModules.home-manager
          ] ++ modules;
        };
    in
    #
    #
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
      #
      #
      nixosConfigurations."hbb-tower-wslnix01" = mkNixosConfiguration {
        hostname = "hbb-tower-wslnix01";
        username = "mimiparretto"; # FIXME: replace with your own username!
        modules = [
          lix-module.nixosModules.default
          nixos-wsl.nixosModules.wsl
          ./wsl.nix
        ];
      };
      #
      #
      # homeConfigurations = {
      #   "mimiparretto@hbb-tower-wslnix01" =
      #     let specialArgs =
      #       argDefaults
      #       // {
      #         inherit
      #           inputs
      #           outputs

      #           ;
      #       }
      #       // args;
      #   in
      #   home-manager.lib.homeManagerConfiguration {
      #     inherit configurationDefaults;

      #     modules = [ ./home.nix ];
      #   };
      # };
    };
}
