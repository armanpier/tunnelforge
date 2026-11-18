#!/usr/bin/env bash
# ==============================================================================
# TunnelForge Installer
# Quick Install: bash <(curl -fsSL https://raw.githubusercontent.com/armanpier/TunnelForge/main/install.sh)
# ==============================================================================

set -e

REPO_RAW="https://raw.githubusercontent.com/armanpier/TunnelForge/main"
TARGET_BIN="/usr/local/bin/tunnelforge"
SYMLINK_BIN="/usr/local/bin/tunnel"

# Colors
C_RESET="\033[0m"
C_GREEN="\033[1;32m"
C_CYAN="\033[1;36m"
C_RED="\033[1;31m"
C_YELLOW="\033[1;33m"

if [[ $EUID -ne 0 ]]; then
    echo -e "${C_RED}[ERROR]${C_RESET} Please run this installer as root (e.g. sudo bash ...)"
    exit 1
fi

echo -e "${C_CYAN}"
echo "========================================================"
echo "          Installing TunnelForge Suite                  "
echo "========================================================"
echo -e "${C_RESET}"

# Install curl if not present
if ! command -v curl >/dev/null 2>&1; then
    echo -e "${C_YELLOW}[*] Installing curl...${C_RESET}"
    if command -v apt-get >/dev/null 2>&1; then
        apt-get update -y && apt-get install -y curl
    elif command -v dnf >/dev/null 2>&1; then
        dnf install -y curl
    elif command -v yum >/dev/null 2>&1; then
        yum install -y curl
    fi
fi

echo -e "${C_CYAN}[*] Downloading TunnelForge script...${C_RESET}"
if curl -sSL "${REPO_RAW}/tunnelforge" -o "$TARGET_BIN"; then
    chmod +x "$TARGET_BIN"
    ln -sf "$TARGET_BIN" "$SYMLINK_BIN"
    echo -e "${C_GREEN}[+] TunnelForge installed successfully to ${TARGET_BIN}${C_RESET}"
    echo -e "${C_GREEN}[+] Command alias created: ${C_CYAN}tunnel${C_RESET}"
    echo ""
    sleep 1
    exec "$TARGET_BIN"
else
    echo -e "${C_RED}[ERROR] Failed to download TunnelForge script.${C_RESET}"
    exit 1
fi
