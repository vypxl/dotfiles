# vypxl's config

This repo contains my linux configuration files.

Currently, we have a NixOS flake configuration for all of my systems, distinguished by hostname.

It features a fully fledged desktop environment based on Hyprland, with all the bells and whistles.

When using full disk encryption, autologin can be enabled to boot into Hyprland (and an unlocked gnome-keyring)
with just entering the passphrase for LUKS, no further password prompting.

A bunch of userspace programs are also configured. Most of them using their home-manager modules, but
for some I opted for raw config files, these can be found in `config`. They are applied using
my custom `home/modules/dotfiles.nix` module.

## Structure

The configuration has two parts: home and nixos (see the folders).
Each folder has a subfolder `modules`, containing various configuration items.
`nixos` contains system configuration, which is kept minimal, most configuration is
done via home-manager under `home`. `flake.nix` glues them together.

A system can be built using the commands saved in the `justfile`.
