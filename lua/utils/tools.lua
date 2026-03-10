local M = {}

--  Search order: venv → system PATH (non-mason) → TOOLS_INSTALL_DIR → mason fallback.

-- Platform detection
M.is_windows = vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1
M.path_sep = M.is_windows and '\\' or '/'
M.path_list_sep = M.is_windows and ';' or ':'
M.home = vim.fn.expand '~'

-- Configuration
local TOOLS_INSTALL_DIR = os.getenv 'TOOLS_INSTALL_DIR' or (M.home .. M.path_sep .. '.local' .. M.path_sep .. 'share' .. M.path_sep .. 'tools')

-- Helper function to find the executable in path, prioritizing non-mason paths
function M.find_executable(executable)
  -- On Windows, also search for .exe/.cmd/.bat variants
  local names = { executable }
  if M.is_windows then
    table.insert(names, executable .. '.exe')
    table.insert(names, executable .. '.cmd')
    table.insert(names, executable .. '.bat')
  end

  -- First try with PATH environment variable
  local paths = vim.split(vim.env.PATH, M.path_list_sep, { plain = true })
  for _, dir in ipairs(paths) do
    if dir ~= '' and not string.find(dir, 'mason') then
      for _, name in ipairs(names) do
        local path = dir .. M.path_sep .. name
        if vim.fn.filereadable(path) == 1 and vim.fn.executable(path) == 1 then
          return path
        end
      end
    end
  end

  -- Fallback to mason path if needed
  local path = vim.fn.exepath(executable)
  return path ~= '' and path or nil
end

-- Function to detect python venv path
function M.get_python_venv_path()
  -- Get the directory of the current file
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir = vim.fn.fnamemodify(current_file, ':h')

  -- Function to find git root
  local function find_git_root(path)
    local git_dir = vim.fn.finddir('.git', path .. ';')
    if git_dir ~= '' then
      return vim.fn.fnamemodify(git_dir, ':h')
    end
    return nil
  end

  -- Search paths in order: current directory, git root, user path
  local search_paths = {
    current_dir,
    find_git_root(current_dir),
    vim.fn.expand '~',
  }

  -- Check each search path for .venv
  for _, path in ipairs(search_paths) do
    if path then
      local venv_path = path .. M.path_sep .. '.venv'
      local venv_bin = M.is_windows and 'Scripts' or 'bin'
      if vim.fn.isdirectory(venv_path) == 1 then
        return venv_path .. M.path_sep .. venv_bin
      end
    end
  end

  -- Check for VIRTUAL_ENV environment variable (set by direnv or manually)
  local virtual_env = vim.env.VIRTUAL_ENV
  if virtual_env and virtual_env ~= '' then
    local venv_bin = M.is_windows and 'Scripts' or 'bin'
    return virtual_env .. M.path_sep .. venv_bin
  end

  -- Default to system path
  return nil
end

-- Helper function to recursively search for tool in directory (max depth 3)
local function search_tool_in_dir(dir, tool_name, current_depth)
  if current_depth > 3 then
    return nil
  end

  -- Check direct path
  local tool_path = dir .. M.path_sep .. tool_name
  if vim.fn.filereadable(tool_path) == 1 and vim.fn.executable(tool_path) == 1 then
    return tool_path
  end

  -- Check subdirectories
  if current_depth < 3 then
    local entries = vim.fn.globpath(dir, '*', false, true)
    for _, entry in ipairs(entries) do
      if vim.fn.isdirectory(entry) == 1 then
        local found = search_tool_in_dir(entry, tool_name, current_depth + 1)
        if found then
          return found
        end
      end
    end
  end

  return nil
end

-- Helper function to find executable in both venv and system PATH
function M.find_tool(tool_name)
  -- First check virtual env path
  local venv_path = M.get_python_venv_path()
  if venv_path then
    local tool_path = venv_path .. M.path_sep .. tool_name
    if vim.fn.filereadable(tool_path) == 1 then
      return tool_path
    end
  end

  -- Second, try system PATH (non-mason)
  local path_tool = M.find_executable(tool_name)
  if path_tool then
    return path_tool
  end

  -- Third, check TOOLS_INSTALL_DIR
  if vim.fn.isdirectory(TOOLS_INSTALL_DIR) == 1 then
    local tool_in_dir = search_tool_in_dir(TOOLS_INSTALL_DIR, tool_name, 1)
    if tool_in_dir then
      return tool_in_dir
    end
  end

  -- Final fallback to mason (if available)
  local mason_path = vim.fn.exepath(tool_name)
  return mason_path ~= '' and mason_path or nil
end

-- Get LSP capabilities with completion support (blink.cmp or nvim-cmp)
function M.get_lsp_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok, blink = pcall(require, 'blink.cmp')
  if ok then
    capabilities = blink.get_lsp_capabilities(capabilities)
  else
    local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if cmp_ok then
      capabilities = vim.tbl_deep_extend('force', capabilities, cmp_nvim_lsp.default_capabilities())
    end
  end
  return capabilities
end

-- Get LSP root directory for current buffer
function M.get_lsp_root()
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients { bufnr = buf }

  for _, client in ipairs(clients) do
    if client.config.root_dir then
      return client.config.root_dir
    end
  end

  -- Fallback to git root or current working directory
  local current_file = vim.api.nvim_buf_get_name(buf)
  local current_dir = vim.fn.fnamemodify(current_file, ':h')

  local git_root = vim.fs.dirname(vim.fs.find({ '.git' }, { path = current_dir, upward = true })[1])
  if git_root then
    return git_root
  end

  return vim.fn.getcwd()
end

return M
