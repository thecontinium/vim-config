return {
  { import = "lazyvim.plugins.extras.lang.clojure" },
  {
    "Olical/conjure",
    -- load on ft instead of LazyFile
    event = function(_, event)
      -- remove any events that may trigger
      while #event ~= 0 do
        rawset(event, #event, nil)
      end
    end,
    ft = function()
      vim.g["conjure#filetypes"] = {
        -- remove python
        -- "python",
        "clojure",
        "fennel",
        "janet",
        "hy",
        "julia",
        "racket",
        "scheme",
        "lua",
        "lisp",
        "rust",
        "sql",
      }
      return vim.g["conjure#filetypes"]
    end,
    dependencies = {
      "folke/which-key.nvim",
    },
    opts = function() -- can't use init as it overides the extras
      -- vim.g["conjure#debug"] = true
      vim.g["conjure#client#python#stdio#delay-stderr-ms"] = 100
      vim.g["conjure#log#jump_to_latest#enabled"] = true
      vim.g["conjure#client_on_load"] = false
      vim.api.nvim_create_autocmd("filetype", {
        group = vim.api.nvim_create_augroup("group_conjure-wk", {}),
        pattern = vim.g["conjure#filetypes"],
        callback = function(args)
          local wk = require("which-key")
          wk.add({
            -- add conjure group names
            mode = "n",
            buffer = args.buf,
            { "<localleader>c", group = "+connect" },
            { "<localleader>cc", group = "+clay" }, -- will only show if clay is loaded
            { "<localleader>e", group = "+evaluate" },
            { "<localleader>ec", group = "+comment" },
            { "<localleader>g", group = "+get" },
            { "<localleader>l", group = "+log" },
            { "<localleader>r", group = "+refresh" },
            { "<localleader>s", group = "+session" },
            { "<localleader>t", group = "+test" },
            { "<localleader>v", group = "+display" },
            { "<localleader>x", group = "+run" },
          })
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        pattern = "ConjureDoc",
        callback = function(ev)
          vim.lsp.util.open_floating_preview(vim.split(ev.data, "\n"), "markdown", { border = "rounded" })
        end,
      })
    end,
  },
  -- blink.cmp conjure competion integration where conjure is only abailble in clojure filetypes
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "PaterJason/cmp-conjure", "saghen/blink.compat" },
    opts = {
      -- uncomment the below to see the source names in the completion menu
      -- completion = {
      --   menu = {
      --     draw = { columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } } },
      --   },
      -- },
      sources = {
        per_filetype = {
          clojure = {
            inherit_defaults = true,
            "conjure",
          },
        },
        providers = {
          conjure = {
            name = "conjure",
            module = "blink.compat.source",
            async = true,
          },
        },
      },
    },
  },
  {
    "julienvincent/nvim-paredit",
    init = function()
      -- set af,if which-key correctly
      vim.api.nvim_create_autocmd("filetype", {
        group = vim.api.nvim_create_augroup("group_paredit-wk", { clear = true }),
        pattern = "clojure", -- vim.g["conjure#filetypes"],
        callback = function(args)
          local wk = require("which-key")
          wk.add({
            mode = { "x", "o" },
            buffer = args.buf,
            { "af", desc = "Around form" },
            { "if", desc = "Inside form" },
          })
        end,
      })
    end,
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
          ["<localleader>w"] = {
            function()
              -- place cursor and set mode to `insert`
              paredit.cursor.place_cursor(
                -- wrap element under cursor with `( ` and `)`
                paredit.wrap.wrap_element_under_cursor("( ", ")"),
                -- cursor placement opts
                { placement = "inner_start", mode = "insert" }
              )
            end,
            "Wrap element insert head",
          },

          ["<localleader>W"] = {
            function()
              paredit.cursor.place_cursor(
                paredit.wrap.wrap_element_under_cursor("(", " )"),
                { placement = "inner_end", mode = "insert" }
              )
            end,
            "Wrap element insert tail",
          },

          -- same as above but for enclosing form
          ["<localleader>i"] = {
            function()
              paredit.cursor.place_cursor(
                paredit.wrap.wrap_enclosing_form_under_cursor("( ", ")"),
                { placement = "inner_start", mode = "insert" }
              )
            end,
            "Wrap form insert head",
          },

          ["<localleader>I"] = {
            function()
              paredit.cursor.place_cursor(
                paredit.wrap.wrap_enclosing_form_under_cursor("(", " )"),
                { placement = "inner_end", mode = "insert" }
              )
            end,
            "Wrap form insert tail",
          },
        },
      })
    end,
  },
  {
    -- "https://tangled.org/treybastian.com/nvim-jack-in",
    "thecontinium/nvim-jack-in",
    ft = "clojure",
    opts = function()
      Snacks.keymap.set("n", "<localleader>cn", "<cmd>Clj<cr>", { ft = "clojure", desc = "Jack-In Clj nRepl" })
      return {
        location = "background",
        clj_dependencies = {
          { name = "nrepl/nrepl", version = "1.5.2" },
          { name = "cider/cider-nrepl", version = "0.58.0" },
          { name = "djblue/portal", version = "0.62.2" },
          { name = "org.corfield/rephrase", version = "1.0.0" },
        },
        clj_middleware = {
          "cider.nrepl/cider-middleware",
          "org.corfield.rephrase.nrepl/wrap-rephrase",
        },
        cwd = function()
          return LazyVim.root()
        end,
      }
    end,
    config = true,
  },
  {
    "radovanne/clay.nvim",
    dependencies = { "Olical/conjure" },
    ft = { "clojure" },
    config = function()
      local clay = require("clay")
      Snacks.keymap.set("n", "<localleader>ccb", clay.ClayBrowse, { ft = "clojure", desc = "Browse Render" })
      Snacks.keymap.set("n", "<localleader>ccw", clay.ClayWatch, { ft = "clojure", desc = "Watch Notebooks Folder" })
      Snacks.keymap.set("n", "<localleader>ccf", clay.ClayMakeCurrentForm, { ft = "clojure", desc = "Render form" })
      Snacks.keymap.set("n", "<localleader>ccn", clay.ClayMakeFile, { ft = "clojure", desc = "Render Namespace/File" })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "clojure-lsp",
      },
    },
  },
  -- Ensure zipPlugin is installed for clojure
  -- so that libs can be loaded lsp gd works
  {
    name = "zipPlugin",
    dir = vim.env.VIMRUNTIME,
    ft = "clojure",
    init = function()
      vim.g.loaded_zipPlugin = nil
    end,
    config = function()
      vim.cmd.runtime("plugin/zipPlugin.vim")
    end,
  },
}
