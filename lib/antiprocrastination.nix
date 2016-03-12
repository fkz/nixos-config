# prevent the most unproductive forms of procrastination

{ pkgs, lib, ... }:

let forbidden = [
  #"gorillavid.in"
  #"thewatchseries.to"
  "vidzi.tv"
  "kinox.to"
  "movie4u.org"
  "heise.de"
  # "twitter.com"
]; in
{
  networking.extraHosts = lib.concatStringsSep "\n" (map (x: "127.0.0.1 ${x}") forbidden);
}
