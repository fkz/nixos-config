{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeScriptBin "mountFilesystem" ''
      #!${pkgs.bash}/bin/bash
      ${pkgs.cryptsetup}/bin/cryptsetup luksOpen /dev/sdb5 OldEncrypted
      ${pkgs.devicemapper}/bin/lvm vgchange -ay main
      ${pkgs.eject}/bin/mount /dev/main/DebianTesting /unpure
      '')
    ];
}
