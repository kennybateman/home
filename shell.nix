{ pkgs ? import <nixpkgs> {},  
  nixpkgs-ruby ? import (builtins.fetchTarball { url = "https://github.com/bobvanderlinden/nixpkgs-ruby/archive/c1ba161adf31119cfdbb24489766a7bcd4dbe881.tar.gz"; }), 
  ruby322 ? nixpkgs-ruby.packages.${builtins.currentSystem}."ruby-3.2.2"
}:


let
  packages = [
    # Ruby language
    ruby322
    pkgs.bundix # nix style gemset management

    # Rails support
    pkgs.nodejs # for js asset bundling
    pkgs.sqlite # database
    #pkgs.imagemagick # for image processing, used by ActiveStorage
    #pkgs.libvips # for faster image processing, used by ActiveStorage


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
    # bundix fails when it tries to write to /tmp, changing it to $HOME/tmp works fine
    export TMPDIR=$HOME/tmp
    mkdir -p $TMPDIR

    # Print out the packages in the nix shell to a file for easy reference
    rm nix.txt
    ${builtins.concatStringsSep "\n"
      (map (p: "echo ${p.pname or p.name} ${p.version or ""} >> ~/nix.txt" ) packages)}

    ~/.welcome.sh
  '';
}