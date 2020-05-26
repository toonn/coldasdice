{ pkgs ? import ./nixpkgs.nix
, haskellCompiler ? "ghc865"
}:
pkgs.haskell-nix.cabalProject {
  src = pkgs.haskell-nix.haskellLib.cleanSourceWith {
    name = "coldasdice-source";
    src = ./.;
    filter = path: type:
      (builtins.match "LICENSE|.*\.(cabal|hs)" (baseNameOf path)) != null;
  };
  ghc = pkgs.buildPackages.pkgs.haskell-nix.compiler.${haskellCompiler};
}
