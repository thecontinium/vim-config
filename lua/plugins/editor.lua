return {
	-----------------------------------------------------------------------------
	{
		'folke/flash.nvim',
    keys = {
      -- Simulate nvim-treesitter incremental selection
      { "<c-space>", mode = { "n", "o", "x" },
        function()
          require("flash").treesitter({
            actions = {
              ["<c-space>"] = "next",
              ["V"] = "prev"
            }
          })
        end, desc = "Treesitter Incremental Selection" },
    },
	},
}
