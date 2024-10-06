local hop = require('hop')
local directions = require('hop.hint').HintDirection
local builtin = require('telescope.builtin')

require('legendary').setup({
  extensions = { lazy_nvim = true },
  keymaps = {
    -- HOP mappings
        { 'f',
          function()
            hop.hint_char1({ direction = directions.AFTER_CURSOR })
          end,
          description = 'forward move to char'
        },
        { 'F',
          function()
            hop.hint_char1({ direction = directions.BEFORE_CURSOR })
          end,
          description = 'backward move to char'
        },
        { 't',
          function()
            hop.hint_char1({ direction = directions.AFTER_CURSOR })
          end,
          description = 'forward move before char'
        },
        { 'T',
          function()
            hop.hint_char1({ direction = directions.AFTER_CURSOR })
          end,
          description = 'backward move before char'
        },

        -- Rust tools mappings
        {
          '<leader>ha',
          { n = '<Cmd>RustHoverActions<CR>' },
          description = 'Hover action (rust-tools)',
        },

        -- barbar mappings
        {
          '<A-,>',
          { n = '<Cmd>BufferPrevious<CR>' },
          description = 'previous buffer',
        },
        {
          '<A-.>',
          { n = '<Cmd>BufferNext<CR>' },
          description = 'next buffer',
        },
        {
          '<A-c>',
          { n = '<Cmd>BufferClose<CR>' },
          description = 'close buffer',
        },
        {
          '<leader>b',
          { n = '<Cmd>BufferPick<CR>' },
          description = 'pick buffer barbar',
        },

        -- Legendary
        {
          '<leader>ll',
          '<Cmd>Legendary<CR>',
          description = 'open Legendary searcher',
        },

        -- Telescope mappings
        {
          '<leader>fr',
          builtin.resume,
          description = 'telescope open last picker',
        },
        {
          '<leader>ff',
          builtin.find_files,
          description = 'telescope find files',
        },
        {
          '<leader>fb',
          builtin.buffers,
          description = 'telescope buffers',
        },
        {
          '<leader>fg',
          builtin.live_grep,
          description = 'telescope live grep',
        },
        {
          '<leader>fh',
          builtin.help_tags,
          description = 'telescope help tags',
        },
        {
          '<leader>fc',
          builtin.commands,
          description = 'telescope commands',
        },
        {
          '<leader>fd',
          builtin.diagnostics,
          description = 'telescope diagnostics',
        },
        {
          '<leader>fs',
          builtin.spell_suggest,
          description = 'telescope spell suggest',
        },

        -- undotree mappings
        {
          '<leader>tu',
          { n = '<Cmd>UndotreeToggle<CR>' },
          description = 'toggle undotree',
        },

        -- LSP mappings
        {
          'gd',
          { n = vim.lsp.buf.definitions },
          description = 'go to definitions'
        },
        {
          'K',
          { n = vim.lsp.hover },
          description = 'show hover info'
        },
        {
          '<leader>vws',
          { n = vim.lsp.buf.workspace_symbol },
          description = 'show workspace symbols'
        },

        {
          '<leader>vd',
          { n = vim.diagnostic.open_float },
          description = 'open float diagnostic'
        },

        {
          '<leader>ca',
          { n = "<Cmd>CodeActionMenu<CR>" },
          description = 'code action menu'
        },
        {
          '<leader>rr',
          { n = vim.lsp.buf.references },
          description = 'show references'
        },
        {
          '<leader>rn',
          { n = vim.lsp.buf.rename },
          description = 'rename symbol under cursor'
        },
        -- TODO: Add harpoon mappings  
        -- TODO: Add more lsp mappings
        -- TODO: Add terminal mapping
        -- TODO: Add windows-movements mappings
    },
})
