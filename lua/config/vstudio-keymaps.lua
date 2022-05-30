-- Keymap based on Visual Studio Code / Resharper
local dap = require('dap')

-- F5 = Resume Program (Continue)
vim.keymap.set('n', '<F5>', function()
    require('user').start_debugger()
end, { noremap = true })

-- Shift + F5 ==> F13 = Stop
vim.keymap.set('n', '<F13>', function()
    dap.terminate()
end, { noremap = true })

-- F9 = Toggle Line Break
vim.keymap.set('n', '<F9>', function()
    dap.toggle_breakpoint()
end, { group = dap_augroup, noremap = true })

-- F10 = Step Over
vim.keymap.set('n', '<F10>', function()
    dap.step_over()
end, { noremap = true })

-- Ctrl + F10  = Run to Cursor
vim.keymap.set('n', '<C-F10>', function()
    dap.run_to_cursor()
end, { noremap = true })

-- F11 = Step Into
vim.keymap.set('n', '<F11>', function()
    dap.step_into()
end, { noremap = true })

-- Shift+F11 ==> F19 = Step Out
vim.keymap.set('n', '<F19>', function()
    dap.step_out()
end, { noremap = true })

