-- theme.lua.tmpl
return {
  {
    'nvim-mini/mini.nvim',
    priority = 1000,
    config = function()
      
      -- ========== Windows: fixed amethyst ==========
      local palette = require('windows_palette')
      require('mini.base16').setup {
        palette = palette,
        use_cterm = false,
      }
      

      -- Common mini modules (same on both)
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require('mini.statusline')
      statusline.setup { use_icons = vim.g.have_nerd_font or false }
      statusline.section_location = function() return '%2l:%-2v' end
    end,
  },
}
