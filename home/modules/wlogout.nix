{ pkgs, ... }:
let
  out = pkgs.wlogout.outPath;
in
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "logout";
        action = "loginctl terminate-user $USER";
        text = "Logout";
        keybind = "o";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "systemctl suspend && hyprlock";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "windows";
        action = "systemctl reboot --boot-loader-entry=auto-windows";
        text = "Reboot to Windows";
        keybind = "w";
      }
    ];

    style = ''
      * {
        background-image: none;
        box-shadow: none;
      }

      window {
        background-color: rgba(0, 0, 0, 0.3);
      }

      button {
        color: #f8f8f2;
        background-color: rgba(40, 42, 54, 0.8);
        border-radius: 32px;
        border-style: none;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        margin: 240 20;
      }

      button:hover {
        background-color: rgba(68, 71, 90, 0.7);
        outline-style: none;
      }

      #lock {
        background-image: image(
          url("${out}/share/wlogout/icons/lock.png")
        );
      }

      #logout {
        background-image: image(
          url("${out}/share/wlogout/icons/logout.png")
        );
      }

      #suspend {
        background-image: image(
          url("${out}/share/wlogout/icons/suspend.png")
        );
      }

      #hibernate {
        background-image: image(
          url("${out}/share/wlogout/icons/hibernate.png")
        );
      }

      #shutdown {
        background-image: image(
          url("${out}/share/wlogout/icons/shutdown.png")
        );
      }

      #reboot {
        background-image: image(
          url("${out}/share/wlogout/icons/reboot.png")
        );
      }

      #windows {
        background-image: image(
          url("${out}/share/wlogout/icons/reboot.png")
        );
      }
    '';
  };
}
