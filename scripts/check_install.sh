#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Status indicators
OKAY="${GREEN}✓ OKAY${NC}"
MISSING="${RED}✗ MISSING${NC}"

# Core tools from flake.nix
CORE_TOOLS=(
    "nvim"
    "rg" # ripgrep
    "fd"
    "git"
    "curl"
    "tree-sitter"
    "xclip"
    "make"
    "gcc"
    "python3"
    "pip"
)

# LSP servers from flake.nix
LSP_SERVERS=(
    "ast-grep"
    "clangd"
    "lua-language-server"
    "bash-language-server"
    "marksman"
    "basedpyright"
    "taplo"
    "yaml-language-server"
    "typescript-language-server"
    "docker-langserver"
    "gopls"
    "nil"
    "jedi-language-server"
    "ruff"
)

# Formatters and linters from flake.nix
FORMATTERS_LINTERS=(
    "alejandra"
    "clang-format"
    "cmake-format"
    "isort"
    "prettier"
    "shfmt"
    "stylua"
    "cmake-lint"
    "cpplint"
    "golangci-lint"
    "yamllint"
)

# Treesitter parsers to check
TREESITTER_PARSERS=(
    "bash"
    "c"
    "cmake"
    "cpp"
    "css"
    "cuda"
    "diff"
    "dockerfile"
    "dot"
    "go"
    "gomod"
    "html"
    "java"
    "javascript"
    "json"
    "json5"
    "latex"
    "llvm"
    "lua"
    "make"
    "markdown"
    "markdown_inline"
    "nix"
    "python"
    "query"
    "rst"
    "toml"
    "vim"
    "vimdoc"
    "yaml"
)

echo -e "${BLUE}=== Neovim Environment Check ===${NC}"
echo

# Function to check if command exists
check_command() {
    if command -v "$1" &> /dev/null; then
        echo -e "$1: $OKAY"
        return 0
    else
        echo -e "$1: $MISSING"
        return 1
    fi
}

# Check Neovim version
echo -e "${YELLOW}Checking Neovim version...${NC}"
if command -v nvim &> /dev/null; then
    VERSION=$(nvim --version | head -1 | cut -d'v' -f2 | cut -d' ' -f1)
    echo -e "Neovim v$VERSION: $OKAY"
else
    echo -e "Neovim: $MISSING"
    exit 1
fi
echo

# Check core tools
echo -e "${YELLOW}Checking core tools...${NC}"
CORE_MISSING=0
for tool in "${CORE_TOOLS[@]}"; do
    if ! check_command "$tool"; then
        CORE_MISSING=$((CORE_MISSING + 1))
    fi
done
echo

# Check LSP servers
echo -e "${YELLOW}Checking LSP servers...${NC}"
LSP_MISSING=0
for lsp in "${LSP_SERVERS[@]}"; do
    if ! check_command "$lsp"; then
        LSP_MISSING=$((LSP_MISSING + 1))
    fi
done
echo

# Check formatters and linters
echo -e "${YELLOW}Checking formatters and linters...${NC}"
FORMATTERS_MISSING=0
for formatter in "${FORMATTERS_LINTERS[@]}"; do
    if ! check_command "$formatter"; then
        FORMATTERS_MISSING=$((FORMATTERS_MISSING + 1))
    fi
done
echo

# Check treesitter parsers via headless neovim
echo -e "${YELLOW}Checking treesitter parsers...${NC}"
PARSER_MISSING=0

# Get installed parsers from TSInstallInfo
INSTALLED_PARSERS=$(nvim --headless -c "lua vim.cmd('TSInstallInfo')" -c "sleep 100m" -c "qa" 2>&1 | grep '\[✓\] installed' | awk '{print $1}')

for parser in "${TREESITTER_PARSERS[@]}"; do
    if echo "$INSTALLED_PARSERS" | grep -q "^$parser$"; then
        echo -e "$parser: $OKAY"
    else
        echo -e "$parser: $MISSING"
        PARSER_MISSING=$((PARSER_MISSING + 1))
    fi
done
echo

# Summary
echo -e "${BLUE}=== Summary ===${NC}"
TOTAL_MISSING=$((CORE_MISSING + LSP_MISSING + FORMATTERS_MISSING + PARSER_MISSING))

if [ $TOTAL_MISSING -eq 0 ]; then
    echo -e "${GREEN}✓ All dependencies are available!${NC}"
    exit 0
else
    echo -e "${RED}✗ $TOTAL_MISSING dependencies are missing:${NC}"
    [ $CORE_MISSING -gt 0 ] && echo -e "  - $CORE_MISSING core tools"
    [ $LSP_MISSING -gt 0 ] && echo -e "  - $LSP_MISSING LSP servers"
    [ $FORMATTERS_MISSING -gt 0 ] && echo -e "  - $FORMATTERS_MISSING formatters/linters"
    [ $PARSER_MISSING -gt 0 ] && echo -e "  - $PARSER_MISSING treesitter parsers"
    echo
    echo -e "${YELLOW}Run 'nix develop' to enter the development shell with all dependencies.${NC}"
    exit 1
fi

