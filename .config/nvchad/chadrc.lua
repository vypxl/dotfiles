local M = {}

M.mappings = require("custom.mappings")

M.ui = {
  theme = "chadracula",
  statusline = {
    overriden_modules = function()
      return {
        LSP_progress = function()
          return ""
        end,
      }
    end,
  },
}


M.plugins = "custom.my-plugins"

return M
