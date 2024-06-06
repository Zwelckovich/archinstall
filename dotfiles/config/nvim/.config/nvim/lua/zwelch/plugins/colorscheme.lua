return {
  "catppuccin/nvim", 
  name = "catppuccin", 
  priority = 1000, 
  config = function()
    vim.cmd("colorscheme catppuccin-mocha")
    require("catppuccin").setup({
      integrations = {
        telescope = {
          enabled = true,
          -- style = "nvchad"
        },
        nvimtree = true,
        lsp_trouble = true,
        alpha = true,
        which_key = true,
        indent_blankline = {
          enabled = true,
          scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
          colored_indent_levels = true,
        },
        mason = true,
        cmp = true,
      }
    })
  end
}
