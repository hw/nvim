vim.cmd([[ packadd packer.nvim ]])

require('packer').startup({ function(use)
    -- speed-up
    use { 'lewis6991/impatient.nvim',
        config = function()
            require('impatient').enable_profile()
        end
    }

    -- general purpose / functions
    use { 'nvim-lua/plenary.nvim' }

    -- additional vim functionality
    use { 'tpope/vim-repeat' }

    use { 'tpope/vim-surround' }

    use { 'wellle/targets.vim' }

    use { 'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup()
        end
    }

    -- theme/ui-customization
    use { 'dracula/vim',
        config = function()
            vim.cmd('colorscheme dracula')
        end
    }

    use { 'kyazdani42/nvim-web-devicons',
        -- https://www.nerdfonts.com/font-downloads
        config = function()
            require('nvim-web-devicons').setup({ default = true })
        end
    }

    use { 'rcarriga/nvim-notify',
        config = function()
            require('notify').setup {
                stages = 'slide',
                background_colour = 'FloatShadow',
                timeout = 3000,
            }
            vim.notify = require('notify')
        end
    }

    use { 'folke/which-key.nvim',
        event = 'VimEnter',
        config = function()
            require('which-key').setup {}
        end
    }

    use { 'romgrk/barbar.nvim',
        event = 'BufReadPre',
        config = function()
            local nvim_tree_events = require('nvim-tree.events')
            local bufferline_state = require('bufferline.state')

            nvim_tree_events.on_tree_open(function()
                bufferline_state.set_offset(31, "File Tree")
            end)

            nvim_tree_events.on_tree_close(function()
                bufferline_state.set_offset(0)
            end)
        end
    }

    use { 'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    theme = 'dracula'
                }
            }
        end
    }

    use { 'nvim-telescope/telescope-ui-select.nvim' }

    use { 'nvim-telescope/telescope.nvim',
        config = function()
            local telescope = require('telescope')
            telescope.setup {
                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown {}
                    }
                }
            }

            telescope.load_extension('ui-select')
            telescope.load_extension('notify')
        end
    }

    use { 'kyazdani42/nvim-tree.lua',
        config = function()
            require('nvim-tree').setup()
        end
    }

    -- useful for development
    use { 'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("indent_blankline").setup {
                show_end_of_line = true,
                space_char_blankline = " ",
            }
        end
    }

    use { 'tpope/vim-fugitive' }

    use { 'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    }

    -- debugging support
    use { 'mfussenegger/nvim-dap',
        requires = { 'rcarriga/nvim-dap-ui' },
        config = function()
            local dap, dapui = require('dap'), require('dapui')
            dapui.setup()
            dap.listeners.after.event_initialized['dapui_config'] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated['dapui_config'] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited['dapui_config'] = function()
                dapui.close()
            end
            -- ↦ ⤇ ⟾  ➡ ⊘ 車●
            vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = '', linehl = '', numhl = '' })
        end
    }

    -- Python
    use { 'mfussenegger/nvim-dap-python',
        ft = 'python',
        requires = { 'mfussenegger/nvim-dap' },
        config = function()
            require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
        end
    }

    -- Rust
    use { 'mfussenegger/nvim-jdtls',
        ft = 'java',
        requires = { 'mfussenegger/nvim-dap' },
        config = function()
            require('jdtls').setup_dap({ hotcodereplace = 'auto' })
            -- See `:help vim.lsp.start_client` for an overview of the supported `config` options:.
            local jdtls_install_location = vim.fn.stdpath('data') .. '/lsp_servers/jdtls'
            local jdtls_jar_location = vim.fn.glob(jdtls_install_location .. '/plugins/org.eclipse.equinox.launcher_*.jar')
            local java_debug_location = vim.fn.stdpath('config') .. '/tools/java-debug'
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
                root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }),

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

            config['on_attach'] = function(client, bufnr)
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
        end
    }

    -- Golang
    use { 'leoluz/nvim-dap-go',
        ft = 'go',
        requires = { 'mfussenegger/nvim-dap' },
        config = function()
            require('dap-go').setup()
        end
    }

    -- Rust
    use { 'simrat39/rust-tools.nvim',
        ft = 'rust',
        config = function()
            local rust_tools = require('rust-tools')
            -- local extension_path = vim.fn.stdpath('config') .. '/tools/vscode-lldb/extension/'
            -- local codelldb_path  = extension_path .. 'adapter/codelldb'
            -- local liblldb_path   = extension_path .. 'lldb/lib/liblldb.so'

            local opts = {
                dap = {
                    -- adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
                    adapter = {
                        type = 'executable',
                        command = '/usr/bin/lldb-vscode-11',
                        name = 'rt_lldb'
                    }
                }
            }
            rust_tools.setup(opts)
        end
    }

    -- code completion and syntax highlighting
    use { 'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = {
                    'python', 'rust', 'go', 'gomod', 'c_sharp', 'c', 'cpp',
                    'html', 'javascript', 'json',
                    'markdown', 'yaml',
                    'bash', 'dockerfile'
                }
            }
        end
    }

    use { 'nvim-treesitter/nvim-treesitter-textobjects',
        config = function()
            require 'nvim-treesitter.configs'.setup {
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                },
            }
        end
    }

    use { 'nvim-treesitter/nvim-treesitter-refactor',
        config = function()
            require 'nvim-treesitter.configs'.setup {
                refactor = {
                    smart_rename = {
                        enable = true,
                        keymaps = {
                            smart_rename = "grr",
                        },
                    },
                    navigation = {
                        enable = true,
                        keymaps = {
                            goto_definition = "gnd",
                            list_definitions = "gnD",
                            list_definitions_toc = "gO",
                            goto_next_usage = "<a-*>",
                            goto_previous_usage = "<a-#>",
                        },
                    },
                }
            }

        end
    }
    -- these two don't lend themselves well to config function due to their dependency on each other
    use { 'williamboman/nvim-lsp-installer' }
    use { 'neovim/nvim-lspconfig' }

    use { 'ray-x/lsp_signature.nvim',
        config = function()
            require('lsp_signature').setup()
        end
    }

    use { 'hrsh7th/nvim-cmp',
        requires = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'hrsh7th/cmp-cmdline' },
            { 'L3MON4D3/LuaSnip' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'rafamadriz/friendly-snippets' },
        },

        config = function()
            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
            end

            require('luasnip.loaders.from_vscode').lazy_load()
            local luasnip = require('luasnip')
            local cmp = require('cmp')
            cmp.setup({
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lua' },
                    { name = 'luasnip' },
                }),
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping(function(fallback)
                        if cmp.visible() and cmp.get_selected_entry() then
                            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        local cmp_visible = cmp.visible()

                        if cmp_visible and cmp.get_selected_entry() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            if luasnip.jumpable(1) then
                                vim.notify('Jumpable')
                                luasnip.jump(1)
                            elseif has_words_before() then
                                cmp.complete()
                            else
                                fallback()
                            end
                        end
                    end, { 'i', 's', }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's', }),
                }),
            })
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'cmdline' },
                    { name = 'path' },
                })
            })
        end
    }

    use { 'folke/trouble.nvim',
        config = function()
            require('trouble').setup()
            require('user').enable_icons()
        end
    }

    use { 'RishabhRD/nvim-lsputils',
        requires = { 'RishabhRD/popfix' },
        config = function()
            vim.lsp.handlers['textDocument/codeAction'] = require 'lsputil.codeAction'.code_action_handler
            vim.lsp.handlers['textDocument/references'] = require 'lsputil.locations'.references_handler
            vim.lsp.handlers['textDocument/definition'] = require 'lsputil.locations'.definition_handler
            vim.lsp.handlers['textDocument/declaration'] = require 'lsputil.locations'.declaration_handler
            vim.lsp.handlers['textDocument/typeDefinition'] = require 'lsputil.locations'.typeDefinition_handler
            vim.lsp.handlers['textDocument/implementation'] = require 'lsputil.locations'.implementation_handler
            vim.lsp.handlers['textDocument/documentSymbol'] = require 'lsputil.symbols'.document_handler
            vim.lsp.handlers['workspace/symbol'] = require 'lsputil.symbols'.workspace_handler
        end
    }

end,
config = {
    display = {
        open_fn = function()
            return require('packer.util').float({ border = 'single' })
        end
    }
} })
