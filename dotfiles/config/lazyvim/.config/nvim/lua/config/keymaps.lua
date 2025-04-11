-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap -- for conciseness
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("n", "ö", "[", { desc = "Changed umlauts to brackets" })
keymap.set("n", "ä", "]", { desc = "Changed umlauts to brackets" })

local wk = require("which-key")
wk.add({
	{ "<leader>h", group = "harpoon", icon = "" },
})
