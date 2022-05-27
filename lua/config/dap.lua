-- see: https://github.com/Pocco81/dap-buddy.nvim/tree/dev-deps/lua/dap-install/core/debuggers

local dap = require('dap')

-- requires: apt install lldb
dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode-11',
    name = "lldb"
}

-- generic configuration
local dap_generic_config = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        runInTerminal = true,
    },
}

dap.configurations.c = dap_generic_config
dap.configurations.cpp = dap_generic_config
-- dap.configurations.rust = dap_generic_config
