{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.calibre pkgs.spideroak
  ];
}