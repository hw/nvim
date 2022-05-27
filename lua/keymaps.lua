-- vim.api.nvim_create_autocmd('CursorHold', { command = [[ lua vim.diagnostic.open_float(nil, { focusable = false }) ]] })

local dap = require('dap')

vim.keymap.set('n', '<F9>', function()
    dap.toggle_breakpoint()
end, { group = dap_augroup, noremap = true })

vim.keymap.set('n', '<F10>', function()
    dap.step_over()
end, { noremap = true })

-- Shift + F10 ==> F18
vim.keymap.set('n', '<F18>', function()
    dap.run_to_cursor()
end, { noremap = true })

vim.keymap.set('n', '<F11>', function()
    dap.step_into()
end, { noremap = true })

-- Shift+F11 ==> F19
vim.keymap.set('n', '<F19>', function()
    dap.step_out()
end, { noremap = true })

vim.keymap.set('n', '<F5>', function()
    if dap.session() then
        dap.continue()
    else
        local buf_filetype = vim.api.nvim_buf_get_option(0, 'filetype')
        if buf_filetype == "rust" then
            vim.cmd[[ RustDebuggables ]]
        elseif buf_filetype == "java" then
            require('jdtls.dap').setup_dap_main_class_configs()
            dap.continue()
        else
            dap.continue()
        end
    end
end, { noremap = true })

-- Shift + F5 ==> F13
vim.keymap.set('n', '<F13>', function()
    dap.terminate()
end, { noremap = true })
