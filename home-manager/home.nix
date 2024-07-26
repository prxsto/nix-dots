{ 
  inputs,
  outputs,
  lib,
  config, 
  pkgs, 
  ... 
}:
let
  user = "prxsto";
in
{
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ../modules/home-manager/hyprland.nix
    ../modules/home-manager/helix.nix
    ../modules/home-manager/zellij.nix
  ];

  hyprland.enable = true;
  helix.enable = true;
  zellij.enable = true;

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    sessionVariables = {
      EDITOR = "hx";
    };

    packages = with pkgs; [

    ];
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  # reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "24.05"; # no touchy ;)

}
