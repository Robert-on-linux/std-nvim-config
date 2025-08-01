-- Subdirectories in lua directory
require("core.options")
require("core.keymaps")

-- LAZY loader ---------------------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

--vim.treesitter.query.add_predicate('has-ancestor', function(match, pattern, bufnr, predicate)
--    local node = match[predicate[2]]
--    if not node then
--        return false
--    end
--    local ancestor_type = predicate[3]
--    local parent = node:parent()
--    while parent do
--        if parent:type() == ancestor_type then
--            return true
--        end
--        parent = parent:parent()
--    end
--    return false
-- end, true)

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Neotree -----------------------------------------------
	require("plugins.neotree"),

	-- colortheme --------------------------------------------
	--    require 'plugins.colortheme',
	require("plugins.colortheme_onedark"),
	--    require 'plugins.colortheme_cobalt2',
	--    require 'plugins.colortheme_nord',

	-- bufferline --------------------------------------------
	require("plugins.bufferline"),

	-- lualine -----------------------------------------------
	require("plugins.lualine"),

	-- treesitter --------------------------------------------
	require("plugins.treesitter"),

	-- telescope ---------------------------------------------
	require("plugins.telescope"),

	-- lsp ---------------------------------------------------
	require("plugins.lsp"),

	-- dap ---------------------------------------------------
	require("plugins.dap"),

	-- toggleterm --------------------------------------------
	require("plugins.toggleterm"),

	-- autocompletion ----------------------------------------
	require("plugins.autocompletion"),

	-- autoformatting ----------------------------------------
	require("plugins.autoformatting"),

	-- gitsigns ----------------------------------------------
	require("plugins.gitsigns"),

	-- alpha -------------------------------------------------
	require("plugins.alpha"),

	-- alpha -------------------------------------------------
	require("plugins.indent-blankline"),

	-- misc --------------------------------------------------
	require("plugins.misc"),

	-- snippets ----------------------------------------------
	require("plugins.snippets"),

})

-- Lade Patch separat (kein Teil der Plugin-Specs)
require("patches")

-- ✅ Patch für zukünftige Neovim-Versionen (ersetzt alte sign_define)
vim.schedule(function()
	vim.diagnostic.config({
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.HINT] = "󰌵",
				[vim.diagnostic.severity.INFO] = "",
			},
			numhl = {
				[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
				[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
				[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
				[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
			},
		},
	})
end)
