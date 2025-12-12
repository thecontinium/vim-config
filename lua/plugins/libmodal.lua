return {
  {
    "Iron-E/nvim-libmodal",
    -- lazy = true, -- don't load until necessary
    -- version = "^3.0", -- OPTIONAL: unsubscribe from breaking changes
    name = "libmodal",
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "libmodal" },
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      -- Replace the first (and only) entry in lualine_a
      opts.sections.lualine_a[1] = {
        "mode",
        fmt = function(str)
          return vim.g.libmodalActiveModeName or str
        end,
        -- color = function(_)
        -- local ORANGE = "#ff8900"
        -- local ORANGE_LIGHT = "#f0af00"
        -- return (vim.g.libmodalActiveModeName and { fg = ORANGE }) or nil
        -- end,
      }
    end,
  },
}
