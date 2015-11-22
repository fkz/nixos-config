{ config, pkgs, lib, ... }:
let nixosscripts = 
  pkgs.stdenv.mkDerivation {
    name = "nixos-scripts-0.3";
    src = pkgs.fetchurl {
      url = "https://github.com/matthiasbeyer/nixos-scripts/archive/master.tar.gz";
      sha256 = "0w9zbgwb0q4wk7ks7rdjsnh34lmmfsv045c01yjnchpw8yclj75l";
    };
    installPhase = ''
      mkdir -p $out/bin
      cp -R ./* $out
      ln -s $out/nix-scripts $out/bin/nix-scripts
      '';
    }; in
{
  imports = [./reading];
  
  
  #development
  environment.systemPackages = with pkgs; [
    emacs
    vim
    which
    kde4.kdevelop
    nixosscripts
  ];
}
