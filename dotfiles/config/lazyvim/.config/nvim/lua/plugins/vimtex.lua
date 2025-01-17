return {
	"lervag/vimtex",
	lazy = false, -- lazy-loading will disable inverse search
	config = function()
		vim.g.vimtex_view_method = "zathura"
		vim.g.tex_flavor = "latex"
		vim.g.vimtex_quickfix_mode = 0
		vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
		vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
		--	vim.g.vimtex_compiler_latexmk = {
		--		aux_dir = "./.latexmk/aux",
		--		out_dir = "./.latexmk/out",
		--	}
	end,
	keys = {
		{ "<localLeader>l", "", desc = "+vimtex", ft = "tex" },
	},
}
