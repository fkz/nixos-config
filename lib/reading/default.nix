{ pkgs, ... }:

{
  environment.systemPackages = [
    # TODO: bundle DRM plugin
    pkgs.calibre
    
    # TODO: somehow manage the books
  ];
}