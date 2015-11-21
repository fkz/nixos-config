# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./standard-programs.nix
      ./standard-config/laptop-l440.nix
      ./standard-config/common.nix
      ./standard-config/studentenwerk.nix
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
