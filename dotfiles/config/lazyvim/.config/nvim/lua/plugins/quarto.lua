return {
	'quarto-dev/quarto-nvim',
	dev = false,
	opts = {
	  lspFeatures = {
		enabled = true,
		chunks = 'curly',
	  },
	  codeRunner = {
		enabled = true,
		default_method = 'slime',
	  },
	},
	dependencies = {
	  -- for language features in code cells
	  -- configured in lua/plugins/lsp.lua
	  'jmbuhr/otter.nvim',
	},
 }
