let
  haskellNix = import (builtins.fetchTarball
    ( "https://github.com/input-output-hk/haskell.nix/archive/"
    + "1031e80d1ae1a58e00ba7fd20f80ed23050c6f71.tar.gz"
    )) {};
  nixpkgsSrc = haskellNix.sources.nixpkgs-default;
  nixpkgsArgs = haskellNix.nixpkgsArgs;
in
  import nixpkgsSrc nixpkgsArgs
