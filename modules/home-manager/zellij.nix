{ config, lib, pkgs, ... } 

with lib;
{
  options.modules.zellij = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.zellij.enable {
    programs.zellij = {
      enable = true;
      settings = {
        theme = "tokyonight";
        default-shell = "zsh";
      };
    };
  };
}
