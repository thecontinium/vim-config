local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')
local cond = require('nvim-autopairs.conds')

npairs.setup()
npairs.get_rule("'")[1].not_filetypes = {"clojure", "scheme", "lisp" }

-- this in effect uses the default behaviour and adds +,-,/,* to no after
npairs.add_rules({
  Rule("(", ")",{"clojure", "lisp"})
    :with_pair(cond.not_add_quote_inside_quote())
    :with_pair(cond.is_bracket_line())
    :with_pair(cond.is_bracket_in_quote(), 1)
    :with_pair(cond.not_after_regex([=[[%w%%%'%[%"%.%`%$%+%-%/%*]]=]))
    :use_undo(true)
    :with_move(cond.move_right())
    :with_move(cond.is_bracket_line_move())
  })

npairs.get_rule("(")[1].not_filetypes = {"clojure", "scheme", "lisp" }


