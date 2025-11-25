return {
  {
    "AndrewRadev/linediff.vim",
    cmd = { "Linediff", "LinediffAdd" },
    keys = {
      { "<leader>mf", ":Linediff<CR>", mode = "x", desc = "Diff" },
      { "<leader>ma", ":LinediffAdd<CR>", mode = "x", desc = "Add" },
      { "<leader>ms", "<cmd>LinediffShow<CR>", desc = "Show" },
      { "<leader>mr", "<cmd>LinediffReset<CR>", desc = "Reset" },
    },
    init = function()
      LazyVim.on_load("which-key.nvim", function()
        vim.schedule(function()
          local wk = require("which-key")
          wk.add({
            { "<leader>m", group = "linediff" },
          })
        end)
      end)
    end,
  },
}
