# vim:ft=nix:ts=2:sts=2:sw=2:et:
{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
      make = name: {
        cc ? pkgs.gcc + /bin/gcc,
        ld ? cc,
      }: inputs: let
        objs = builtins.map (c:
          derivation {
            name = "${name}-${builtins.baseNameOf c}.o";
            inherit system;
            builder = cc;
            args = ["-c" "-o" (builtins.placeholder "out") c];
          })
        inputs;
      in
        pkgs.runCommand name {
          inherit cc ld objs;
        } ''
          mkdir -p "$out/bin"
          "$ld" -o "$out/bin/$name" $objs
        '';
    in {
      formatter = pkgs.alejandra;
      packages.mkmindev = make "mkmindev" {} [./mkmindev.c];
    });
}
