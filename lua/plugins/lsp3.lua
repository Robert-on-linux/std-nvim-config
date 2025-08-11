return {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Automatically install LSPs and related tools
        { 'williamboman/mason.nvim', config = true }, -- Mason must load first
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        { 'j-hui/fidget.nvim', opts = {} }, -- For status updates
        'hrsh7th/cmp-nvim-lsp', -- Capabilities integration
    },
    config = function()
        -- Callback when an LSP attaches to a buffer
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                end

                -- LSP keymaps
                map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
                map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
                map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                -- Document highlighting (if supported)
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client:supports_method 'textDocument/documentHighlight' then
                    local hl_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        group = hl_group,
                        buffer = event.buf,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                        group = hl_group,
                        buffer = event.buf,
                        callback = vim.lsp.buf.clear_references,
                    })
                end

                -- Inlay hints toggle (if supported)
                if client and client:supports_method 'textDocument/inlayHint' then
                    map('<leader>th', function()
                        vim.lsp.inlay_hint(event.buf, nil)
                    end, '[T]oggle [H]ints')
                end
            end,
        })

        -- Setup capabilities with nvim-cmp
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

        -- Define LSP servers
        local servers = {
            ts_ls = {}, -- Example: TypeScript
            ruff = {}, -- Example: Python linting
            pylsp = {
                settings = {
                    pylsp = {
                        plugins = {
                            pyflakes = { enabled = false },
                            pycodestyle = { enabled = false },
                            autopep8 = { enabled = false },
                            yapf = { enabled = false },
                            mccabe = { enabled = false },
                            pylsp_mypy = { enabled = false },
                            pylsp_black = { enabled = false },
                            pylsp_isort = { enabled = false },
                        },
                    },
                },
            },
            html = { filetypes = { 'html', 'twig', 'hbs' } },
            cssls = {},
            tailwindcss = {},
            dockerls = {},
            sqlls = {},
            terraformls = {},
            jsonls = {},
            yamlls = {},
            lua_ls = {
                settings = {
                    Lua = {
                        runtime = { version = 'LuaJIT' },
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.fn.stdpath 'config' .. '/lua',
                                unpack(vim.api.nvim_get_runtime_file('', true)),
                            },
                        },
                        diagnostics = { globals = { 'vim' } },
                        format = { enable = false },
                    },
                },
            },
            clangd = {
                cmd = { 'clangd' },
                filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
                root_dir = require('lspconfig').util.root_pattern('compile_commands.json', 'compile_flags.txt', '.git'),
                settings = {
                    clangd = {
                        fallbackFlags = { '-std=c++23' }, -- Beispiel für Compiler-Flags
                    },
                },
            },
        }

        -- Ensure LSP servers are installed
        require('mason').setup()
        require('mason-tool-installer').setup {
            ensure_installed = {
                'clangd', -- LSP für C/C++
                'lua-language-server', -- Lua LSP
                'pyright', -- Python LSP
                'typescript-language-server', -- Typescript/Javascript
                'prettier', -- Formatter
                'eslint_d', -- Linter
                'shellcheck', -- Shell-Skript Linter
                'shfmt', -- Shell-Skript Formatter
            },

            -- Automatische Installation beim Start (optional)
            auto_update = false, -- Automatische Updates deaktivieren
            run_on_start = true, -- Installation prüfen und fehlende Tools laden
        }
        require('mason-lspconfig').setup {
            -- Liste der zu installierenden LSP-Server
            ensure_installed = {
                'clangd', -- C/C++
                'lua_ls', -- Lua
                'pyright', -- Python
                'ts_ls', -- TypeScript/JavaScript
                -- 'tsserver',
            },

            -- Automatische Installation aktivieren
            automatic_installation = true,

            -- Handler für zusätzliche Einstellungen

            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                    require('lspconfig')[server_name].setup(server)
                end,
            },
        }

        -- Konfiguration für clangd (C/C++ LSP)
        local lspconfig = require 'lspconfig'
        lspconfig.clangd.setup {
            cmd = { 'clangd' },
            filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
            root_dir = lspconfig.util.root_pattern('compile_commands.json', 'compile_flags.txt', '.git'),
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
        }

        -- Autovervollständigung mit nvim-cmp
        local cmp = require 'cmp'
        cmp.setup {
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm { select = true },
            },
            sources = cmp.config.sources {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            },
        }

        -- Automatische Formatierung mit clang-format
        vim.api.nvim_create_autocmd('BufWritePre', {
            pattern = { '*.c', '*.cpp', '*.h' },
            callback = function()
                vim.lsp.buf.format { async = true }
            end,
        })

        -- Dateisuche mit Telescope
        require('telescope').setup {}
        vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })

        -- Schlüsselbindungen für Debugging
        vim.keymap.set('n', '<F5>', function()
            require('dap').continue()
        end, { desc = 'Start Debugging' })
        vim.keymap.set('n', '<F10>', function()
            require('dap').step_over()
        end, { desc = 'Step Over' })
        vim.keymap.set('n', '<F11>', function()
            require('dap').step_into()
        end, { desc = 'Step Into' })
        vim.keymap.set('n', '<F12>', function()
            require('dap').step_out()
        end, { desc = 'Step Out' })
        vim.keymap.set('n', '<leader>b', vim.cmd.ToggleTerm, { desc = 'Open Build Terminal' })
    end,
}
