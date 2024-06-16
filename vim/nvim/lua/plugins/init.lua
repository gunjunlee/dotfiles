return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local nvchad_opts = require "nvchad.configs.cmp"
      local custom_opts = require "configs.cmp"
      local new_opts = vim.tbl_deep_extend("force", nvchad_opts, custom_opts)
      return new_opts
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = function()
      local nvchad_opts = require "nvchad.configs.telescope"
      local custom_opts = require "configs.telescope"
      local new_opts = vim.tbl_deep_extend("force", nvchad_opts, custom_opts)
      return new_opts
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
    end,
  },

  -- custom plugins

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = { "InsertEnter", "LspAttach" },
    config = function()
      require("copilot").setup {
        panel = {
          enabled = false,
        },
        suggestion = {
          enabled = false,
          --          auto_trigger = true,
        },
        filetypes = {
          ["*"] = true,
        },
      }
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    event = { "InsertEnter", "LspAttach" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  {
    "mg979/vim-visual-multi",
    event = "BufRead",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
        ["Find Subword Under"] = "<C-d>",
      }
      vim.g.VM_theme = "paper"
    end,
  },

  {
    'numToStr/Comment.nvim',
    event = "BufRead",
    config = function()
      require('Comment').setup()
    end
  },


  -- {
  --   'Bekaboo/dropbar.nvim',
  --   event = "BufRead",
  --   dependencies = {
  --     'nvim-telescope/telescope-fzf-native.nvim'
  --   }
  -- },
  {
    "utilyre/barbecue.nvim",
    event = "BufRead",
    name = "barbecue",
    cmd = "Barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    config = function()
      require("barbecue").setup()
    end,
  },
  -- {
  -- 	"williamboman/mason.nvim",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"lua-language-server", "stylua",
  -- 			"html-lsp", "css-lsp" , "prettier"
  -- 		},
  -- 	},
  -- },
  --
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
