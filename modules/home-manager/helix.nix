{ config, lib, pkgs, ... }:

with lib;
{
  options.modules.helix = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.helix.enable {
    programs.helix = {
      settings = {
        theme = "tokyonight";

        editor = {
          mouse = false;
          true-color = true;
          color-modes = true;
          undercurl = true;
          bufferline = "multiple";
          cursorline = true;
          auto-format = true;
          auto-save = true;
          popup-border = "all";
          line-number = "relative";
        };

        editor.cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };

        editor.statusline = {
          left = [
            "mode"
            "spacer"
            "version-control"
          ];
          center = [
            "file-base-name"
            "file-modification-indicator"
          ];
          right = [
            "workspace-diagnostics"
            "spinner"
            "position"
          ];
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };

        editor.lsp = {
          display-messages = true;
          auto-signature-help = false;
          # display-inline-hints = true;
        };

        editor.indent-guides = {
          render = true;
          # skip-levels = 1;
        };

        keys.normal = {
          g.a = "code_action";
          esc = [ "collapse_selection" "keep_primary_selection" ];
          ret = [ "open_below" "normal_mode" ];
          shift.ret = [ "open_below" "normal_mode" "move_visual_line_up" ];
          tab = ":bn";
          shift.tab = ":bp";
          X = "extend_line_above";
          K = "hover";
        };
               
        keys.insert = {
          C.p = "signature_help";
        };
      };
    };
  };
}
