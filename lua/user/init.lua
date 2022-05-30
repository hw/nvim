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

local function start_debugger()
    local dap = require('dap')
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
end

local M = {
    enable_icons = function()
        update_diagnostics_signs(signs.icons)
        require('lualine').setup({ options={ icons_enabled = true } })
    end,

    disable_icons = function()
        update_diagnostics_signs(signs.texts)
        require('lualine').setup({ options={ icons_enabled = false } })
    end,

    start_debugger = start_debugger
}

return M;
