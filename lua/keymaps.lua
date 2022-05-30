-- Keymap based on Visual Studio Code / Resharper
require('config.vstudio-keymaps')

-- These are not based on VSCode
vim.keymap.set('n', '<F6>', function()
    vim.lsp.buf.code_action()
end, { noremap = true })

vim.keymap.set('n', '<C-s>', function()
    vim.api.nvim_command('write')
end, { noremap = true })
