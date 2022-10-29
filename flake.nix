{
  description = "ziglings";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs = inputs: with inputs; let
    forAllSystems = cb: nixpkgs.lib.genAttrs
      [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ]
      (system: cb {
        inherit system;
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ zig.overlays.default ];
        };
      });
  in
  {
    devShells = forAllSystems ({ pkgs, ... }: {
      default = pkgs.mkShell {
        buildInputs = [ pkgs.zigpkgs.master ];
      };
    });
  };
}
