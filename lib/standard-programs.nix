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
    }; 
    nix-exec = 
      pkgs.writeScriptBin "nix-exec" ''
	#!${pkgs.perl}/bin/perl
	my $attr = $ARGV[0];
	open(PATH, "nix-build --no-out-link $attr '<nixpkgs>' |";
	my $path = <PATH>;
	close(PATH);
	opendir (my $dh, dir($path, 'bin'));
	my @files = readdir <BIN>;
	'';    
    in
{
  imports = [./reading];
  
  
  #development
  environment.systemPackages = with pkgs; [
    emacs
    vim
    which
    # remove in favor of kde5's kdevelop 
    # kde4.kdevelop
    nixosscripts
    nix-exec
  ];
  
  nixpkgs.config.packageOverrides = oldPkgs: {
    #nix = lib.overrideDerivation oldPkgs.nix (oldAttrs: {
    #  src = pkgs.fetchurl {
    #    url = "file:////nix/store/87z4mj4wlbl0bymdgsgimxxrrbq05ij8-nix-tarball-1.11pre1234_abcdef/tarballs/nix-1.11pre1234_abcdef.tar.xz"; # https://github.com/fkz/nix/archive/deterministic-evaluation.tar.gz";
    #    sha256 = "1mc0vmlcnzmcn5n4wwr75sc6mbaq5rfvvmixrmpffyny7mk16ylk";
    #  };
    #  # I (really) don't understand why this is needed, 
    #  # values come from `nix-shell -p pkgconfig lzma --run "pkg-config --libs liblzma"` and `nix-shell -p pkgconfig lzma --run "pkg-config --cflags liblzma"` respectively
    #  LIBLZMA_LIBS = "-L${pkgs.lzma}/lib -llzma";
    #  LIBLZMA_CFLAGS = "-I${pkgs.lzma}/include";
    #});
  };
}
