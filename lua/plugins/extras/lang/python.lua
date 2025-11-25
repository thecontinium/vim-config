local function create_tmux_pane(init_cmds)
  -- create a pane to the right and capture its pane ID
  local handle = io.popen("tmux split-window -h -P -F '#{pane_id}'")
  if not handle then
    vim.notify("Failed to run tmux command (io.popen returned nil). Are you in tmux?")
    return
  end
  local pane_id = handle:read("*a"):gsub("%s+", "")
  handle:close()

  -- run initialization commands in the new pane
  for _, cmd in ipairs(init_cmds or {}) do
    os.execute(("tmux send-keys -t %s %q Enter"):format(pane_id, cmd))
  end
end

local function open_tmux_ipython_pane()
  local venv_path = require("venv-selector").venv()
  if not venv_path or venv_path == "" then
    vim.notify("No virtual environment selected!", vim.log.levels.WARN)
    return
  end

  local venv_name = vim.fn.fnamemodify(venv_path, ":t")
  create_tmux_pane({
    ("cd %s"):format(vim.fn.getcwd()),
    "pyenv activate " .. venv_name,
    [[ipython -i -c "import matplotlib.pyplot as plt; plt.style.use('dark_background');"]],
  })
end

return {
  -- uncomment to turn on dap and/or test support
  -- { import = "lazyvim.plugins.extras.dap.core" },
  -- { import = "lazyvim.plugins.extras.test.core" },

  { import = "lazyvim.plugins.extras.lang.python" },

  {
    "linux-cultist/venv-selector.nvim",
    opts = {
      options = {
        notify_user_on_venv_activation = true,
        enable_default_searches = false,
        -- debug = true,
      },
      search = {
        minis = {
          command = "fd 'bin/python$' /usr/local/Caskroom/miniconda/base/envs --full-path --color never",
          type = "anaconda",
        },
        pyenvs = {
          command = "fd '/bin/python$' $PYENV_ROOT/versions --full-path --color never -E pkgs/ -E envs/ -L",
        },
      },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_b, "venv-selector")
    end,
  },

  {
    "nvim-neotest/neotest",
    optional = true,
    opts = {
      adapters = {
        ["neotest-python"] = {
          dap = { justMyCode = false },
          args = { "--capture=no" },
          pytest_discover_instances = true,
        },
      },
    },
  },

  {
    "goerz/jupytext.nvim",
    version = "0.2.0",
    opts = {
      format = "py:hydrogen",
      filetype = "python",
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      -- Save original
      local original_on_attach = opts.on_attach

      -- Override opts.on_attach with wrapper
      opts.on_attach = function(buffer)
        if vim.api.nvim_buf_get_name(buffer):match("%.ipynb$") then
          return false
        else
          return original_on_attach(buffer)
        end
      end
    end,
  },
  {
    "nvim-mini/mini.hipatterns",
    event = "VeryLazy",
    opts = true,
  },
  {
    "nvim-mini/mini.ai",
    dependencies = { "NotebookNavigator.nvim" },
    opts = function(_, opts)
      local nn = require("notebook-navigator")
      opts.custom_textobjects.h = nn.miniai_spec
    end,
  },
  {
    "thecontinium/NotebookNavigator.nvim",
    branch = "add-new-repl",
    ft = "python",
    dependencies = {
      { "mini.hipatterns" },
      {
        "sourproton/tunnell.nvim",
        opts = {
          -- defaults are:
          cell_header = "# %%",
          tmux_target = '"{right-of}"',
        },
        cmd = {
          "TunnellRange",
        },
      },
    },
    config = function()
      local wk = require("which-key")
      local nn = require("notebook-navigator")

      nn.setup({
        cell_markers = {
          python = "# %%",
        },
      })

      require("util.python_markdown_injection").setup()

      -- Setup keybindings only for python files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          vim.b.minihipatterns_config = {
            highlighters = { cells = nn.minihipatterns_spec },
          }

          local opts = { buffer = true }

          wk.add({
            { "<leader>cn", group = "notebook", buffer = true },
            { "<leader>cnr", group = "run/navigate", buffer = true },
            { "<leader>cna", group = "add", buffer = true },
            { "<leader>cnm", group = "move", buffer = true },
            { "<leader>cnj", group = "join", buffer = true },
          })

          -- stylua: ignore
          vim.keymap.set( "n", "<leader>cnt", open_tmux_ipython_pane, vim.tbl_extend("force", opts, { desc = "Open Tmux iPython Pane" }))
          vim.keymap.set("n", "<leader>cnr<space>", function()
            require("which-key").show({ keys = "<leader>cnr", loop = true })
          end, vim.tbl_extend("force", opts, { desc = "Hydra Mode (which-key)" }))
          vim.keymap.set("n", "]h", function()
            nn.move_cell("d")
          end, vim.tbl_extend("force", opts, { desc = "Next Cell" }))
          vim.keymap.set("n", "[h", function()
            nn.move_cell("u")
          end, vim.tbl_extend("force", opts, { desc = "Previous Cell" }))
          vim.keymap.set(
            "n",
            "<leader>cnc",
            "<cmd>normal gcih<cr>",
            vim.tbl_extend("force", opts, { desc = "Comment Cell" })
          )
          vim.keymap.set("n", "<leader>cns", function()
            nn.split_cell()
          end, vim.tbl_extend("force", opts, { desc = "Split Cell" }))

          -- running cells
          vim.keymap.set("n", "<leader>cnrR", function()
            nn.run_cell()
          end, vim.tbl_extend("force", opts, { desc = "Run Cell" }))
          vim.keymap.set("n", "<leader>cnrr", function()
            nn.run_and_move()
          end, vim.tbl_extend("force", opts, { desc = "Run Cell and Move" }))
          vim.keymap.set("n", "<leader>cnrb", function()
            nn.run_all_cells()
          end, vim.tbl_extend("force", opts, { desc = "Run Buffer" }))
          vim.keymap.set("n", "<leader>cnra", function()
            nn.run_cells_below()
          end, vim.tbl_extend("force", opts, { desc = "Run Remaining Cells (incl.)" }))
          vim.keymap.set("n", "<leader>cnrp", function()
            nn.run_cells_above()
          end, vim.tbl_extend("force", opts, { desc = "Run Previous Cells (excl.)" }))
          vim.keymap.set("n", "<leader>cnrj", function()
            nn.move_cell("d")
          end, vim.tbl_extend("force", opts, { desc = "Next Cell" }))
          vim.keymap.set("n", "<leader>cnrk", function()
            nn.move_cell("u")
          end, vim.tbl_extend("force", opts, { desc = "Previous Cell" }))
          vim.keymap.set(
            "n",
            "<leader>cnrt",
            open_tmux_ipython_pane,
            vim.tbl_extend("force", opts, { desc = "Tmux iPython Pane" })
          )

          -- adding cells
          vim.keymap.set("n", "<leader>cnab", function()
            nn.add_cell_below()
          end, vim.tbl_extend("force", opts, { desc = "Add Cell Below" }))
          vim.keymap.set("n", "<leader>cnaa", function()
            nn.add_cell_above()
          end, vim.tbl_extend("force", opts, { desc = "Add Cell Above" }))

          -- move cell
          vim.keymap.set("n", "<leader>cnmu", function()
            nn.swap_cell("u")
          end, vim.tbl_extend("force", opts, { desc = "Move Cell Up" }))
          vim.keymap.set("n", "<leader>cnmd", function()
            nn.swap_cell("d")
          end, vim.tbl_extend("force", opts, { desc = "Move Cell Down" }))

          -- join cell
          vim.keymap.set("n", "<leader>cnja", function()
            nn.merge_cell("u")
          end, vim.tbl_extend("force", opts, { desc = "Join With Cell Above" }))
          vim.keymap.set("n", "<leader>cnjb", function()
            nn.merge_cell("d")
          end, vim.tbl_extend("force", opts, { desc = "Join With Cell Below" }))
        end,
      })
    end,
  },

  -- example nvim-dap setup for python
  -- {
  --   "mfussenegger/nvim-dap-python",
  --   opts = {
  --     justMyCode = false,
  --   },
  -- },
  -- {
  --   "mason-org/mason.nvim",
  --   opts = {
  --     ensure_installed = {
  --       "debugpy",
  --     },
  --   },
  -- },
}
