return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ols = {
          default_config = {
            cmd = { "/home/cris/Code/Github/ols/ols" },
            filetypes = { "odin" },
            root_dir = require("lspconfig.util").root_pattern("ols.json", ".git"),
          },
        },
      },
    },
  },
}
