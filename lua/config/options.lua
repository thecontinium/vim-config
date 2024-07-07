local opt = vim.opt

-- What to save for views and sessions
opt.sessionoptions:remove({ 'help' })
opt.sessionoptions:remove({ 'folds' })
opt.sessionoptions:append({ 'buffers' })
