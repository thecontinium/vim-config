return {
  { import = "lazyvim.plugins.extras.coding.yanky" },
  {
    "gbprod/yanky.nvim",
    keys = {
      { "Pc", "<Plug>(YankyPutBeforeCharwiseJoined)", mode = { "n", "x" }, desc = "Put Before Charwise" },
      { "pc", "<Plug>(YankyPutAfterCharwiseJoined)", mode = { "n", "x" }, desc = "Put After Charwise" },
      { "Pl", "<Plug>(YankyPutBeforeLinewiseJoined)", mode = { "n", "x" }, desc = "Put Before Linewise" },
      { "pl", "<Plug>(YankyPutAfterLinewiseJoined)", mode = { "n", "x" }, desc = "Put Before Linewise" },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      { "marcoSven/blink-cmp-yanky" },
    },
    opts = {
      sources = {
        default = { "yank" },
        providers = {
          yank = {
            name = "yank",
            module = "blink-yanky",
            opts = {
              minLength = 5,
              onlyCurrentFiletype = true,
              trigger_characters = { '"' },
              kind_icon = "󰅍",
            },
          },
        },
      },
    },
  },
}
