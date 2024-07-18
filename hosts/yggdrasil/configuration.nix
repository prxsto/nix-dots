{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "yggdrasil";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for xorg/wayland
  services.xserver.videoDrivers = ["nvidia"];
  boot.kernelParams = ["nvidia-drm.fbdev=1"];

  hardware.nvidia = {
    modesetting.enable = true; # required
    powerManagement.enable = false;
    # experimental, turns off gpu when not in use
    powerManagement.finegrained = false; 
    open = false;
    nvidiaSettings = false;

    # optionally set driver version for specific gpu
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.lightdm.enable = false;
  services.xserver.desktopManager.gnome.enable = true;
  services.displayManager.defaultSession = "gnome";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true; # enable document printing

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
  services.flatpak.enable = true;

  users.defaultUserShell = pkgs.zsh;

  users.users.prxsto = {
    isNormalUser = true;
    description = "prxsto";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  programs.zsh.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.firefox.enable = true;
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = { inherit inputs; };
    users = {
        "prxsto" = import ./home.nix;
      };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  zsh
  git
  gh
  go
  rustup
  jdk17
  kitty
  rofi-wayland
  swww
  pavucontrol
  blueman
  spotifyd
  spotify-player
  gcc
  ripgrep
  fzf
  eza
  zoxide
  lazygit
  stow
  grim
  slurp
  fastfetch
  btop
  cbonsai
  mesa
  vulkan-tools
  gpu-viewer
  glxinfo
  runelite
  lutris
  wine
  ];

  fonts.packages = with pkgs; [
  fira-code-nerdfont
  ];

  # don't touch :3
  system.stateVersion = "24.05";

}
