#!/bin/bash

# Define the base install directory
BASE_DIR="."

# Define the target architectures
ARCHS=("x86_64-unknown-linux-gnu" "aarch64-unknown-linux-gnu")

# Define the crates to install
CRATES="starship eza bandwhich bat bottom du-dust kondo procs zoxide ripgrep"

if ! command -v aarch64-linux-gnu-gcc &>/dev/null; then
    # Update and install cross-compilation toolchain
    echo "Installing cross-compilation toolchain for aarch64..."
    sudo apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
fi

# Loop through each architecture
for ARCH in "${ARCHS[@]}"; do
    INSTALL_DIR="$BASE_DIR/$ARCH"
    
    echo "Checking if Rust target $ARCH is installed..."
    if ! rustup target list | grep -q "$ARCH (installed)"; then
        echo "Target $ARCH is not installed. Installing now..."
        rustup target add $ARCH
    else
        echo "Target $ARCH is already installed."
    fi

    echo "Creating installation directory at $INSTALL_DIR"
    mkdir -p "$INSTALL_DIR"

    cargo install --config cargo.toml --target $ARCH --root "$INSTALL_DIR" $CRATES
done
