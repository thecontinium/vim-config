-- local conda_prefix = os.getenv("CONDA_PREFIX")
-- local python_path = nil
-- if conda_prefix ~= nil then
--   python_path = conda_prefix .. "/bin/python"
-- else
--   python_path = vim.g.python3_host_prog
-- end
--
-- vim.treesitter.language.register("markdown", "dap-view-term")
-- vim.treesitter.language.register("markdown", "terminal")
local function create_tmux_pane(init_cmds)
  -- create a pane to the right and capture its pane ID
  local handle = io.popen("tmux split-window -h -P -F '#{pane_id}'")
  local pane_id = handle:read("*a"):gsub("%s+", "")
  handle:close()

  -- run initialization commands in the new pane
  for _, cmd in ipairs(init_cmds or {}) do
    os.execute(("tmux send-keys -t %s %q Enter"):format(pane_id, cmd))
  end
end

vim.api.nvim_set_keymap("n", "<leader>cnt", "", {
  noremap = true,
  silent = true,
  desc = "tmux ipython pane",
  callback = function()
    local venv_path = require("venv-selector").venv()
    if not venv_path or venv_path == "" then
      vim.notify("No virtual environment selected!", vim.log.levels.WARN)
      return
    end

    local venv_name = vim.fn.fnamemodify(venv_path, ":t")
    create_tmux_pane({
      "pyenv activate " .. venv_name,
      [[ipython -i -c "import matplotlib.pyplot as plt; plt.style.use('dark_background');"]],
    })
  end,
})

return {

  { import = "lazyvim.plugins.extras.dap.core" },
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
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
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
    "GCBallesteros/jupytext.nvim",
    opts = {
      style = "hydrogen",
      output_extension = "py", -- Default extension. Don't change unless you know what you are doing
      force_ft = nil, -- Default filetype. Don't change unless you know what you are doing
      custom_language_formatting = {},
    },
    config = true,
    -- Depending on your nvim distro or config you may need to make the loading not lazy
    -- lazy=false,
  },

  {
    "thecontinium/NotebookNavigator.nvim",
    branch = "add-new-repl",
    keys = {
      {
        "]h",
        function()
          require("notebook-navigator").move_cell("d")
        end,
      },
      {
        "[h",
        function()
          require("notebook-navigator").move_cell("u")
        end,
      },
      {
        "<leader>cn<space>",
        function()
          require("which-key").show({ keys = "<leader>cn", loop = true })
        end,
        desc = "Notebook Naviagator Hydra Mode (which-key)",
      },
      { "<leader>cnR", "<cmd>lua require('notebook-navigator').run_cell()<cr>", desc = "run" },
      { "<leader>cnr", "<cmd>lua require('notebook-navigator').run_and_move()<cr>", desc = "run and move" },
      { "<leader>cnc", "<cmd>lua require('notebook-navigator').comment_cell()<cr>", desc = "comment cell" },
      { "<leader>cnb", "<cmd>lua require('notebook-navigator').run_all_cells()<cr>", desc = "run all buffer" },
      { "<leader>cna", "<cmd>lua require('notebook-navigator').run_cells_below()<cr>", desc = "run after" },
      { "<leader>cnp", "<cmd>lua require('notebook-navigator').run_cells_above()<cr>", desc = "run previous" },
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
