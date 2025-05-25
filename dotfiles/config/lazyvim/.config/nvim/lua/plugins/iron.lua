-- lua/plugins/iron.lua
return {
  "Vigemus/iron.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local iron = require("iron.core")
    local view = require("iron.view")
    -- local common = require("iron.fts.common") -- For bracketed paste, if needed

    -- Helper function to determine the correct Python REPL command
    local function get_python_repl_command()
      local venv_path = os.getenv("VIRTUAL_ENV") -- Standard environment variable for venvs

      if venv_path and #venv_path > 0 then
        local python_executable
        local ipython_executable

        if vim.fn.has("win32") == 1 then -- Checks if Neovim is running on Windows
          python_executable = venv_path .. "\\Scripts\\python.exe"
          ipython_executable = venv_path .. "\\Scripts\\ipython.exe"
        else -- Linux, macOS, etc.
          python_executable = venv_path .. "/bin/python"
          ipython_executable = venv_path .. "/bin/ipython"
        end

        -- Prioritize IPython if it exists in the venv
        if vim.fn.executable(ipython_executable) == 1 then
          return { ipython_executable, "--no-autoindent", "-i" } -- "-i" for IPython is often implicit
        elseif vim.fn.executable(python_executable) == 1 then
          return { python_executable, "-i" } -- "-i" for interactive mode
        end
        -- If specific venv executables aren't found, iron.nvim will try the fallback.
        -- A notification here could be noisy if the user has $VIRTUAL_ENV set but Neovim launched outside of it.
      end

      -- Fallback if no venv is active or the interpreter in the venv was not found
      -- Try global IPython first, then python3, then python
      if vim.fn.executable("ipython") == 1 then
        return { "ipython", "--no-autoindent", "-i" }
      elseif vim.fn.executable("python3") == 1 then
        return { "python3", "-i" }
      elseif vim.fn.executable("python") == 1 then
        return { "python", "-i" }
      else
        vim.notify("No Python interpreter (ipython, python3, python) found in PATH.", vim.log.levels.ERROR)
        return { "python", "-i" } -- Last resort attempt
      end
    end

    iron.setup({
      config = {
        scratch_repl = true, -- Discard REPL buffer when no longer needed
        repl_definition = {
          python = {
            -- Call the function to get the command dynamically
            command = get_python_repl_command(),
            -- For Bracketed Paste Mode (optional, requires 'common'):
            -- format = common.bracketed_paste_python,
            -- block_dividers = { "# %%", "#%%" }, -- For VS Code-like notebook cells
          },
          -- Example for shell (you can enable it if needed)
          -- sh = {
          --   command = {"zsh"} -- or bash, etc.
          -- },
        },
        -- repl_filetype = function(bufnr, ft) return ft end, -- Default is usually fine
        repl_open_cmd = view.bottom(15), -- Open REPL at the bottom, 15 lines high
        -- Alternatives for repl_open_cmd:
        -- repl_open_cmd = view.split.vertical.rightbelow(0.3), -- Vertical split right, 30% width
        ignore_blank_lines = true, -- Ignore blank lines when sending
      },
      -- Keymaps as recommended in the GitHub example
      keymaps = {
        toggle_repl = "<leader>ro",       -- Toggles (opens/closes) the REPL window
        restart_repl = "<leader>rR",      -- Restarts the REPL
        send_line = "<leader>rl",         -- Sends the current line
        visual_send = "<leader>rs",       -- Sends the visual selection
        send_motion = "<leader>rm",       -- Operator: <leader>rm <motion> (e.g., ip)
        -- send_file = "<leader>rAf",    -- Sends the whole file (choose a different key than <leader>rf for focus)
        -- send_paragraph = "<leader>rp",
        -- send_until_cursor = "<leader>ru",
        interrupt = "<leader>ri",         -- Interrupts execution (e.g., Ctrl-C for Python)
        exit = "<leader>rq",              -- Exits the REPL process (effectively closes it)
        clear = "<leader>rcL",           -- Clears the REPL screen (if REPL supports it)
        -- cr = "<leader>r<cr>",         -- Sends Enter only
      },
      highlight = { -- Highlight for sent code
        italic = true,
      },
    })

    -- Manual keymaps for Iron commands (as in the GitHub example)
    vim.keymap.set('n', '<leader>rf', '<cmd>IronFocus<cr>', { desc = "Iron: Focus REPL" })
    vim.keymap.set('n', '<leader>rh', '<cmd>IronHide<cr>', { desc = "Iron: Hide/Show REPL" })
    -- Check :help iron-commands for a complete list of commands.

    -- Your Treesitter block mapping.
    vim.keymap.set("n", "<leader>rb", function()
        if pcall(require, "nvim-treesitter.ts_utils") then
            local ts_utils = require("nvim-treesitter.ts_utils")
            local current_bufnr = vim.api.nvim_get_current_buf()
            local node = ts_utils.get_node_at_cursor()

            if node then
                local query_str = [[
                    (function_definition) @block
                    (class_definition) @block
                    (decorated_definition) @block
                    (block) @block
                ]]
                local query = vim.treesitter.query.parse("python", query_str)
                for id, Nnode, metadata in query:iter_captures(node, current_bufnr, node:range()) do
                    if Nnode and metadata.capture_name == "block" then
                        local start_row, start_col, end_row, end_col = Nnode:range()
                        vim.api.nvim_buf_set_mark(current_bufnr, '<', start_row + 1, start_col, {})
                        vim.api.nvim_buf_set_mark(current_bufnr, '>', end_row + 1, end_col, {})
                        vim.cmd("normal! gv")
                        -- Call the core function directly.
                        -- Assuming 'send_selection' is the stable API function name.
                        local core_iron = require("iron.core")
                        if core_iron.send_selection then
                            core_iron.send_selection()
                        else
                            vim.notify("Iron: 'send_selection' function not found in iron.core for Treesitter map.", vim.log.levels.WARN)
                        end
                        return
                    end
                end
                print("No known Python block found under cursor.") -- User feedback
            else
                print("No Treesitter node under cursor.") -- User feedback
            end
        else
            print("nvim-treesitter is not available or ts_utils not found.") -- User feedback
        end
    end, { desc = "Iron: Send Block (Treesitter)" })
  end,
}