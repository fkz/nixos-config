{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeScriptBin "mountFilesystem" ''
      #!${pkgs.bash}/bin/bash
      if [ $1 eq '-r' ]; then
        echo "Not implemented yet"
        exit 1
      fi
      ${pkgs.cryptsetup}/bin/cryptsetup luksOpen /dev/disk/by-uuid/a6fd70c7-5e8e-42bf-80b4-ee90dd52f93c OldEncrypted
      ${pkgs.devicemapper}/bin/lvm vgchange -ay main
      ${pkgs.eject}/bin/mount /dev/main/DebianTesting /unpure
      '')
    ];
}
