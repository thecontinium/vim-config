local zk = require("zk")
local commands = require("zk.commands")

zk.setup({
  -- can be "telescope", "fzf" or "select" (`vim.ui.select`)
  -- it's recommended to use "telescope" or "fzf"
  picker = "telescope",

  lsp = {
    -- `config` is passed to `vim.lsp.start_client(config)`
    config = {
      cmd = { "zk", "lsp" },
      name = "zk",
      -- on_attach = ...
      -- etc, see `:h vim.lsp.start_client()`
    },

    -- automatically attach buffers in a zk notebook that match the given filetypes
    auto_attach = {
      enabled = true,
      filetypes = { "markdown" },
    },
  },
})

-- Built-in Commands

-- Indexes the notebook
-- :ZkIndex [{options}]

-- cd into the notebook root
-- params(optional) additional options
-- :ZkCd [{options}]

-- Creates a new note and uses the last visual selection as the content while replacing the selection with a link to the new note
-- params (optional) additional options, see https://github.com/mickael-menu/zk/blob/main/docs/editors-integration.md#zknew
-- :'<,'>ZkNewFromContentSelection [{options}]

-- Opens a notes picker, filters for notes that match the text in the last visual selection
-- params(optional) additional options, see https://github.com/mickael-menu/zk/blob/main/docs/editors-integration.md#zklist
-- :'<,'>ZkMatch [{options}]

-- Creates and edits a new note
-- params (optional) additional options, see https://github.com/mickael-menu/zk/blob/main/docs/editors-integration.md#zknew
-- :ZkNew [{options}]
vim.api.nvim_set_keymap("n", "<LocalLeader>kc", "<cmd>ZkNew<CR>", { noremap = true })

-- Creates a new note and uses the last visual selection as the title while replacing the selection with a link to the new note
-- params (optional) additional options, see https://github.com/mickael-menu/zk/blob/main/docs/editors-integration.md#zknew
-- :'<,'>ZkNewFromTitleSelection [{options}]
vim.api.nvim_set_keymap("x", "<LocalLeader>kc", ":'<'>ZkNewFromTitleSelection<CR>", { noremap = true })

-- Opens a notes picker
-- params (optional) additional options, see https://github.com/mickael-menu/zk/blob/main/docs/editors-integration.md#zklist
-- :ZkNotes [{options}]
vim.api.nvim_set_keymap("n", "<LocalLeader>kn", "<cmd>ZkNotes {sort = {'modified'}, telescope = {matthew = true} }<CR>", { noremap = true })

-- Opens a notes picker for the backlinks of the current buffer
-- params (optional) additional options, see https://github.com/mickael-menu/zk/blob/main/docs/editors-integration.md#zklist
-- :ZkBacklinks [{options}]
vim.api.nvim_set_keymap("n", "<LocalLeader>kb", "<cmd>ZkBacklinks<CR>", { noremap = true })

-- Opens a notes picker for the outbound links of the current buffer
-- params "   (optional) additional options, see https://github.com/mickael-menu/zk/blob/main/docs/editors-integration.md#zklist
-- :ZkLinks [{options}]
vim.api.nvim_set_keymap("n", "<LocalLeader>kl", "<cmd>ZkLinks<CR>", { noremap = true })

-- Opens a notes picker, filters for notes with the selected tags
-- params (optional) additional options, see https://github.com/mickael-menu/zk/blob/main/docs/editors-integration.md#zktaglist
-- :ZkTags [{options}]
vim.api.nvim_set_keymap("n", "<LocalLeader>kt", "<cmd>ZkTags<CR>", { noremap = true })

-- Custom Commands

local function make_edit_fn(defaults, picker_options)
  return function(options)
    options = vim.tbl_extend("force", defaults, options or {})
    zk.edit(options, picker_options)
  end
end

commands.add("MyZkNotes", function(options)
  zk.edit(options, { title = "MyZk Notes",
    telescope = {_completion_callbacks = { function(_) zk.index({},function(stats) vim.notify(string.format("%s files removed from the index", vim.inspect(stats.removedCount))) end) end}}})
end)

commands.add("ZkOrphans", make_edit_fn({ orphan = true }, { title = "Zk Orphans" }))
vim.api.nvim_set_keymap("n", "<LocalLeader>ko", "<cmd>ZkOrphans<CR>", { noremap = true })

commands.add("ZkRecents", make_edit_fn({ createdAfter = "2 weeks ago" }, { title = "Zk Recents" }))
vim.api.nvim_set_keymap("n", "<LocalLeader>kr", "<cmd>ZkRecents<CR>", { noremap = true })

local function delete(options, picker_options, index_options, index_cb)
  zk.pick_notes(options, picker_options, function(notes)
    if picker_options.multi_select == false then
      notes = { notes }
    end
    local confo = string.format("Are you sure you want to delete these %s files [y/N)] ", #notes)
    if vim.fn.input(confo, "") == "y" then
      for _, note in ipairs(notes) do
        vim.fn.delete(note.absPath)
      end
      zk.index(index_options, index_cb)
    end
  end)
end

commands.add("ZkDelete", function(options) delete(options, { title = "Zk Delete" }, {}, function(stats) vim.notify(string.format("%s files removed from the index", vim.inspect(stats.removedCount))) end) end)
vim.api.nvim_set_keymap("n", "<LocalLeader>kd", "<cmd>ZkDelete {sort = {'modified'} }<CR>", { noremap = true })
