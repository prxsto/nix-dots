{ config, lib, pkgs, ... }:

with lib;
{
  options.modules.helix = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.helix.enable {
    programs.helix = {
      enable = true;
      # settings = {
        
      # };
    };
  };
}
