{
  description = "Neovim configuration with all required dependencies";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      # LSP servers and language tools
      lspServers = with pkgs; [
        # LSP servers from init.lua
        ast-grep
        clang-tools # clangd
        lua-language-server
        bash-language-server
        marksman
        basedpyright
        taplo
        yaml-language-server
        typescript-language-server
        dockerfile-language-server-nodejs

        # Conditional LSP servers
        gopls
        nil # Nix LSP

        # Python LSP servers (from python.lua)
        python3Packages.jedi-language-server
        ruff
      ];

      # Formatters and linters
      formattersLinters = with pkgs; [
        # From conform.lua and mason.lua
        alejandra # Nix formatter
        clang-tools # clang-format
        cmake-format
        isort
        nodePackages.prettier
        ruff
        shfmt
        stylua

        # Linters
        cmake-lint
        cpplint
        golangci-lint
        yamllint

        # Debuggers
        python3Packages.debugpy
      ];

      # Core tools
      coreTools = with pkgs; [
        # Essential tools
        ripgrep # Required by telescope
        fd # Better find
        git
        curl
        tree-sitter # CLI tool

        # Clipboard support
        xclip

        # Build tools
        gnumake
        gcc

        # Python environment
        python3
        python3Packages.pip
        python3Packages.virtualenv
      ];

      # Treesitter parsers (from treesitter.lua)
      treesitterParsers = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: with p; [
        bash
        c
        cmake
        cpp
        css
        cuda
        dockerfile
        dot
        go
        gomod
        html
        java
        javascript
        json
        json5
        latex
        llvm
        lua
        make
        markdown
        markdown_inline
        nix
        python
        query
        rst
        toml
        vim
        yaml
      ])).dependencies;

      # Neovim with configuration
      neovimConfig = pkgs.neovim.override {
        configure = {
          customRC = ''
            " Set up parser directory for treesitter
            lua vim.opt.runtimepath:prepend("${pkgs.symlinkJoin {
              name = "treesitter-parsers";
              paths = treesitterParsers;
            }}")
          '';
        };
      };

      # All dependencies combined
      allDependencies = lspServers ++ formattersLinters ++ coreTools ++ treesitterParsers;

      # Development shell
      devShell = pkgs.mkShell {
        buildInputs = [neovimConfig] ++ allDependencies;

        shellHook = ''
          echo "Neovim development environment loaded!"
          echo "All LSP servers, formatters, and tools are available."
          echo "Run 'nvim' to start Neovim with full configuration support."

          # Set up Python virtual environment path
          export PYTHONPATH="$HOME/.nix-flake/.venv:$PYTHONPATH"

          # Ensure treesitter parsers are available
          export TREE_SITTER_PARSER_DIR="${pkgs.symlinkJoin {
            name = "treesitter-parsers";
            paths = treesitterParsers;
          }}/parser"
        '';
      };
    in {
      # Default package is neovim with all dependencies
      packages.default = pkgs.symlinkJoin {
        name = "neovim-full";
        paths = [neovimConfig] ++ allDependencies;
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/nvim \
            --prefix PATH : ${pkgs.lib.makeBinPath allDependencies}
        '';
      };

      # Individual packages for flexibility
      packages.neovim = neovimConfig;
      packages.lsp-servers = pkgs.symlinkJoin {
        name = "lsp-servers";
        paths = lspServers;
      };
      packages.formatters-linters = pkgs.symlinkJoin {
        name = "formatters-linters";
        paths = formattersLinters;
      };
      packages.treesitter-parsers = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths = treesitterParsers;
      };

      # Development shell with all tools
      devShells.default = devShell;

      # Apps
      apps.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/nvim";
      };
    });
}

