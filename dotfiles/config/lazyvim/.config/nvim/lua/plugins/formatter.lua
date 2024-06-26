return {
  "stevearc/conform.nvim",

  opts = function()
    local opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
        python = { "ruff_format" },
      },
    }
    return opts
  end,
}
