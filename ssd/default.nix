# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix
      ./lib/standard-programs.nix
      ./lib/laptop-l440.nix
      ./lib/common.nix
      ./lib/studentenwerk
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sdb";

  system.stateVersion = "15.09";

  users.extraUsers.fabian = {
      name = "fabian";
      group = "users";
      extraGroups = [ "networkmanager" ];
      uid = 1000;
      createHome = true;
      home = "/home/fabian";
      shell = "${pkgs.bashInteractive}/bin/bash";
    };
}
