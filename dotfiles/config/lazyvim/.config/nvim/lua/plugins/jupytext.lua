return {
  "GCBallesteros/jupytext.nvim",
  lazy = false,
  config = function()
    -- Versuche, die Optionen direkt an die setup-Funktion zu übergeben
    require("jupytext").setup({
      style = "hydrogen",                 -- Überprüfe, ob diese Option hier gültig ist
      output_extension = "auto",
      force_ft = nil,
      custom_language_formatting = {      -- Überprüfe, ob diese Option hier gültig ist
        python = {
          extension = "qmd",
          style = "quarto",               -- Und diese untergeordnete Option
          force_ft = "quarto",
        },
      },
    })
  end,
}