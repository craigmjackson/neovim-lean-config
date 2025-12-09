local packager = require('lua/packager')
local misc = require('lua/misc')

INSTALLED = {}

--- Nerd fonts are special programming fonts that provide icons.
--- Set to false if you don't have a nerd font or can't guarantee
--- the user has one.  Get one from https://www.nerdfonts.com/font-downloads
--- and set your terminal emulator to use it.
local nerd_font = true

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

--- Theme
vim.defer_fn(function()
  -- local start_time = misc.get_time()
  packager.install_package('folke/tokyonight.nvim', 'tokyonight')
  local theme = require('tokyonight')
  theme.setup()
  vim.cmd [[colorscheme tokyonight]]
  -- local end_time = misc.get_time()
  -- print('Theme Delta: ', misc.get_time_delta(start_time, end_time))
end, 0)

--- Icons
vim.defer_fn(function()
  if nerd_font then
    -- local start_time = misc.get_time()
    packager.install_package('nvim-tree/nvim-web-devicons', 'nvim-web-devicons')
    local nvim_web_devicons = require('nvim-web-devicons')
    nvim_web_devicons.setup()
    -- local end_time = misc.get_time()
    -- print('Icons Delta: ', misc.get_time_delta(start_time, end_time))
  end
end, 30)

--- File manager
vim.defer_fn(function()
  -- local start_time = misc.get_time()
  packager.install_package('nvim-tree/nvim-tree.lua', 'nvim-tree')
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
    },
    renderer = {
      icons = {
        web_devicons = {
          file = {
            enable = nerd_font,
            color = true
          },
          folder = {
            enable = nerd_font,
            color = true
          }
        },
        glyphs = nerd_font and {} or {
          default = '',
          symlink = '',
          bookmark = '',
          modified = 'm',
          hidden = '',
          folder = {
            arrow_closed = '>',
            arrow_open = 'v',
            default = 'd',
            open = 'd',
            empty = 'd',
            empty_open = 'd',
            symlink = 'ds',
            symlink_open = 'ds',
          },
          git = {
            unstaged = '',
            staged = 's',
            unmerged = '',
            untracked = '',
            deleted = 'd',
            ignored = '',
          }
        }
      }
    }
  })
  vim.keymap.set('n', '<c-n>', ':NvimTreeToggle<cr>', { noremap = true })
  vim.keymap.set('n', '<leader>sn', ':NvimTreeToggle \'' .. vim.fn.stdpath('config') .. '\' <cr>', { noremap = true })
  -- local end_time = misc.get_time()
  -- print('File manager Delta: ', misc.get_time_delta(start_time, end_time))
end, 50)

-- Picker
vim.defer_fn(function()
  -- local start_time = misc.get_time()
  packager.install_package('nvim-mini/mini.nvim', 'mini.nvim')
  local minipick = require('mini.pick')
  minipick.setup({
    source = {
      show = minipick.default_show
    },
    window = {
      prompt_caret = '|',
      prompt_prefix = '> '
    },
    show_icons = nerd_font
  })
  vim.keymap.set('n', '<leader>sf', ':Pick files<cr>', { noremap = true })
  vim.keymap.set('n', '<leader>sg', ':Pick grep_live<cr>', { noremap = true })
  -- local end_time = misc.get_time()
  -- print('Picker Delta: ', misc.get_time_delta(start_time, end_time))
end, 80)

-- Status line
vim.defer_fn(function()
  -- local start_time = misc.get_time()
  packager.install_package('nvim-mini/mini.nvim', 'mini.nvim')
  local ministatusline = require('mini.statusline')
  ministatusline.setup({
    use_icons = nerd_font
  })
  -- local end_time = misc.get_time()
  -- print('Status line Delta: ', misc.get_time_delta(start_time, end_time))
end, 95)

--- Highlight TODOs
vim.defer_fn(function()
  -- local start_time = misc.get_time()
  vim.api.nvim_set_hl(0, 'TodoHighlight', { link = 'Todo' })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
    callback = function()
      vim.fn.matchadd('TodoHighlight', [[\<TODO\>]])
      vim.api.nvim_set_hl(0, 'TodoHighlight', { link = 'Todo' })
    end
  })
  vim.api.nvim_exec_autocmds('BufEnter', { buffer = 0 })
  -- local end_time = misc.get_time()
  -- print('Highlight Todos Delta: ', misc.get_time_delta(start_time, end_time))
end, 105)

--- Git signs
vim.defer_fn(function()
  -- local start_time = misc.get_time()
  packager.install_package('lewis6991/gitsigns.nvim', 'gitsigns')
  local gitsigns = require('gitsigns')
  gitsigns.setup({
    signs = {
      add          = { text = '|' },
      change       = { text = '|' },
      delete       = { text = '_' },
      topdelete    = { text = '_' },
      changedelete = { text = '~' },
      untracked    = { text = ' ' },
    },
    signs_staged = {
      add          = { text = '|' },
      change       = { text = '|' },
      delete       = { text = '_' },
      topdelete    = { text = '_' },
      changedelete = { text = '~' },
      untracked    = { text = ' ' },
    }
  })
  -- local end_time = misc.get_time()
  -- print('Git signs Delta: ', misc.get_time_delta(start_time, end_time))
end, 115)

--- Breadcrumbs
vim.defer_fn(function()
  -- local start_time = misc.get_time()
  packager.install_package('Bekaboo/dropbar.nvim', 'dropbar')
  local dropbar = require('dropbar')
  dropbar.setup({
    icons = nerd_font and {} or {
      kinds = {
        symbols = {
          Array = '(arr)',
          BlockMappingPair = '(blkmappair)',
          Boolean = '(bool)',
          BreakStatement = '(brk)',
          Call = '(call)',
          CaseStatement = '(case)',
          Class = '(cls)',
          Constant = '(const)',
          Constructor = '(constr)',
          ContinueStatment = '(cont)',
          Copilot = '(copilot)',
          Declaration = '(decl)',
          Delete = '(del)',
          DoStatement = '(do)',
          Element = '(elem)',
          Enum = '(enum)',
          EnumMember = '(emumMem)',
          Event = '(evt)',
          Field = '(fld)',
          File = '(f)',
          Folder = '(d)',
          ForStatement = '(for)',
          Function = '(fn)',
          GotoStatement = '(goto)',
          Identifier = '(ident)',
          IfStatement = '(if)',
          Interface = '(intf)',
          Keyword = '(kwd)',
          List = '(list)',
          Log = '(log)',
          Lsp = '(lsp)',
          Macro = '(mac)',
          MarkdownH1 = '(h1)',
          MarkdownH2 = '(h2)',
          MarkdownH3 = '(h3)',
          MarkdownH4 = '(h4)',
          MarkdownH5 = '(h5)',
          MarkdownH6 = '(h6)',
          Method = '(mth)',
          Module = '(mod)',
          Namespace = "(ns)",
          Null = '(nul)',
          Number = '(num)',
          Object = '(obj)',
          Operator = '(oper)',
          Package = '(pkg)',
          Pair = '(pair)',
          Property = '(prop)',
          Reference = '(ref)',
          Regex = '(regex)',
          Repeat = '(rep)',
          Return = '(ret)',
          Rule = '(rule)',
          RuleSet = '(ruleset)',
          Scope = '(scope)',
          Section = '(sec)',
          Snippet = '(snip)',
          Specifier = '(spec)',
          Statement = '(stmt)',
          String = '(str)',
          Struct = '(struct)',
          SwitchStatement = '(swit)',
          Table = '(tbl)',
          Terminal = '(term)',
          Text = '(txt)',
          Type = '(type)',
          TypeParameter = '(typepar)',
          Unit = '(unit)',
          Value = '(val)',
          Variable = '(var)',
          WhileStatement = '(whl)'
        }
      },
      ui = {
        bar = {
          separator = '> ',
          extends = '...'
        },
        menu = {
          separator = ' ',
          indicator = '> '
        }
      }
    }
  })
  -- local end_time = misc.get_time()
  -- print('Breadcrubms Delta: ', misc.get_time_delta(start_time, end_time))
end, 145)

--- Tabs
vim.defer_fn(function()
  -- local start_time = misc.get_time()
  packager.install_package('akinsho/bufferline.nvim', 'bufferline')
  local bufferline = require('bufferline')
  bufferline.setup({
    options = {
      nubmers = 'ordinal',
      separator_style = 'slant',
      buffer_close_icon = nerd_font and '' or 'x',
      close_icon = nerd_font and '' or 'x',
      modified_icon = nerd_font and '' or 'm',
      left_trunc_marker = nerd_font and '' or '/',
      right_trunc_marker = nerd_font and '' or '\\',
    }
  })
  -- Go to buffer number with <Space> b <buffer_number><Enter>
  vim.keymap.set('n', '<leader>b', ':BufferLineGoToBuffer ', { desc = 'Open [B]uffer (tab) number', noremap = true })
  -- Go to next buffer with <Space> <Tab>
  vim.keymap.set('n', '<leader><Tab>', ':BufferLineCycleNext<CR>', { desc = 'Cycle next tab', noremap = true })
  -- Go to previous buffer with <Space> <Shift-Tab>
  vim.keymap.set('n', '<leader><Shift-Tab>', ':BufferLineCyclePrev<CR>', { desc = 'Cycle previous tab', noremap = true })
  -- Close current buffer with :bd
  -- local end_time = misc.get_time()
  -- print('Tabs Delta: ', misc.get_time_delta(start_time, end_time))
end, 160)

--- Formatting
vim.defer_fn(function()
  -- local start_time = misc.get_time()
  packager.install_package('stevearc/conform.nvim', 'conform')
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
  -- local end_time = misc.get_time()
  -- print('Formatting Delta: ', misc.get_time_delta(start_time, end_time))
end, 185)

--- LSP configuration
vim.defer_fn(function()
  -- local start_time = misc.get_time()
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
  -- local end_time = misc.get_time()
  -- print('LSP config Delta: ', misc.get_time_delta(start_time, end_time))
end, 195)

--- Auto pairs
vim.defer_fn(function()
  -- local start_time = misc.get_time()
  packager.install_package('nvim-mini/mini.nvim', 'mini.nvim')
  local minipairs = require('mini.pairs')
  minipairs.setup()
  -- local end_time = misc.get_time()
  -- print('Autopairs Delta: ', misc.get_time_delta(start_time, end_time))
end, 205)

--- Scrollbar
vim.defer_fn(function()
  -- local start_time = misc.get_time()
  packager.install_package('petertriho/nvim-scrollbar', 'nvim-scrollbar')
  local scrollbar = require('scrollbar')
  scrollbar.setup({
    handlers = {
      gitsigns = true
    },
    marks = nerd_font and {} or {
      Cursor = {
        text = "*"
      },
      Search = {
        text = { "-", "=" }
      },
      Error = {
        text = { "-", "=" }
      },
      Warn = {
        text = { "-", "=" }
      },
      Info = {
        text = { "-", "=" }
      },
      Hint = {
        text = { "-", "=" }
      },
      Misc = {
        text = { "-", "=" }
      },
      GitAdd = {
        text = "|"
      },
      GitChange = {
        text = "|"
      },
      GitDelete = {
        text = "_"
      },
    }
  })
  -- local end_time = misc.get_time()
  -- print('Scrollbar Delta: ', misc.get_time_delta(start_time, end_time))
end, 215)

--- Automatic indenting
vim.defer_fn(function()
  -- local start_time = misc.get_time()
  packager.install_package('NMAC427/guess-indent.nvim', 'guess-indent.nvim')
  local guess_indent = require('guess-indent')
  guess_indent.setup({})
  vim.api.nvim_exec_autocmds('BufReadPost', { buffer = 0 })
  -- local end_time = misc.get_time()
  -- print('Automatic indenting Delta: ', misc.get_time_delta(start_time, end_time))
end, 235)

--- Zen mode
vim.defer_fn(function()
  -- local start_time = misc.get_time()
  packager.install_package('folke/zen-mode.nvim', 'zen-mode')
  local zen_mode = require('zen-mode')
  zen_mode.setup({
    window = {
      width = .95
    }
  })
  vim.keymap.set('n', '<leader>z', ':ZenMode<cr>', { noremap = true })
  -- local end_time = misc.get_time()
  -- print('Zen mode Delta: ', misc.get_time_delta(start_time, end_time))
end, 265)

--- Relative number on in normal mode, off in insert mode
vim.defer_fn(function()
  -- local start_time = misc.get_time()
  packager.install_package('sitiom/nvim-numbertoggle', 'nvim-numbertoggle')
  -- local end_time = misc.get_time()
  -- print('Relative number Delta: ', misc.get_time_delta(start_time, end_time))
end, 280)

--- Lua support
vim.defer_fn(function()
  -- local start_time = misc.get_time()
  packager.install_package('folke/lazydev.nvim', 'lazydev.nvim')
  local lazydev = require('lazydev')
  lazydev.setup()
  vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
    filetypes = { 'lua' }
  })
  vim.lsp.enable('lua_ls')
  -- local end_time = misc.get_time()
  -- print('lua support Delta: ', misc.get_time_delta(start_time, end_time))
end, 290)

--- Python support
vim.defer_fn(function()
  -- local start_time = misc.get_time()
  if not misc.is_npm_package_installed('pyright') then
    vim.fn.system('npm -g install pyright')
  end
  vim.lsp.config('pyright', {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' }
  })
  vim.lsp.enable('pyright')
  -- local end_time = misc.get_time()
  -- print('python support Delta: ', misc.get_time_delta(start_time, end_time))
end, 310)

--- Bash support
---- Install 'shellcheck' for linting and 'shfmt' for formatting
vim.defer_fn(function()
  -- local start_time = misc.get_time()
  if not misc.is_npm_package_installed('bash-language-server') then
    vim.fn.system('npm -g install bash-language-server')
  end
  vim.lsp.config('bashls', {
    cmd = { 'bash-language-server', 'start' },
    settings = {
      bashIde = {
        globPattern = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)'
      }
    },
    filetypes = { 'bash', 'sh' },
    root_markers = { '.git' }
  })
  vim.lsp.enable('bashls')
  -- local end_time = misc.get_time()
  -- print('bash support Delta: ', misc.get_time_delta(start_time, end_time))
end, 2000)

--- JavaScript support
vim.defer_fn(function()
  -- local start_time = misc.get_time()
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
  -- local end_time = misc.get_time()
  -- print('javascript support Delta: ', misc.get_time_delta(start_time, end_time))
end, 3000)

--- Markdown support
vim.defer_fn(function()
  -- local start_time = misc.get_time()
  packager.install_package('MeanderingProgrammer/render-markdown.nvim', 'render-markdown')
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
  -- local end_time = misc.get_time()
  -- print('markdown support Delta: ', misc.get_time_delta(start_time, end_time))
end, 6000)
