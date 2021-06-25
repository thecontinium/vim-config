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
wk.register({["P"]="which_key_ignore"})

wk.register({
  [","] = {
      ["f"]= { "LSP Formatting" },
      E = { "Conjure Eval Selection" },
      e = { name = "Conjure Eval",
            ["!"] = "Replace Form",
            ["e"] = "Form",
            ["b"] = "Buffer",
            ["f"] = "File",
            ["m"] = "Marked",
            ["i"] = "Interupt",
            ["r"] = "Root",
            ["w"] = "Word",
            ["c"] = { name= "Comment",
                      e = "Form",
                      r = "Root",
                      w = "Word"
            },
      },
      w = { "Sexp (_element)" },
      W = { "Sexp (element_)" },
      i = { "Sexp (_form)" },
      I = { "Sexp (form_)" },
      h = { "Sexp _form" },
      l = { "Sexp form_" },
      ["?"] = { "Sexp Convolute" },
      ["d"] = { "Sexp Splice" },
      ["o"] = { "Sexp Raise form" },
      ["O"] = { "Sexp Raise element" },
  },
})
wk.register({
  ["<LocalLeader>"] = {
      a = { "Explore File" },
      c = { "Action Menu" },
      e = { "Explore Toggle" },
      f = { "Find File" },
      g = { "Grep" },
      b = { "Buffers" },
      h = { "Highlights" },
      j = { "Jumps" },
      m = { "Marks" },
      s = { "Sessions" },
      u = { "Spell Suggest" },
      v = { "Registers" },
      x = { "Old Files" },
      z = { "Z Oxide" },
      [";"] = { "Commands" },
      ["/"] = { "Search History" },
  },
})


wk.register({
  ["<Leader>"] = {
      ["b"] = { "Symbols"},
      ["l"] = { "Side Menu" },
      ["d"] = { "Duplicate Line" },
      ["j"] = { "Move Line Down" },
      ["K"] = { "Thesaurus" },
      ["k"] = { "Mpve Line Up" },
      ["S"] = { "Source Line" },
      ["w"] = { "Save" },
      ["e"] = { "Lsp Diagnostics" },
      ["v"] = { "Comment line" },
      ["W"] = { "Wiki" },
      ["y"] = { "Yank Relative Path" },
      ["Y"] = { "Yank Absolute Path" },
      ["V"] = { "Comment Block" },
      ["?"] = { "Dictionary" },
      ["-"] = { "Choose Window" },
      [";"] = { "Git Grep" },
      ["t"] = { name = "Toggle",
                ["w"] = "Wrap",
                ["s"] = "Spell",
                ["n"] = "Line Numbers",
                ["i"] = "Indent Guides",
                ["l"] = "Hidden Characters",
                ["h"] = "Highlight Search",
      },
      ["g"] = { name = "Git",
                ["a"] = "Add Current File",
                ["s"] = "Status",
                ["l"] = "Log",
                ["L"] = "Log Current File",
                ["F"] = "Fetch",
                ["b"] = "Blame",
                ["c"] = "Commit",
                ["d"] = "Diff",
                ["p"] = "Push",
                ["r"] = "Undo Hunk",
                ["v"] = "Diff View",
      },
  },
})
