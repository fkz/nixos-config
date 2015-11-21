{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.writeScriptBin "mountFilesystem" ''
      #!${pkgs.bash}/bin/bash
      ${cryptsetup}/bin/cryptsetup luksOpen /dev/sdb5 OldEncrypted
      mount /unpure /dev/main-DebianTesting
      '')
    ];
}
