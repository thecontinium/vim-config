local opt = vim.opt

-- What to save for views and sessions
opt.sessionoptions:remove({ 'help' })
opt.sessionoptions:remove({ 'folds' })
opt.sessionoptions:append({ 'buffers' })

vim.g.loaded_python3_provider = nil
vim.g.python3_host_prog=vim.fn.expand("~/.cache/nvim/venv/bin/python3")
