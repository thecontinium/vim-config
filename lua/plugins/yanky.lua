return {

  "gbprod/yanky.nvim",
  keys = {
    -- stylua: ignore
    { "y",         "<Plug>(YankyYank)",                      mode = { "n", "x" },                           desc = "Yank Text" },
    {
      "p",
      "<Plug>(YankyPutAfter)",
      mode = { "n", "x" },
      desc = "Put Yanked Text After Cursor",
    },
    {
      "P",
      "<Plug>(YankyPutBefore)",
      mode = { "n", "x" },
      desc = "Put Yanked Text Before Cursor",
    },
    {
      "gp",
      "<Plug>(YankyGPutAfter)",
      mode = { "n", "x" },
      desc = "Put Yanked Text After Selection",
    },
    {
      "gP",
      "<Plug>(YankyGPutBefore)",
      mode = { "n", "x" },
      desc = "Put Yanked Text Before Selection",
    },
    { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
    { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
    { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
    { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
    { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
    { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
    { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" },
    { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" },
    { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put Before and Indent Right" },
    { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put Before and Indent Left" },
    { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put After Applying a Filter" },
    { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put Before Applying a Filter" },
    {
      "<leader>p",
      "<cmd>Telescope yank_history<CR>",
      mode = { "n", "x" },
      desc = "Open Yank History",
    },
  },
  config = function()
    local utils = require("yanky.utils")
    local mapping = require("yanky.telescope.mapping")
    local yanky = require("yanky")
    yanky.setup({
      highlight = {
        timer = 150,
      },
      picker = {
        telescope = {
          mappings = {
            default = mapping.put("p"),
            i = {
              ["<c-p>"] = mapping.put("p"),
              ["<c-k>"] = mapping.put("P"),
              ["<c-x>"] = mapping.delete(),
              ["<c-r>"] = mapping.set_register(utils.get_default_register()),
              ["<c-c>"] = mapping.special_put("YankyPutAfterCharwiseJoined"),
            },
            n = {
              p = mapping.put("p"),
              P = mapping.put("P"),
              d = mapping.delete(),
              r = mapping.set_register(utils.get_default_register()),
              c = mapping.special_put("YankyPutAfterCharwiseJoined"),
            },
          },
        },
      },
    })
    require("telescope").load_extension("yank_history")
  end,
}
