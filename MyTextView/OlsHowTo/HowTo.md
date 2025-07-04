# How to Set Up OLS and odinfmt with LazyVim (Neovim)

This guide explains how to build and configure the Odin Language Server (OLS) and the odinfmt formatter for use in [LazyVim](https://www.lazyvim.org/) (a Neovim distribution).

---

## 1. Build the Binaries

### A. Build OLS (Odin Language Server)

1. Open a terminal and navigate to your OLS project folder:
   ```sh
   cd /home/cris/Code/Github/ols
   ```
2. Run the build script:
   ```sh
   ./build.sh
   ```
   - This will produce an `ols` binary in the project root (i.e., `/home/cris/Code/Github/ols/ols`).

### B. Build odinfmt (Odin Formatter)

1. Navigate to the odinfmt directory:
   ```sh
   cd /home/cris/Code/Github/ols/tools/odinfmt
   ```
2. Build the formatter using Odin:
   ```sh
   odin build . -out:odinfmt
   ```
   - This will produce an `odinfmt` binary in `/home/cris/Code/Github/ols/tools/odinfmt/odinfmt`.

---

## 2. (Optional) Add Binaries to Your PATH

If both `ols` and `odinfmt` binaries are in `/home/cris/Code/Github/ols`, you only need to add that directory to your PATH. Add the following to your `~/.bashrc` or `~/.zshrc`:

```sh
export PATH="$PATH:/home/cris/Code/Github/ols"
```

Then reload your shell:
```sh
source ~/.bashrc  # or source ~/.zshrc
```

---

## 3. Configure LazyVim for OLS and odinfmt

### A. OLS: LSP Server Setup

1. Open (or create) the file:
   ```
   ~/.config/nvim/lua/plugins/lsp.lua
   ```
   or use the LazyVim custom plugin directory (e.g., `~/.config/nvim/lua/plugins/ols.lua`).

2. Add the following configuration:

   ```lua
   -- ~/.config/nvim/lua/plugins/ols.lua
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
   ```
   - Adjust the path in `cmd` if you move the binary.

### B. odinfmt: Formatter Setup

LazyVim uses [conform.nvim](https://github.com/stevearc/conform.nvim) for formatting by default.

1. Open (or create) the file:
   ```
   ~/.config/nvim/lua/plugins/conform.lua
   ```
   or use the LazyVim custom plugin directory (e.g., `~/.config/nvim/lua/plugins/odinfmt.lua`).

2. Add the following configuration:

   ```lua
   -- ~/.config/nvim/lua/plugins/odinfmt.lua
   return {
     {
       "stevearc/conform.nvim",
       opts = {
         formatters_by_ft = {
           odin = { "/home/cris/Code/Github/ols/odinfmt" },
         },
       },
     },
   }
   ```
   - Adjust the path if you move the binary.

---

## 4. Restart Neovim

After making these changes, restart Neovim. Open an Odin file to verify:
- LSP features (diagnostics, completion, etc.) are working.
- Formatting (using `:Format` or on save) uses `odinfmt`.

---

## 5. Troubleshooting

- Ensure the binaries are executable:
  ```sh
  chmod +x /home/cris/Code/Github/ols/ols
  chmod +x /home/cris/Code/Github/ols/odinfmt
  ```
- If you get command not found errors, check your PATH or use absolute paths in the config.
- For more info, see the [LazyVim documentation](https://www.lazyvim.org/) and [conform.nvim docs](https://github.com/stevearc/conform.nvim).

---

## 6. Summary Checklist

- [ ] Build OLS and odinfmt binaries
- [ ] Configure LSP for OLS in LazyVim
- [ ] Configure odinfmt as formatter in LazyVim
- [ ] Restart Neovim and test

---

Happy Odin coding with LazyVim! 