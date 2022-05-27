-- utility functions
local signs = {
    texts = {
        Error = 'E',
        Warn = 'W',
        Hint = 'H',
        Info = 'I'
    },
    icons = {
        Error = '',
        Warn  = '',
        Hint  = '', -- 💡★
        Info  = '',
    }
}

local function update_diagnostics_signs(signset)
    for type, icon in pairs(signset) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
    end
end

local M = {
    enable_icons = function()
        update_diagnostics_signs(signs.icons)
        require('lualine').setup({ options={ icons_enabled = true } })
    end,

    disable_icons = function()
        update_diagnostics_signs(signs.texts)
        require('lualine').setup({ options={ icons_enabled = false } })
    end
}

return M;
