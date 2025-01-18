return { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
        ensure_installed = {
            --            'all',
            'lua',
            --            'python',
            'javascript',
            'typescript',
            'vimdoc',
            'vim',
            'regex',
            --            'terraform',
            'sql',
            'dockerfile',
            --            'toml',
            'json',
            --            'java',
            --            'groovy',
            --            'go',
            'gitignore',
            --            'graphql',
            'yaml',
            'make',
            'cmake',
            'c',
            'cpp',
            'markdown',
            'markdown_inline',
            'bash',
            --            'tsx',
            'css',
            'html',
        },
        ignore_install = {},
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = {
            enable = true,
            -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
            --  If you are experiencing weird indenting issues, add the language to
            --  the list of additional_vim_regex_highlighting and disabled languages for indent.
            --      additional_vim_regex_highlighting = { 'ruby' },
            additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = 'gnn',
                node_incremental = 'grn',
                scope_incremental = 'grc',
                node_decremental = 'grm',
            },
            indent = {
                enable = true,
                --            disable = { 'ruby' },
            },
        },
    },

    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatische Vorauswahl
            keymaps = {
                ['af'] = '@function.outer', -- Ganze Funktion
                ['if'] = '@function.inner', -- Innerer Teil der Funktion
                ['ac'] = '@class.outer', -- Ganze Klasse
                ['ic'] = '@class.inner', -- Innerer Teil der Klasse
            },
        },
    },
    refactor = {
        highlight_definitions = { enable = true },
        highlight_current_scope = { enable = false },
    },
}
