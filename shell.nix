{ pkgs ? import ~/src/nix-config/haskell.nix/nixpkgs.nix
, compiler-nix-name ? "ghc8102"
, shell ? import ~/src/nix-config/haskell.nix/shell.nix
}:
let hsPkgs = import ./default.nix { inherit pkgs compiler-nix-name; };
in shell { inherit hsPkgs; for = with hsPkgs; [ coldasdice ]; }
