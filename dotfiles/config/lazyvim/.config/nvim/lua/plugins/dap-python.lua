return {
	"mfussenegger/nvim-dap-python",
	config = function()
		require("dap-python").setup("python")
		-- require("dap-python").setup("~/.pyenv/versions/3.12.4/envs/rsstandard/bin/")
	end,
}
