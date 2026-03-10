local tools = require 'utils.tools'

-- Get LSP capabilities with cmp support
local capabilities = tools.get_lsp_capabilities()

-- Default fallback root directory
local default_python_root = os.getenv 'DEFAULT_PYTHON_ROOT' or (vim.fn.expand '~' .. '/.nix-flake/.venv')

-- Set to false to see basedpyright "file/directory does not exist" messages
vim.g.suppress_pyright_dir_errors = true

-- Setup multiple Python LSP servers using autocmd (not via vim.lsp.enable)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    -- Stop any unwanted Python LSPs that may have been auto-started
    local unwanted_lsps = { 'pylsp', 'pyright', 'mypy' }
    local clients = vim.lsp.get_clients { bufnr = 0 }

    for _, client in ipairs(clients) do
      for _, unwanted in ipairs(unwanted_lsps) do
        if client.name == unwanted then
          vim.lsp.stop_client(client.id, true)
          vim.notify('Stopped unwanted LSP: ' .. client.name, vim.log.levels.INFO)
        end
      end
    end

    -- Common root directory lookup for all Python LSPs
    local current_file = vim.api.nvim_buf_get_name(0)
    local file_dir = vim.fs.dirname(current_file)
    local found_files = vim.fs.find(
      { 'pyproject.toml', 'setup.py', 'setup.cfg', '.venv', 'venv', 'requirements.txt', 'ruff.toml', 'uv.lock' },
      { path = file_dir, upward = true }
    )
    local root_dir = found_files[1] and vim.fs.dirname(found_files[1])

    -- Nothing python specific, but maybe the git workspace
    if not root_dir then
      local git_found = vim.fs.find('.git', { path = file_dir, upward = true })
      root_dir = git_found[1] and vim.fs.dirname(git_found[1])
    end

    -- Fallback to user defined default
    if not root_dir then
      root_dir = default_python_root
    end

    local pyright_path = tools.find_tool 'basedpyright-langserver'
    local ruff_path = tools.find_tool 'ruff'
    local python3_path = tools.find_tool 'python3' or tools.find_tool 'python'

    -- Setup pyright (hover and type checking)
    -- https://docs.basedpyright.com/dev/
    if pyright_path then
      local pyright_capabilities = vim.tbl_deep_extend('force', capabilities, {})

      vim.lsp.start {
        name = 'basedpyright',
        cmd = { pyright_path, '--stdio' },
        root_dir = root_dir,
        capabilities = pyright_capabilities,
        settings = {
          basedpyright = {
            analysis = {
              autoImportCompletion = true,
              autoSearchPaths = true,
              diagnosticMode = 'openFilesOnly',
              typeCheckingMode = 'off', -- 'basic',
              useLibraryCodeForTypes = true,
              inlayHints = {
                callArgumentNames = true,
              },
            },
            pythonPath = python3_path,
            extraPaths = vim.list_extend(
              (root_dir and vim.fn.isdirectory(root_dir .. '/python') == 1) and { root_dir .. '/python' } or {},
              vim.split(vim.env.PYTHONPATH or '', tools.is_windows and ';' or ':')
            ),
          },
          python = {
            pythonPath = python3_path,
          },
        },
        handlers = {
          ['textDocument/publishDiagnostics'] = function() end,
          ['window/showMessage'] = function(_, result, ...)
            if vim.g.suppress_pyright_dir_errors and result and result.message and result.message:match 'file/directory does not exist' then
              return
            end
            vim.lsp.handlers['window/showMessage'](_, result, ...)
          end,
        },
      }
    end

    -- Setup ruff (linting and formatting)
    if ruff_path then
      local ruff_capabilities = vim.tbl_deep_extend('force', capabilities, {})
      ruff_capabilities.textDocument.completion = nil
      ruff_capabilities.hoverProvider = false

      vim.lsp.start {
        name = 'ruff',
        cmd = { ruff_path, 'server' },
        root_dir = root_dir,
        capabilities = ruff_capabilities,
        handlers = {
          ['textDocument/hover'] = function() end,
          ['textDocument/completion'] = function() end,
        },
      }
    end
  end,
})


-- Return empty config since we handle Python LSP manually via autocmd above
return {}
