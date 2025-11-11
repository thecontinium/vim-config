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

vim.api.nvim_set_keymap("n", "<leader>cnt", "", {
  noremap = true,
  silent = true,
  desc = "Open Tmux iPython Pane",
  callback = open_tmux_ipython_pane,
})

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
    "thecontinium/NotebookNavigator.nvim",
    branch = "add-new-repl",
    keys = {
      {
        "<leader>cnr<space>",
        function()
          require("which-key").show({ keys = "<leader>cnr", loop = true })
        end,
        desc = "Hydra Mode (which-key)",
      },
      { "<leader>cnc", "<cmd>normal gcih<cr>", desc = "Comment Cell" },
      { "<leader>cns", "<cmd>lua require('notebook-navigator').split_cell()<cr>", desc = "Split Cell" },

      -- running cells
      { "<leader>cnrR", "<cmd>lua require('notebook-navigator').run_cell()<cr>", desc = "Run Cell" },
      { "<leader>cnrr", "<cmd>lua require('notebook-navigator').run_and_move()<cr>", desc = "Run Cell and Move" },
      { "<leader>cnrb", "<cmd>lua require('notebook-navigator').run_all_cells()<cr>", desc = "Run Buffer" },
      {
        "<leader>cnra",
        "<cmd>lua require('notebook-navigator').run_cells_below()<cr>",
        desc = "Run Remaining Cells (incl.)",
      },
      {
        "<leader>cnrp",
        "<cmd>lua require('notebook-navigator').run_cells_above()<cr>",
        desc = "Run Previous Cells (excl.)",
      },
      { "<leader>cnrj", "<cmd>lua require('notebook-navigator').move_cell('d')<cr>", desc = "Next Cell" },
      { "<leader>cnrk", "<cmd>lua require('notebook-navigator').move_cell('u')<cr>", desc = "Previous Cell" },
      { "<leader>cnrt", open_tmux_ipython_pane, desc = "Tmux iPython Pane" },

      -- adding cells
      { "<leader>cnab", "<cmd>lua require('notebook-navigator').add_cell_below()<cr>", desc = "Add Cell Below" },
      { "<leader>cnaa", "<cmd>lua require('notebook-navigator').add_cell_above()<cr>", desc = "Add Cell Above" },

      -- move cell
      { "<leader>cnmu", "<cmd>lua require('notebook-navigator').swap_cell('u')<cr>", desc = "Move Cell Up" },
      { "<leader>cnmd", "<cmd>lua require('notebook-navigator').swap_cell('d')<cr>", desc = "Move Cell Down" },

      -- join cell
      {
        "<leader>cnja",
        "<cmd>lua require('notebook-navigator').merge_cell('u')<cr>",
        desc = "Join With Cell Above",
      },
      {
        "<leader>cnjb",
        "<cmd>lua require('notebook-navigator').merge_cell('d')<cr>",
        desc = "Join With Cell Below ",
      },
    },
    dependencies = {
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
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      local nn = require("notebook-navigator")
      wk.add({
        { "<leader>cn", group = "notebook" },
        { "<leader>cnr", group = "run/navigate" },
        { "<leader>cna", group = "add" },
        { "<leader>cnm", group = "move" },
        { "<leader>cnj", group = "join" },
      })
      nn.setup({
        cell_markers = {
          python = "# %%",
        },
        syntax_highlight = true,
        cell_highlight_group = "FloatShadow",
      })
    end,
  },
  {
    "nvim-mini/mini.ai",
    dependencies = { "NotebookNavigator.nvim" },
    opts = function(_, opts)
      local nn = require("notebook-navigator")
      opts.custom_textobjects.h = nn.miniai_spec
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
