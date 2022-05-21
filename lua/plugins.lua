vim.cmd([[ packadd packer.nvim ]])

require('packer').startup({ function(use)
    -- general purpose / functions
    use { 'nvim-lua/plenary.nvim' }

    -- theme/ui-customization
    use { 'dracula/vim',
        config = function()
            vim.cmd('colorscheme dracula')
        end
    }

    use { 'kyazdani42/nvim-web-devicons',
        -- https://www.nerdfonts.com/font-downloads
        config = function()
            require('nvim-web-devicons').setup()
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
        config = function()
            require('which-key').setup {}
        end
    }

    use { 'noib3/nvim-cokeline',
        config = function()
            require('cokeline').setup()
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

    use {'nvim-telescope/telescope-ui-select.nvim' }

    use { 'nvim-telescope/telescope.nvim',
        config = function ()
            local telescope = require('telescope')
            telescope.setup{
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown { }
                    }
                }
            }
            telescope.load_extension("ui-select")
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
        requires = {
            'rcarriga/nvim-dap-ui',
            'mfussenegger/nvim-dap-python'
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
            require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
            vim.fn.sign_define('DapBreakpoint', { text = '🚫', texthl = '', linehl = '', numhl = '' })
        end
    }

    -- code completion and syntax highlighting
    use { 'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = {
                    "python", "rust", "go", "gomod", "c", "cpp",
                    "html", "javascript", "json",
                    "markdown", "yaml",
                    "bash"
                }
            }
        end
    }

    -- these two don't lend themselves well to config function due to their dependency on each other
    use { 'williamboman/nvim-lsp-installer' }
    use { 'neovim/nvim-lspconfig' }

    use { 'simrat39/rust-tools.nvim',
        config = function()
            local opts = {
                dap = {
                    adapter = {
                        type = "executable",
                        command = "/usr/bin/lldb-vscode-11",
                        name = "rt_lldb"
                    }
                }
            }
            require('rust-tools').setup(opts)
        end
    }

    use { 'ray-x/lsp_signature.nvim',
        config = function()
            require('lsp_signature').setup()
        end
    }

    use { 'hrsh7th/nvim-cmp',
        requires = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'hrsh7th/cmp-vsnip' },
            { 'hrsh7th/vim-vsnip' },
            { 'L3MON4D3/LuaSnip' },
            { 'saadparwaiz1/cmp_luasnip' },
        },
        config = function()
            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
            end
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
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace, -- could be Insert or Replace
                        select = true
                    },
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.jumpable() then
                            luasnip.jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s", }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s", }),
                }),
            })
        end
    }

    use { 'folke/trouble.nvim',
        config = function()
            require('trouble').setup()
            local signs = {
                Error = '',
                Warn  = '',
                Hint  = '💡',
                Info  = '',
            }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end
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
