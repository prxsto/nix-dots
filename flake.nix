{
  description = "nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hyprland.url = "github:hyprwm/Hyprland";

    # stylix.url = "github:danth/stylix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, ... }@inputs: {

    nixosConfigurations = {

      # ================= NixOS Configurations ================= #
      yggdrasil = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/yggdrasil/configuration.nix
          ./modules
          inputs.home-manager.nixosModules.default
        ];
      };
      # add more configs here for different machines
    };
  };
}
