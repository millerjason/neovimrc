local tools = require 'utils.tools'

local capabilities = tools.get_lsp_capabilities()

return {
  name = 'yamlls',
  cmd = { tools.find_tool 'yaml-language-server' or 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml', 'yml' },
  root_dir = vim.fs.dirname(vim.fs.find({ '.git', 'docker-compose.yml', 'docker-compose.yaml' }, { upward = true })[1]),
  capabilities = capabilities,
  settings = {
    telemetry = {
      enabled = false,
    },
    yaml = {
      schemas = {
        ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
        ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = '/docker-compose*.{yml,yaml}',
        ['https://json.schemastore.org/kustomization.json'] = 'kustomization.{yml,yaml}',
        ['https://json.schemastore.org/chart.json'] = '/Chart.{yml,yaml}',
      },
    },
  },
}
