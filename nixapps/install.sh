# Reads default.nix:
# Installs each package in nix store.
# Creates custom derivation in nix store.
# Derivation in store has symlinks to packages in store.
nix-build $NIXAPPS -o $NIXAPPS/derivation && ln -sfn $NIXAPPS/derivation/bin/* $NIXAPPS

# Make symlinks in ~/nixapps to the symlinks in ~/nixapps/derivation/bin
ln -sfn $NIXAPPS/derivation/bin/* $NIXAPPS