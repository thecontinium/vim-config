local npairs = require("nvim-autopairs")
local cond = require("nvim-autopairs.conds")
local basic = require("nvim-autopairs.rules.basic")

npairs.setup()

-- this in effect uses the default behaviour and adds +,-,/,* to no after
local bracket = basic.bracket_creator(require("nvim-autopairs").config)
npairs.add_rules({
bracket("(", ")", { "clojure", "lisp" })
	:with_pair(cond.not_after_regex([=[[%w%%%'%[%"%.%`%$%+%-%/%*]]=])),
})

-- turn off the orighinal rule for clojure and lisp
npairs.get_rule("(")[1].not_filetypes = { "clojure", "lisp" }

