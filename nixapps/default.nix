let
  home = builtins.getEnv "HOME";
  version = (import "${home}/nixpkgs.nix").march_16_2026;
  nixpkgs = import version {};
  packages = [ 
      nixpkgs.direnv
      # others...
    ];

in
  nixpkgs.buildEnv {
    name = "outershell-nixapps-env";
    paths = packages;
  }
