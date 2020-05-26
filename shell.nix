{ pkgs ? import ./nixpkgs.nix
, haskellCompiler ? "ghc865"
}:
let
  hsPkgs = import ./default.nix { inherit haskellCompiler pkgs; };
  haskell-nix = pkgs.haskell-nix;
  hackage-package = haskell-nix.hackage-package;
in hsPkgs.shellFor {
  packages = ps: with ps; [
    bfpt
  ];

  buildInputs =
    (with pkgs; # Packages that don't work from hsPkgs for some reason
    [ cabal-install
    ]

    ) ++ (with haskell-nix.haskellPackages; # Packages in the overlay
    [ ghcid.components.exes.ghcid
    ]

    ) ++ ( # Packages not in stackage-lts
    [ (hackage-package { name = "fast-tags";
                         version = "2.0.0"; }).components.exes.fast-tags
    ]);

  exactDeps = true;

  withHoogle = true;
}
