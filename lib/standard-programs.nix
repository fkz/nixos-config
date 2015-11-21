{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    emacs
    vim
  ];
}
