return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"mfussenegger/nvim-dap-python",
		"nvim-neotest/nvim-nio",
		"rcarriga/nvim-dap-ui",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("dapui").setup()
		require("dap-python").setup("python")
		-- require("dap-python").setup("~/.pyenv/versions/3.12.4/envs/rsstandard/bin/")

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		vim.keymap.set("n", "<F5>", dap.continue, { desc = "Continue Debugger" })
		vim.keymap.set("n", "<F6>", dap.close, { desc = "Stop Debugger" })
		vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step over" })
		vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step into" })
		vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step out" })
		vim.keymap.set("n", "<F8>", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
		vim.keymap.set("n", "<leader>dd", dap.continue, { desc = "Run debugger" })
	end,
}
