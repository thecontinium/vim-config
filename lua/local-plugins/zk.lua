require("zk").setup({
  debug = false,
  log = true,
  default_keymaps = true,
  default_notebook_path = vim.env.ZK_NOTEBOOK_DIR or "",
  fuzzy_finder = "fzf", -- or "telescope"
  link_format = "markdown" -- or "wiki"
})
