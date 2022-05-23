-- See `:help vim.lsp.start_client` for an overview of the supported `config` options:.
local jdtls_install_location = vim.fn.stdpath('data') .. '/lsp_servers/jdtls'
local jdtls_jar_location = vim.fn.glob(jdtls_install_location .. '/plugins/org.eclipse.equinox.launcher_*.jar')
local java_debug_location = vim.fn.stdpath('config') .. '/java-debug'
local java_debug_jar_expr = java_debug_location .. '/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar'

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), 'p:h:t')
local workspace_dir = vim.fn.expand('~/workspace/') .. project_name

local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    -- 💀
    'java', -- or '/path/to/java11_or_newer/bin/java'
            -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', jdtls_jar_location,
    '-configuration', jdtls_install_location .. '/config_linux',
    '-data', workspace_dir
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'}),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
    }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://githujcom/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {
    }
  },
}

local java_debug_jar_path = vim.fn.glob(java_debug_jar_expr)
local bundles = { java_debug_jar_path }

config['init_options'] = {
    bundles = bundles;
}

config['on_attach'] = function (client, bufnr)
    require('jdtls').setup_dap({ hotcodereplace = 'auto' })
end

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)

vim.cmd [[
    command! -buffer -nargs=? -complete=custom,v:lua.require('jdtls')._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
    command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
    command! -buffer JdtDapConfig lua require('jdtls.dap').setup_dap_main_class_configs() 
]]

