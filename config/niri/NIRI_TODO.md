# Niri Migration TODO

Tasks to complete for full parity with Hyprland config.

## Scripts to Create/Adapt

- [ ] **Power Menu**: Create a niri-compatible power menu script (was `hypr_powermenu`)
  - Should provide options for shutdown, reboot, logout, suspend, lock
  - Consider using `wlogout` or a custom fuzzel/rofi menu

- [ ] **Audio Sink Selector**: Create a niri-compatible audio sink selector (was `hypr_select_audio_sink`)
  - Could use `wpctl` + fuzzel/rofi to list and select audio outputs
  - Example approach: `wpctl status | grep -A 50 "Sinks:" | fuzzel --dmenu`

## Startup Applications

- [ ] **Wallpaper**: `hyprpaper` is Hyprland-specific
  - Consider using `swaybg` or `wpaperd` instead
  - Or use `swww` for animated wallpapers

## Features with No Direct Equivalent

- [ ] **Window positioning rules**: Hyprland's `move 100%-920 50` style positioning
  - Niri doesn't have pixel-perfect window positioning for floating windows
  - May need to accept default positioning or investigate alternatives

- [ ] **Workspace silent assignment**: `workspace 4 silent` for Spotify
  - Niri's `open-on-workspace` doesn't have a "silent" option
  - Windows will be opened but workspace won't auto-switch (need to verify behavior)
