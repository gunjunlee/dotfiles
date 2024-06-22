local options = {
  formatters_by_ft = {
    -- lua = { "stylua" },
    -- css = { "prettier" },
    -- html = { "prettier" },
    ["*"] = { "trim_whitespace" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,

    -- Only runt formatter "trim_whitespace" on save
    filter = function(formatter)
      return formatter.name == "trim_whitespace"
    end,
  },

  -- for debugging
  -- log_level = vim.log.levels.DEBUG,
}

require("conform").setup(options)
