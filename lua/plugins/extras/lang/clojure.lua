return {

  { import = "lazyvim.plugins.extras.lang.clojure" },
  {
    "julienvincent/nvim-paredit",
    config = function()
      local paredit = require("nvim-paredit")
      paredit.setup({
        -- Change some keys
        keys = {
          -- Don't conflict with flash
          ["T"] = false,
          ["gh"] = {
            require("nvim-paredit").api.move_to_top_level_form_head,
            "Jump to top level form's head",
            repeatable = false,
            mode = { "n", "x", "v" },
          },
        },
      })
    end,
  },
}
