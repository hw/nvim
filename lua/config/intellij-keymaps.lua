-- Keymap based on Visual Studio Code / Resharper
local dap = require('dap')

-- F9 = Resume Program (Continue)
vim.keymap.set('n', '<F9>', function()
    require('user').start_debugger()
end, { noremap = true })

-- Ctrl+F8 = Toggle Line Break
vim.keymap.set('n', '<C-F8>', function()
    dap.toggle_breakpoint()
end, { group = dap_augroup, noremap = true })

-- F8 = Step Over
vim.keymap.set('n', '<F8>', function()
    dap.step_over()
end, { noremap = true })

-- Alt+F9 ==> F14 = Run to Cursor
vim.keymap.set('n', '<F14>', function()
    dap.run_to_cursor()
end, { noremap = true })

-- F7 = Step Into
vim.keymap.set('n', '<F7>', function()
    dap.step_into()
end, { noremap = true })

-- Shift+F8 ==> F16 = Step Out
vim.keymap.set('n', '<F16>', function()
    dap.step_out()
end, { noremap = true })

