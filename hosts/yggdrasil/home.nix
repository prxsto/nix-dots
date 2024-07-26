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
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    stateVersion = "24.05"; # no touchy ;)

    sessionVariables = {
      EDITOR = "hx";
    };

    packages = with pkgs; [
      
    ];
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
