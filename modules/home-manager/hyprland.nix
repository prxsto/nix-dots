{ config, lib, pkgs, ... }: 

with lib;
{
  options.modules.hyprland = {
    enable = mkOption { type = types.bool; default = false; };
  };
  
  config = mkIf config.modules.hyprland.enable { 
    wayland.windowManager.hyprland = {
      # allow home-manager to configure hyprland
      enable = true;

      settings = {

        general = {
          gaps_in = 7.5;
          gaps_out = 15;
          border_size = 2;
          "col.active_border" = "rgb(b4befe)";
          "col.inactive_border" = "rgb(11111b)";
          layout = "dwindle";
        };

        decoration = {
          rounding = 5;

          active_opacity = 1.0;
          inactive_opacity = 1.0;

          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1a22)";
        };

        monitors = {
          "DP-2" = {
            width = 3440;
            height = 1440;
            refreshRate = 100;
          };
        };

        env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
        ];

        input = {
          follow_mouse = 1;
          sensitivity = 0;
          repeat_rate = 40;
          repeat_delay = 250;
          force_no_accel = true;
        };

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          animate_manual_resizes = true;
          allow_session_lock_restore = true;
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          # bezier = "overshot, 0.13, 0.99, 0.29, 1.1";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "workspaces, 1, 6, overshot, slidevert"
          ];

          dwindle = {
            psuedotile = true;
            preserve_split = true;
          };

          master = {
            new_status = master;
          };

          cursor = {
            inactive_timeout = 1;
          };

          device = {
            name = "epic-mouse-v1";
            sensitivity = -0.5;
          };

          "$mainmod" = "SUPER";
          bind = 
            [
              "$mainMod, T, exec, $terminal"
              "$mainMod, Q, killactive,"
              "$mainMod, M, exit,"
              "$mainMod SHIFT, L, exec, hyprlock"
              "$mainMod, F, exec, $fileManager"
              "$mainMod, V, togglefloating,"
              "$mainMod, space, exec, pkill rofi || sh $HOME/.config/rofi/bin/launcher"
              "$mainMod SHIFT, P, exec, pkill rofi || sh $HOME/.config/rofi/bin/powermenu"
              "$mainMod, P, pseudo, # dwindle"
              "$mainMod, C, togglesplit, # dwindle"
              "$mainMod SHIFT, R, exec, hyprctl reload"
              "$mainMod, G, togglegroup"
              "$mainMod, tab, changegroupactive"

              # screenshot
              # "$mainMod, S, exec, grim ~/Pictures/screenshots/$(date '+%Y-%m-%d-%H:%M:%S').png"
              # "$mainMod SHIFT, S, exec, grim -g "$(slurp)" ~/Pictures/screenshots/$(date '+%Y-%m-%d-%H:%M:%S').png"

          
              ", Print, exec, volumectl -m toggle-mute"

              # focus with mainMod + vim keys
              "$mainMod, H, movefocus, l"
              "$mainMod, L, movefocus, r"
              "$mainMod, K, movefocus, u"
              "$mainMod, J, movefocus, d"

              # workspaces with mainMod + [0-9]
              "$mainMod, 1, workspace, 1"
              "$mainMod, 2, workspace, 2"
              "$mainMod, 3, workspace, 3"
              "$mainMod, 4, workspace, 4"
              "$mainMod, 5, workspace, 5"
              "$mainMod, 6, workspace, 6"
              "$mainMod, 7, workspace, 7"
              "$mainMod, 8, workspace, 8"
              "$mainMod, 9, workspace, 9"
              "$mainMod, 0, workspace, 10"

              # Move active window to a workspace with mainMod + SHIFT + [0-9]
              "ALT,1,movetoworkspace,1"
              "ALT,2,movetoworkspace,2"
              "ALT,3,movetoworkspace,3"
              "ALT,4,movetoworkspace,4"
              "ALT,5,movetoworkspace,5"
              "ALT,6,movetoworkspace,6"
              "ALT,7,movetoworkspace,7"
              "ALT,8,movetoworkspace,8"
              "ALT,9,movetoworkspace,9"
              "ALT,0,movetoworkspace,10"

              # Scroll through existing workspaces with mainMod + scroll
              "$mainMod, mouse_up, workspace, e+1"
              "$mainMod, mouse_down, workspace, e-1"
            ];

          bindm = 
            [
              # Move/resize windows with mainMod + LMB/RMB and dragging
              "$mainMod, mouse:272, movewindow"
              "$mainMod, mouse:273, resizewindow"
            ];

          bindle = 
            [
              ", XF86AudioRaiseVolume, exec, volumectl -u up"
              ", XF86AudioLowerVolume, exec, volumectl -u down"
            ];

          bindl = 
            [
              ", XF86AudioMute, exec, volumectl toggle-mute"
            ];

          windowrulev2 = [
            "suppressevent maximize, class:.*"
          ];

          windowrule = [
            "float, ^(files)$"
            "float, ^(audio)$"
            "float, ^(bt)$"
            "float, Rofi"
            "noborder, Rofi"
          ];
        };
      };
      home.packages = with pkgs; [
        grim
        slurp
        wl-clipboard

        swww

        networkmanagerapplet

        rofi-wayland
      ];
    };
  };
}
