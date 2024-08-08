{ 
  inputs,
  outputs,
  lib,
  config, 
  pkgs,
  ... 
}: {
  # import other nixos modules here
  imports = [ 
      ./hardware-configuration.nix
  ];

  nixpkgs = {
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
      allowUnfree = true;
    };
  };
  
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "yggdrasil";

  networking.networkmanager.enable = true;

  # Load nvidia driver for xorg/wayland
  services.xserver.videoDrivers = ["nvidia"];
  boot.kernelParams = ["nvidia-drm.fbdev=1"];

  hardware = {
    graphics.enable = true;
    enableRedistributableFirmware = true;    
    nvidia = {
      modesetting.enable = true; # required
      powerManagement.enable = false;
      # experimental, turns off gpu when not in use
      powerManagement.finegrained = false; 
      open = false;
      nvidiaSettings = true;

      # optionally set driver version for specific gpu
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "555.58.02";
        sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
        sha256_aarch64 = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
        openSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
        settingsSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
        persistencedSha256 = lib.fakeSha256;
      };
    };
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

  hardware.keyboard.qmk.enable = true;

  # Enable sound with pipewire.
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  xdg.portal.enable = true;
  services.flatpak.enable = true;

  # users.defaultUserShell = pkgs.zsh;
  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  users.users.prxsto = {
    isNormalUser = true;
    description = "prxsto";
    extraGroups = [ "networkmanager" "wheel" "audio"];
    packages = with pkgs; [
    ];
  };

  programs = {
    fish.enable = true;
    zsh.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      xwayland.enable = true;
    };
    waybar.enable = true;
    firefox.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  environment.systemPackages = with pkgs; [
  nil
  helix
  git
  gh
  nodejs_22
  bun
  go
  rustup
  jdk17
  kitty
  rofi-wayland
  dunst
  swww
  pavucontrol
  blueman
  killall
  gcc
  cmake 
  ripgrep
  fzf
  eza
  zoxide
  lazygit
  stow
  grim
  slurp
  fastfetch
  cava
  btop
  cbonsai
  mesa
  vulkan-tools
  gpu-viewer
  glxinfo
  lutris
  wine
  via
  ];
  services.udev.packages = [ pkgs.via ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "ZedMono" "Iosevka"]})
  ];

  # create /etc/current-system-packages.txt with a list of unique packages installed
  environment.etc."current-system-packages".text =
  let
    packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
    sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
    formatted = builtins.concatStringsSep "\n" sortedUnique;
  in
    formatted;

  # don't touch :3
  system.stateVersion = "24.05";
}
