{ config, pkgs, lib, ... }:
let nixosscripts = 
  pkgs.stdenv.mkDerivation {
    name = "nixos-scripts-0.3";
    buildInputs = [pkgs.nix];
    src = pkgs.fetchurl {
      url = "https://github.com/matthiasbeyer/nixos-scripts/archive/master.tar.gz";
      sha256 = "0w9zbgwb0q4wk7ks7rdjsnh34lmmfsv045c01yjnchpw8yclj75l";
    };
    installPhase = ''
      mkdir -p $out/bin
      cp -R ./* $out
      ln -s $out/nix-script $out/bin
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
  
  nixpkgs.config.packageOverrides = oldPkgs: {
    nix = lib.overrideDerivation oldPkgs.nix (oldAttrs: {
      src = pkgs.fetchurl {
        url = "https://github.com/fkz/nix/archive/deterministic-evaluation.tar.gz";
        sha256 = "02agg7likcmxnda6m6lsi39la6hlwscc2rjgbk5yg0q99r6qi3kb";
      };
    });
  };
}
