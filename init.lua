local packager = require('lua/packager')
local misc = require('lua/misc')

local installed = {}

--- Options
-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Enable line numbers
vim.opt.number = true
-- Enable relative line numbers
vim.opt.relativenumber = true
-- Enable mouse support
vim.opt.mouse = 'nvi'
-- Sync with the OS clipboard
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
-- Make undo files
vim.opt.undofile = true
-- Make searches case-insensitive in general
vim.opt.ignorecase = true
-- If there is a mixed case in your search, make it case-sensitive
vim.opt.smartcase = true
-- Only show sign column if needed
vim.opt.signcolumn = 'yes'
-- Write swapfile to disk if no activity for 250ms
vim.opt.updatetime = 250
-- How long for other sequences to timeout
vim.opt.timeoutlen = 300
-- Horizontal splits on the right
vim.opt.splitright = true
-- Vertical splits below
vim.opt.splitbelow = true
-- Highlight the line with the cursor
vim.opt.cursorline = true
-- Keep some lines above and below the cursor
vim.opt.scrolloff = 5
-- Enable 256 colors even in text mode
vim.opt.termguicolors = true
-- Transparency for floating windows
vim.opt.winblend = 30

--- Keymaps
-- Clear search highlighting with <Esc>
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

--- Autocommands
-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end
})

-- Status line
vim.defer_fn(function()
  packager.install_package(installed, 'nvim-mini/mini.nvim', 'mini.nvim')
  local ministatusline = require('mini.statusline')
  ministatusline.setup({
    use_icons = true
  })
end, 100)

--- Highlight TODOs
vim.defer_fn(function()
  vim.api.nvim_set_hl(0, 'TodoHighlight', { link = 'Todo' })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    callback = function()
      vim.fn.matchadd('TodoHighlight', [[\<TODO\>]])
      vim.api.nvim_set_hl(0, 'TodoHighlight', { link = 'Todo' })
    end
  })
  vim.api.nvim_exec_autocmds('BufEnter', { buffer = 0 })
end, 200)

--- Git signs
vim.defer_fn(function()
  packager.install_package(installed, 'lewis6991/gitsigns.nvim', 'gitsigns')
  local gitsigns = require('gitsigns')
  gitsigns.setup()
end, 300)

--- Theme
vim.defer_fn(function()
  packager.install_package(installed, 'folke/tokyonight.nvim', 'tokyonight')
  local theme = require('tokyonight')
  theme.setup()
  vim.cmd [[colorscheme tokyonight]]
end, 400)

--- Icons
vim.defer_fn(function()
  packager.install_package(installed, 'nvim-tree/nvim-web-devicons', 'nvim-web-devicons')
  local nvim_web_devicons = require('nvim-web-devicons')
  nvim_web_devicons.setup()
end, 450)

--- Breadcrumbs
vim.defer_fn(function()
  packager.install_package(installed, 'Bekaboo/dropbar.nvim', 'dropbar')
  local dropbar = require('dropbar')
  dropbar.setup()
end, 475)

--- Tabs
vim.defer_fn(function()
  packager.install_package(installed, 'akinsho/bufferline.nvim', 'bufferline')
  local bufferline = require('bufferline')
  bufferline.setup({
    options = {
      nubmers = 'ordinal',
      separator_style = 'slant'
    }
  })
  -- Go to buffer number with <Space> b <buffer_number><Enter>
  vim.keymap.set('n', '<leader>b', ':BufferLineGoToBuffer ', { desc = 'Open [B]uffer (tab) number', noremap = true })
  -- Go to next buffer with <Space> <Tab>
  vim.keymap.set('n', '<leader><Tab>', ':BufferLineCycleNext<CR>', { desc = 'Cycle next tab', noremap = true })
  -- Go to previous buffer with <Space> <Shift-Tab>
  vim.keymap.set('n', '<leader><Shift-Tab>', ':BufferLineCyclePrev<CR>', { desc = 'Cycle previous tab', noremap = true })
  -- Close current buffer with :bd
end, 480)

--- Formatting
vim.defer_fn(function()
  packager.install_package(installed, 'stevearc/conform.nvim', 'conform')
  local conform = require('conform')
  conform.setup({
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      javascript = { 'prettier' }
    },
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = 'fallback'
    }
  })
end, 500)

--- LSP configuration
vim.defer_fn(function()
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
      -- Goto definition
      vim.keymap.set('n', 'gd', vim.lsp.buf.implementation, { buffer = event.buf })
      -- Enable virtual text
      vim.diagnostic.config({
        virtual_text = {
          source = false
        },
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR }
      })
      -- Enable autocompletion while typing
      vim.o.completeopt = 'menu,menuone,noinsert,noselect'
      vim.lsp.completion.enable(true, event.data.client_id, event.buf, { autotrigger = true })
    end
  })
end, 600)

--- Auto pairs
vim.defer_fn(function()
  packager.install_package(installed, 'nvim-mini/mini.nvim', 'mini.nvim')
  local minipairs = require('mini.pairs')
  minipairs.setup()
end, 700)

-- Picker
vim.defer_fn(function()
  packager.install_package(installed, 'nvim-mini/mini.nvim', 'mini.nvim')
  local minipick = require('mini.pick')
  minipick.setup()
  vim.keymap.set('n', '<leader>sf', ':Pick files<cr>', { noremap = true })
  vim.keymap.set('n', '<leader>sg', ':Pick grep_live<cr>', { noremap = true })
end, 800)

--- File manager
vim.defer_fn(function()
  packager.install_package(installed, 'nvim-tree/nvim-tree.lua', 'nvim-tree')
  local nvim_tree = require('nvim-tree')
  nvim_tree.setup({
    disable_netrw = true,
    hijack_netrw = true,
    filters = {
      git_ignored = false
    },
    actions = {
      open_file = {
        quit_on_open = true
      }
    }
  })
  vim.keymap.set('n', '<c-n>', ':NvimTreeToggle<cr>', { noremap = true })
  vim.keymap.set('n', '<leader>sn', ':NvimTreeToggle \'' .. vim.fn.stdpath('config') .. '\' <cr>', { noremap = true })
end, 850)

--- Scrollbar
vim.defer_fn(function()
  packager.install_package(installed, 'petertriho/nvim-scrollbar', 'nvim-scrollbar')
  local scrollbar = require('scrollbar')
  scrollbar.setup({
    handlers = {
      gitsigns = true
    }
  })
end, 875)

--- Automatic indenting
vim.defer_fn(function()
  packager.install_package(installed, 'NMAC427/guess-indent.nvim', 'guess-indent.nvim')
  local guess_indent = require('guess-indent')
  guess_indent.setup({})
  vim.api.nvim_exec_autocmds('BufReadPost', { buffer = 0 })
end, 900)

--- Zen mode
vim.defer_fn(function()
  packager.install_package(installed, 'folke/zen-mode.nvim', 'zen-mode')
  local zen_mode = require('zen-mode')
  zen_mode.setup({
    window = {
      width = .95
    }
  })
  vim.keymap.set('n', '<leader>z', ':ZenMode<cr>', { noremap = true })
end, 950)

--- Relative number on in normal mode, off in insert mode
vim.defer_fn(function()
  packager.install_package(installed, 'sitiom/nvim-numbertoggle', 'nvim-numbertoggle')
end, 975)

--- Lua support
vim.defer_fn(function()
  packager.install_package(installed, 'folke/lazydev.nvim', 'lazydev.nvim')
  local lazydev = require('lazydev')
  lazydev.setup()
  vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
    filetypes = { 'lua' }
  })
  vim.lsp.enable('lua_ls')
end, 1000)

--- Python support
vim.defer_fn(function()
  if not misc.is_npm_package_installed('pyright') then
    vim.fn.system('npm -g install pyright')
  end
  vim.lsp.config('pyright', {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' }
  })
  vim.lsp.enable('pyright')
end, 1100)

--- JavaScript support
vim.defer_fn(function()
  if not misc.is_npm_package_installed('@vue/language-server') then
    vim.fn.system('@vue/language-server')
  end
  if not misc.is_npm_package_installed('typescript') then
    vim.fn.system('typescript')
  end
  if not misc.is_npm_package_installed('@vue/typescript-plugin') then
    vim.fn.system('@vue/typescript-plugin')
  end
  if not misc.is_npm_package_installed('typescript-language-server') then
    vim.fn.system('typescript-language-server')
  end
  vim.lsp.config('ts_ls', {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
  })
  vim.lsp.enable('ts_ls')
end, 1200)

--- Markdown support
vim.defer_fn(function()
  packager.install_package(installed, 'MeanderingProgrammer/render-markdown.nvim', 'render-markdown')
  local render_markdown = require('render-markdown')
  render_markdown.setup({
    completions = {
      lsp = {
        enabled = true
      }
    }
  })
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function(opts)
      if vim.bo[opts.buf].filetype == 'markdown' then
        vim.cmd 'RenderMarkdown enable'
      end
    end
  })
end, 1300)
