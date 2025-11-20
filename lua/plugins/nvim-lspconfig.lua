return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" }, -- tell LSP that `vim` is a valid global
              },
            },
          },
        },
      },
    },
  },
}
