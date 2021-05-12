local wk = require("which-key")

wk.setup {
  plugins = {
      -- ...
      presets = {
        operators = false
        -- ..
      },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    operators = {
      d = "Delete",
      c = "Change",
      y = "Yank (copy)",
      ["g~"] = "Toggle case",
      ["gu"] = "Lowercase",
      ["gU"] = "Uppercase",
      [">"] = "Indent right",
      ["<lt>"] = "indent left",
      ["zf"] = "create fold",
      ["!"] = "filter though external program",
      ["v"] = "Visual Character Mode",
      gc = "Comments"
  },
}

wk.register({["p"]="which_key_ignore"})
