let 
  home = builtins.getEnv "HOME";
  version = (import "${home}/nixpkgs.nix").march_16_2026;

in
  { nixpkgs ? import version {} }:

    let
      packages = [
        # Ruby language
        nixpkgs.ruby
        nixpkgs.bundix # nix style gemset management

        # Rails support
        nixpkgs.nodejs # for js asset bundling
        nixpkgs.sqlite # database

        # Python language
        nixpkgs.python315
        nixpkgs.uv # python package and environment manager

        # General language support
        nixpkgs.gcc        # c-compiling
        nixpkgs.openssl    # networking
        nixpkgs.zlib       # compression
        nixpkgs.libffi     # for foreign function interfaces
        nixpkgs.libyaml    # for faster YAML parsing
        nixpkgs.pkg-config # for building native extensions
        nixpkgs.libxml2
        nixpkgs.libxslt
        nixpkgs.yarn
      ];

    in nixpkgs.mkShell {
      inherit packages;

      shellHook = ''
        # Print out the packages in the nix shell to a file for easy reference
        rm nix.txt 2>/dev/null # delete old file if exists
        ${builtins.concatStringsSep "\n"
          (map (p: "echo ${p.pname or p.name} ${p.version or ""} >> nix.txt" ) packages)}
      '';
    }