-- Subdirectories in lua directory
require 'core.options'
require 'core.keymaps'

-- LAZY loader ---------------------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
    -- Neotree -----------------------------------------------
    require 'plugins.neotree',

    -- colortheme --------------------------------------------
    require 'plugins.colortheme',

    -- bufferline --------------------------------------------
    require 'plugins.bufferline',

    -- lualine -----------------------------------------------
    require 'plugins.lualine',

    -- treesitter --------------------------------------------
    require 'plugins.treesitter',

    -- telescope ---------------------------------------------
    require 'plugins.telescope',

    -- lsp ---------------------------------------------------
    require 'plugins.lsp',

    -- autocompletion ----------------------------------------
    require 'plugins.autocompletion',

    -- autoformatting ----------------------------------------
    require 'plugins.autoformatting',

    -- gitsigns ----------------------------------------------
    require 'plugins.gitsigns',

    -- alpha -------------------------------------------------
    require 'plugins.alpha',

    -- alpha -------------------------------------------------
    require 'plugins.indent-blankline',

    -- misc --------------------------------------------------
    require 'plugins.misc',
    --
}
