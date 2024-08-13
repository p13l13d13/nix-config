-- Install lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- TODO: Cleanup here:
require("lazy").setup({
  lockfile = "~/.lazy-lockzz.json",
  checker = {
    enabled = true, -- Enable automatic plugin update checks
    frequency = 604800, -- Check for updates every week (in seconds)
  },
  -- Packer can manage itself
  spec = {
    'wbthomason/packer.nvim',
     'rbgrouleff/bclose.vim',
    'kevinhwang91/rnvimr',
    -- Some improvements to neovim UI
     {'stevearc/dressing.nvim'},
     'simrat39/rust-tools.nvim',
     {'romgrk/barbar.nvim'},
     'nvim-tree/nvim-web-devicons',
    {
      'mrjones2014/legendary.nvim',
      -- sqlite is only needed if you want to  frecency sorting
      requires = 'kkharji/sqlite.lua'
    },

    -- Debugging
     'nvim-lua/plenary.nvim',
     'mfussenegger/nvim-dap',
    {
      'weilbith/nvim-code-action-menu',
      cmd = 'CodeActionMenu',
    },

     {
      'nvim-telescope/telescope.nvim',
      requires = { {'nvim-lua/plenary.nvim'} }
    },

     {
      'lewis6991/gitsigns.nvim',
      config = function()
        require('gitsigns').setup()
      end
    },

    {
      'ellisonleao/gruvbox.nvim',
      name = 'gruvbox',
    },

     { "ray-x/lsp_signature.nvim" },
     {
      'numToStr/Comment.nvim',
      config = function()
          require('Comment').setup()
      end
    },

    {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},
    'theprimeagen/harpoon',
    'mbbill/undotree',
    'tpope/vim-fugitive',

     {
      'phaazon/hop.nvim',
      branch = 'v2', -- optional but strongly recommended
      config = function()
        require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
      end,
      name = 'hop'
    },

     {
      'VonHeikemen/lsp-zero.nvim',
      branch = 'v4.x',
      dependencies = {
        -- LSP Support
        {'neovim/nvim-lspconfig'},

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-path'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/cmp-nvim-lua'},
      }
    },
  },
})
