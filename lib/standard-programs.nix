{ config, pkgs, ... }:
{
  imports = [./reading];
  
  #development
  environment.systemPackages = with pkgs; [
    emacs
    vim
    which
    kde4.kdevelop
  ];
}
