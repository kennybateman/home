let 
  nixpkgs = (import ./nixpkgs-versions.nix).march_16_2026;

in
  { pkgs ? import nixpkgs {} }:

    let
      packages = [
        # Ruby language
        pkgs.ruby
        pkgs.bundix # nix style gemset management

        # Rails support
        pkgs.nodejs # for js asset bundling
        pkgs.sqlite # database

        # Python language
        pkgs.python315
        pkgs.uv # python package and environment manager

        # General language support
        pkgs.gcc        # c-compiling
        pkgs.openssl    # networking
        pkgs.zlib       # compression
        pkgs.libffi     # for foreign function interfaces
        pkgs.libyaml    # for faster YAML parsing
        pkgs.pkg-config # for building native extensions
        pkgs.libxml2
        pkgs.libxslt
        pkgs.yarn
      ];

    in pkgs.mkShell {
      inherit packages;

      shellHook = ''
        # Print out the packages in the nix shell to a file for easy reference
        rm nix.txt # delete old file
        ${builtins.concatStringsSep "\n"
          (map (p: "echo ${p.pname or p.name} ${p.version or ""} >> ~/nix.txt" ) packages)}

        ~/.welcome.sh
      '';
    }