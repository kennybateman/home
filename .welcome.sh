## UI STUFF ###################################################
# ex: OS: Debian GNU/Linux 13 (trixie), Version: 13.2, Kernel: 5.10.16.3-microsoft-standard-WSL2
echo "OS: $(grep -oP '(?<=PRETTY_NAME=")[^"]*' /etc/os-release), Version: $(grep -oP '(?<=DEBIAN_VERSION_FULL=).*' /etc/os-release), Kernel: $(uname -r), $(nix --version)"


echo "Welcome Home!"
ls --color=always
################################################################