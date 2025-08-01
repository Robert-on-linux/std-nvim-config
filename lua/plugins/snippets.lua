return {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    build = 'make install_jsregexp',
    dependencies = {
        'rafamadriz/friendly-snippets',
    },
    config = function()
        local ls = require 'luasnip'
        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node
        local f = ls.function_node
        local d = ls.dynamic_node
        local sn = ls.snippet_node
        local c = ls.choice_node

        -- Eigene Snippets (global)
        ls.add_snippets('all', {
            s('!gruss', {
                t 'Hallo Robert! Dies ist ein Beispiel-Textbaustein.',
            }),
            s('!sign', {
                t { 'Mit freundlichen Grüßen,', '' },
                i(1, 'Robert'),
            }),
            s('!todo', {
                t 'TODO: ',
                i(1, 'Noch erledigen...'),
            }),
            s('!header', {
                t { '// -----------------------------------', '// Program name: ' },
                f(function()
                    return vim.fn.expand '%:t' -- aktueller Dateiname
                end),
                t { '', '// Version: 1.0', '// Date: ' },
                f(function()
                    local filename = vim.fn.expand '%:p'
                    local ok, stat = pcall(vim.loop.fs_stat, filename)
                    if ok and stat then
                        -- Unix-Zeitstempel → Datum
                        return os.date('%Y-%m-%d', stat.ctime.sec)
                    else
                        return os.date '%Y-%m-%d'
                    end
                end),
                t { '', '// Author: Robert Rupp', '// Language: ' },
                f(function()
                    return vim.bo.filetype
                end),
                t { '', '// -----------------------------------', '' },
            }),
            s('!cpp', {
                t {
                    '#include <iostream>',
                    '',
                    'int main(int argc, char **argv)',
                    '{',
                    '',
                    '    return 0;',
                    '}',
                },
            }),
        })

        -- VSCode-kompatible Snippets laden
        require('luasnip.loaders.from_vscode').lazy_load()

        -- Lua-Snippets laden (falls du weitere definierst)
        require('luasnip.loaders.from_lua').lazy_load { paths = '~/.config/nvim/snippets' }

        -- Keymaps (Tab zum Expandieren oder Springen)
        vim.keymap.set({ 'i', 's' }, '<Tab>', function()
            if ls.expand_or_jumpable() then
                return '<cmd>lua require("luasnip").expand_or_jump()<CR>'
            else
                return '<Tab>'
            end
        end, { expr = true, silent = true })

        vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
            if ls.jumpable(-1) then
                return '<cmd>lua require("luasnip").jump(-1)<CR>'
            else
                return '<S-Tab>'
            end
        end, { expr = true, silent = true })
    end,
}
