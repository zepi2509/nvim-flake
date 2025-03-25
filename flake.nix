{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    appimage-file-latest = {
      url = "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage";
      flake = false;
    };
    appimage-file-nightly = {
      url = "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.appimage";
      flake = false;
    };
  };

  outputs = { nixpkgs, ... }@inputs: {
    packages = builtins.listToAttrs (map (system: {
        name = system;
        value = with import nixpkgs { inherit system; config.allowUnfree = true;}; rec {
          latest = pkgs.callPackage (import ./nvim/appimage-default.nix) { src = inputs.appimage-file-latest; pname = "nvim"; version = "latest"; };
          nightly = pkgs.callPackage (import ./nvim/appimage-default.nix) { src = inputs.appimage-file-nightly; pname = "nvim"; version = "nightly"; };
          default = latest;
        };
      })[ "x86_64-linux" ]);
  };
}
