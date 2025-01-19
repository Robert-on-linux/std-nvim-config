return {
    -- OneDark Theme
    {
        'navarasu/onedark.nvim',
        config = function()
            require('onedark').setup {
                style = 'deep', -- Wähle deinen Stil (z. B. 'dark', 'darker', 'cool', etc.)
                transparent = false, -- Transparenter Hintergrund
                term_colors = true, -- Farben im Terminal aktivieren
            }
            require('onedark').load()
        end,
    },
}
