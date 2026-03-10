# LSP Servers

| LSP Name | Filetypes | Server Executable | Nixpkgs Package |
|----------|-----------|-------------------|-----------------|
| ast_grep | java, javascript, html | `ast-grep` | `ast-grep` |
| bashls | sh, bash | `bash-language-server` | `bash-language-server` |
| basedpyright | python | `basedpyright-langserver` | `basedpyright` |
| clangd | c, cpp, h, hpp | `clangd` | `clang-tools` |
| dockerls | dockerfile | `docker-langserver` | `dockerfile-language-server-nodejs` |
| gopls | go | `gopls` | `gopls` |
| lua_ls | lua | `lua-language-server` | `lua-language-server` |
| marksman | markdown | `marksman` | `marksman` |
| nixd | nix | `nixd` | `nixd` |
| ruff | python | `ruff` | `ruff` |
| taplo | toml | `taplo` | `taplo` |
| ts_ls | typescript, javascript | `typescript-language-server` | `typescript-language-server` |
| yamlls | yaml, yml | `yaml-language-server` | `yaml-language-server` |

Notes:
- Python uses two servers: `basedpyright` (type checking/hover) and `ruff` (linting/formatting)
- `clangd` and `gopls` use autocmd-based setup rather than `vim.lsp.enable()`
- `nil_ls.lua` configures `nixd` (the filename is a legacy name)
- All executables are resolved via `utils.tools.find_tool()` with PATH fallback
