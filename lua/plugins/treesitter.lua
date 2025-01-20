return {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    opts = {
        ensure_installed = {
            'lua',
            'javascript',
            'typescript',
            'vimdoc',
            'vim',
            'regex',
            'sql',
            'dockerfile',
            'json',
            'yaml',
            'make',
            'cmake',
            'c',
            'cpp', -- C++ hinzugefügt
            'markdown',
            'markdown_inline',
            'bash',
            'css',
            'html',
        },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false, -- Verhindert Konflikte mit der alten Regex-basierten Hervorhebung
            disable = {},
        },

        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = 'gnn',
                node_incremental = 'grn',
                scope_incremental = 'grc',
                node_decremental = 'grm',
            },
        },
        indent = {
            enable = true,
        },
    },

    -- Debugging-Modus aktivieren, um genauere Fehlerberichte zu erhalten
    debug = true,

    -- Textobjekte für nvim-treesitter (optional)
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

    -- Refactor-Optionen für nvim-treesitter (optional)
    refactor = {
        highlight_definitions = { enable = true },
        highlight_current_scope = { enable = false },
    },


    -- Weitere nvim-treesitter-Module
    -- Incremental selection, Textobjects, Refactor etc.
}
