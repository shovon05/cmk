#!/usr/bin/env bash
# KeyboardHibernate — installer
# Usage: curl -fsSL https://raw.githubusercontent.com/shovon05/kh/main/scripts/install.sh | bash

set -e

REPO="shovon05/kh"
BINARY_NAME="kh"
INSTALL_DIR="/usr/local/bin"

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
RESET='\033[0m'

echo ""
echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}${BOLD}║      ❄️   KeyboardHibernate Installer    ║${RESET}"
echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════╝${RESET}"
echo ""

# Check macOS
if [[ "$(uname)" != "Darwin" ]]; then
  echo -e "${RED}✗ kh only supports macOS.${RESET}"
  exit 1
fi

# Check Xcode Command Line Tools
if ! command -v swift &>/dev/null; then
  echo -e "${YELLOW}⚠ Swift not found. Installing Xcode Command Line Tools...${RESET}"
  xcode-select --install
  echo -e "${YELLOW}  Please re-run this installer after Xcode CLT finishes installing.${RESET}"
  exit 1
fi

echo -e "${BOLD}  Cloning repository...${RESET}"
TMP_DIR=$(mktemp -d)
git clone --depth 1 "https://github.com/${REPO}.git" "$TMP_DIR/kh" 2>/dev/null
cd "$TMP_DIR/kh"

echo -e "${BOLD}  Building (this may take ~30s the first time)...${RESET}"
swift build -c release 2>/dev/null

BUILT_BINARY=".build/release/${BINARY_NAME}"
if [[ ! -f "$BUILT_BINARY" ]]; then
  echo -e "${RED}✗ Build failed. Please check swift build output.${RESET}"
  exit 1
fi

echo -e "${BOLD}  Installing to ${INSTALL_DIR}/${BINARY_NAME}...${RESET}"
sudo cp "$BUILT_BINARY" "${INSTALL_DIR}/${BINARY_NAME}"
sudo chmod +x "${INSTALL_DIR}/${BINARY_NAME}"

cd ~
rm -rf "$TMP_DIR"

echo ""
echo -e "${GREEN}${BOLD}  ✅  kh installed successfully!${RESET}"
echo ""
echo -e "  Run ${CYAN}kh${RESET} in your terminal to get started."
echo ""
echo -e "${YELLOW}  ⚠  First run:${RESET} macOS will ask for Accessibility permission."
echo -e "  Go to ${BOLD}System Settings → Privacy & Security → Accessibility${RESET}"
echo -e "  and enable your Terminal app."
echo ""
