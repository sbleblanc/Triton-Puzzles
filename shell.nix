let
  nixpkgs = import <nixpkgs>{ config = {allowUnfree = true;}; overlays = []; }   ; #fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-23.11";
  pkgs = nixpkgs.pkgs; #import nixpkgs { config = {allowUnfree = true;}; overlays = []; };
  nixpkgs-python = import (fetchTarball "https://github.com/cachix/nixpkgs-python/archive/refs/heads/main.zip");
  python = nixpkgs-python.packages.x86_64-linux."3.10.14";
  uv = ps: (ps.callPackage ./uv.nix {rustc = pkgs.rustc;} );
  cuda_pkg = pkgs.cudaPackages.cudatoolkit;
  lib_pkgs = [ pkgs.linuxPackages.nvidia_x11 pkgs.stdenv.cc.cc.lib pkgs.zlib ];
in
pkgs.mkShell {

  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath lib_pkgs;

  packages = [
    (python.withPackages(ps: with ps; [(uv ps)]))
    pkgs.cudaPackages.cudatoolkit
    pkgs.zlib
    pkgs.pkg-config
    pkgs.cairo
    pkgs.expat
    pkgs.xorg.libXdmcp
    pkgs.ninja
    pkgs.gobject-introspection
    pkgs.cmake
  ];
}
