# This file is for specifying the exact nixpkgs versions to use.
# Without specifying this precisely, you get get stuck with whatever version you were given when first installing nix.
# The maintainers update versions every few hours: https://github.com/NixOS/nixpkgs
# It's more controlled to not automatically update to the latest version, but only update when necessary.

let
  downloadFromGithub = { version, name, owner, sha256 }:
    builtins.fetchTarball {
      name = "${name}-${version}";
      url = "https://github.com/${owner}/${name}/archive/${version}.tar.gz";
      inherit sha256;
    };
in
{
  # Use the date you started using it, not the date of the commit, as a variable name
  march_16_2026 = downloadFromGithub {
    version = "917fec9"; # https://github.com/NixOS/nixpkgs/commit/917fec990948658ef1ccd07cef2a1ef060786846
    owner = "NixOS";
    name = "nixpkgs";
    sha256 = "1x3hmj6vbza01cl5yf9d0plnmipw3ap6y0k5rl9bl11fw7gydvva";
  };
}