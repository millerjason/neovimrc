# Custom Keybindings

Leader key: `<Space>`

## General

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<C-l>` | n, i | Center line vertically and redraw | init.lua |
| `<C-s>` | n | Fuzzy search in current buffer | after/plugin/final.lua |
| `q` | n | Close window (qf, help, checkhealth buffers only) | init.lua |
| `,v` | n | Open venv selector | plugins/venv.lua |

## Tabs / Windows

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<F1>` | n, i, t | Previous tab | utils/windows.lua |
| `<F2>` | n, i, t | Next tab | utils/windows.lua |
| `<F3>` | n, i, t | New tab | utils/windows.lua |
| `<F4>` | n, i, t | Close tab | utils/windows.lua |
| `<F5>` | n, i, t | Open terminal in new tab | utils/windows.lua |

## Command-line Wildmenu

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<Up>` | c | Previous item / Up | init.lua |
| `<Down>` | c | Next item / Down | init.lua |
| `<Left>` | c | Scroll back / Left | init.lua |
| `<Right>` | c | Scroll forward / Right | init.lua |

## LSP (active on LspAttach)

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `gd` | n | Goto definition | lsp/keybindings.lua |
| `gI` | n | Goto implementation | lsp/keybindings.lua |
| `grn` | n | Rename symbol | lsp/keybindings.lua |
| `gra` | n | Code action | lsp/keybindings.lua |
| `grr` | n | Goto references | lsp/keybindings.lua |
| `gri` | n | Goto implementation | lsp/keybindings.lua |
| `grd` | n | Goto definition | lsp/keybindings.lua |
| `grD` | n | Goto declaration | lsp/keybindings.lua |
| `grt` | n | Goto type definition | lsp/keybindings.lua |
| `gO` | n | Document symbols | lsp/keybindings.lua |
| `gW` | n | Workspace symbols | lsp/keybindings.lua |

## Completion (blink.cmp, insert/cmdline mode)

Emacs-conflicting keys (`C-k`, `C-b`, `C-f`, `C-p`, `C-n`, `C-e`, `C-y`, `C-Space`) are disabled.

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<M-j>` | i | Select next completion | plugins/autocomplete-blink.lua |
| `<M-k>` | i | Select previous completion | plugins/autocomplete-blink.lua |
| `<M-h>` | i | Scroll documentation up | plugins/autocomplete-blink.lua |
| `<M-l>` | i | Scroll documentation down | plugins/autocomplete-blink.lua |
| `<Tab>` | i | Accept completion | plugins/autocomplete-blink.lua |
| `<C-g>` | i | Cancel completion | plugins/autocomplete-blink.lua |
| `<C-h>` | i | Show completions | plugins/autocomplete-blink.lua |
| `<C-right>` | i | Snippet jump forward | plugins/autocomplete-blink.lua |
| `<C-left>` | i | Snippet jump backward | plugins/autocomplete-blink.lua |
| `<up>/<down>` | i | Select prev/next completion | plugins/autocomplete-blink.lua |
| `<left>/<right>` | i | Scroll documentation up/down | plugins/autocomplete-blink.lua |

## Leader Keybindings

### Explore (`<leader>p`)

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<leader>pv` | n | Open netrw explorer | init.lua |

### Search (`<leader>s`) - Telescope

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<leader>sh` | n | Search help tags | plugins/telescope.lua |
| `<leader>sk` | n | Search keymaps | plugins/telescope.lua |
| `<leader>sf` | n | Search files | plugins/telescope.lua |
| `<leader>ss` | n | Search Telescope builtins | plugins/telescope.lua |
| `<leader>sw` | n | Search current word (grep) | plugins/telescope.lua |
| `<leader>sg` | n | Search by live grep | plugins/telescope.lua |
| `<leader>sd` | n | Search diagnostics | plugins/telescope.lua |
| `<leader>sr` | n | Resume last search | plugins/telescope.lua |
| `<leader>s.` | n | Search recent files | plugins/telescope.lua |
| `<leader>s/` | n | Search in open files | plugins/telescope.lua |
| `<leader>/` | n | Fuzzy search in current buffer | plugins/telescope.lua |

### Find (`<leader>f`) - Telescope

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<leader>ff` | n | Find files | plugins/telescope.lua |
| `<leader>fg` | n | Find by grep | plugins/telescope.lua |
| `<leader>fb` | n | Find buffers | plugins/telescope.lua |
| `<leader>fh` | n | Find help tags | plugins/telescope.lua |
| `<leader>fG` | n | Grep with manual input | plugins/telescope.lua |
| `<leader>fo` | n | Format buffer | plugins/conform.lua |

### LSP (`<leader>`)

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<leader>D` | n | Type definition | lsp/keybindings.lua |
| `<leader>ds` | n | Document symbols | lsp/keybindings.lua |
| `<leader>ws` | n | Workspace symbols | lsp/keybindings.lua |
| `<leader>rn` | n | Rename symbol | lsp/keybindings.lua |
| `<leader>ca` | n | Code action | lsp/keybindings.lua |
| `<leader>q` | n | Quickfix diagnostics | init.lua |

### Toggles (`<leader>t`)

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<leader>ta` | n | Toggle autocomplete | plugins/autocomplete-blink.lua |
| `<leader>tB` | n | Toggle git blame | plugins/gitsigns.lua |
| `<leader>tD` | n | Toggle deleted git lines | plugins/gitsigns.lua |
| `<leader>td` | n | Toggle diagnostics | lsp/keybindings.lua |
| `<leader>tf` | n | Toggle format on save | plugins/conform.lua |
| `<leader>th` | n | Toggle inlay hints | lsp/keybindings.lua |
| `<leader>ts` | n | Toggle signature help | lsp/keybindings.lua |

### Windows/Tabs (`<leader>w`)

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<leader>wn` | n | Next tab | utils/windows.lua |
| `<leader>wp` | n | Previous tab | utils/windows.lua |
| `<leader>wo` | n | Open new tab | utils/windows.lua |
| `<leader>wc` | n | Close tab | utils/windows.lua |

### Misc Leader

| Key | Mode | Action | Source |
|-----|------|--------|--------|
| `<leader>ib` | n | Toggle indent lines | plugins/indent_line.lua |
| `<leader>lc` | n | Open Claude Code | plugins/claude-code.lua |
