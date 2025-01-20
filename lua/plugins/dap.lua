-- Konfiguration von nvim-dap für Debugging

-- Plugins für Debugging
return {
    { 'mfussenegger/nvim-dap' },
    { 'rcarriga/nvim-dap-ui' }, -- Benutzeroberfläche für nvim-dap

    -- Debugger-Konfiguration für C/C++
    config = function()
        local dap = require 'dap'

        -- Adapter für C/C++ (cpptools)
        dap.adapters.cppdbg = {
            id = 'cppdbg',
            type = 'executable',
            command = require('mason-registry').get_package('cpptools'):get_install_path() .. '/extension/debugAdapters/bin/OpenDebugAD7',
        }

        -- Debugging-Konfiguration für C++
        dap.configurations.cpp = {
            {
                name = 'Launch file',
                type = 'cppdbg',
                request = 'launch',
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
                setupCommands = {
                    {
                        text = '-enable-pretty-printing',
                        description = 'Enable pretty printing',
                        ignoreFailures = false,
                    },
                },
            },
        }

        -- Optional: Integration mit nvim-dap-ui
        require('dapui').setup()
        vim.keymap.set('n', '<leader>du', require('dapui').toggle, { desc = '[D]ebug [U]I toggle' })
    end,
}
