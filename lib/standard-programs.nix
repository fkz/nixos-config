{ config, pkgs, ... }:
{
  imports = [./reading];
  environment.systemPackages = with pkgs; [
    emacs
    vim
  ];
}
