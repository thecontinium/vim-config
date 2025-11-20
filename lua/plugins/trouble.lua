return {
  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>xo", require("util.vimgrep_buffer").todo, desc = "Todo Buffer (Trouble)" },
      { "<leader>xw", require("util.vimgrep_buffer").word, desc = "Word (Trouble)" },
    },
  },
}
