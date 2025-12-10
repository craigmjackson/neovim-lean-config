local packager = require("lua/packager")
local misc = require("lua/misc")

INSTALLED = {}
TASKS = {}

--- Nerd fonts are special programming fonts that provide icons.
--- Set to false if you don't have a nerd font or can't guarantee
--- the user has one.  Get one from https://www.nerdfonts.com/font-downloads
--- and set your terminal emulator to use it.
local nerd_font = true

--- Options
-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Enable line numbers
vim.opt.number = true
-- Enable relative line numbers
vim.opt.relativenumber = true
-- Enable mouse support
vim.opt.mouse = "nvi"
-- Sync with the OS clipboard
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)
-- Make undo files
vim.opt.undofile = true
-- Make searches case-insensitive in general
vim.opt.ignorecase = true
-- If there is a mixed case in your search, make it case-sensitive
vim.opt.smartcase = true
-- Only show sign column if needed
vim.opt.signcolumn = "yes"
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
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

--- Autocommands
-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

--- Theme
local theme = coroutine.create(function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packages/opt/tokyonight"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.notify('Installing folke/tokyonight to ' .. install_path .. '...', vim.log.levels.INFO)
    local _ = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/folke/tokyonight.nvim",
      install_path,
    })
  end
  vim.cmd("packadd tokyonight")
  vim.cmd("colorscheme tokyonight")
end)

--- Icons
local icons = coroutine.create(function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packages/opt/nvim-web-devicons"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.notify("Installing nvim-tree/nvim-web-devicons...", vim.log.levels.INFO)
    local _ = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/nvim-tree/nvim-web-devicons",
      install_path,
    })
  end
  vim.cmd("packadd nvim-web-devicons")
  vim.cmd("packloadall")
  require("nvim-web-devicons").setup()
end)

--- File manager
local file_manager = coroutine.create(function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packages/opt/nvim-tree"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.notify("Installing nvim-tree/nvim-tree.lua...", vim.log.levels.INFO)
    local _ = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/nvim-tree/nvim-tree.lua",
      install_path,
    })
  end
  vim.cmd("packadd nvim-tree")
  vim.cmd("packloadall")
  require("nvim-tree").setup({
    disable_netrw = true,
    hijack_netrw = true,
    filters = {
      git_ignored = false,
    },
    actions = {
      open_file = {
        quit_on_open = true,
      },
    },
    renderer = {
      icons = {
        web_devicons = {
          file = {
            enable = nerd_font,
            color = true,
          },
          folder = {
            enable = nerd_font,
            color = true,
          },
        },
        glyphs = nerd_font and {} or {
          default = "",
          symlink = "",
          bookmark = "",
          modified = "m",
          hidden = "",
          folder = {
            arrow_closed = ">",
            arrow_open = "v",
            default = "d",
            open = "d",
            empty = "d",
            empty_open = "d",
            symlink = "ds",
            symlink_open = "ds",
          },
          git = {
            unstaged = "",
            staged = "s",
            unmerged = "",
            untracked = "",
            deleted = "d",
            ignored = "",
          },
        },
      },
    },
  })
  vim.keymap.set("n", "<c-n>", ":NvimTreeToggle<cr>", { noremap = true })
  vim.keymap.set("n", "<leader>sn", ":NvimTreeToggle '" .. vim.fn.stdpath("config") .. "' <cr>", { noremap = true })
end)

--- Picker
local picker = coroutine.create(function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packages/opt/mini.nvim"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.notify("Installing nvim-mini/mini.nvim...", vim.log.levels.INFO)
    local _ = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/nvim-mini/mini.nvim",
      install_path,
    })
  end
  vim.cmd("packadd mini.nvim")
  vim.cmd("packloadall")
  local minipick = require("mini.pick")
  minipick.setup({
    source = {
      show = minipick.default_show,
    },
    window = {
      prompt_caret = "|",
      prompt_prefix = "> ",
    },
    show_icons = nerd_font,
  })
  vim.keymap.set("n", "<leader>sf", ":Pick files<cr>", { noremap = true })
  vim.keymap.set("n", "<leader>sg", ":Pick grep_live<cr>", { noremap = true })
end)

--- Status line
local status_line = coroutine.create(function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packages/opt/mini.nvim"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.notify("Installing nvim-mini/mini.nvim...", vim.log.levels.INFO)
    local _ = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/nvim-mini/mini.nvim",
      install_path,
    })
  end
  vim.cmd("packadd mini.nvim")
  vim.cmd("packloadall")
  require("mini.statusline").setup({
    use_icons = nerd_font,
  })
end)

--- Highlight TODOs
local highlight_todo = coroutine.create(function()
  vim.api.nvim_set_hl(0, "TodoHighlight", { link = "Todo" })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    callback = function()
      vim.fn.matchadd("TodoHighlight", [[\<TODO\>]])
      vim.api.nvim_set_hl(0, "TodoHighlight", { link = "Todo" })
    end,
  })
  vim.api.nvim_exec_autocmds("BufEnter", { buffer = 0 })
end)

--- Git signs
local gitsigns = coroutine.create(function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packages/opt/gitsigns"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.notify("Installing lewis6991/gitsigns.nvim...", vim.log.levels.INFO)
    local _ = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/lewis6991/gitsigns.nvim",
      install_path,
    })
  end
  vim.cmd("packadd gitsigns")
  vim.cmd("packloadall")
  require("gitsigns").setup({
    signs = {
      add = { text = "|" },
      change = { text = "|" },
      delete = { text = "_" },
      topdelete = { text = "_" },
      changedelete = { text = "~" },
      untracked = { text = " " },
    },
    signs_staged = {
      add = { text = "|" },
      change = { text = "|" },
      delete = { text = "_" },
      topdelete = { text = "_" },
      changedelete = { text = "~" },
      untracked = { text = " " },
    },
  })
end)

--- Breadcrumbs
local breadcrumbs = coroutine.create(function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packages/opt/dropbar"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.notify("Installing Bekaboo/dropbar.nvim...", vim.log.levels.INFO)
    local _ = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/Bekaboo/dropbar.nvim",
      install_path,
    })
  end
  vim.cmd("packadd dropbar")
  vim.cmd("packloadall")
  require("dropbar").setup({
    icons = nerd_font and {} or {
      kinds = {
        symbols = {
          Array = "(arr)",
          BlockMappingPair = "(blkmappair)",
          Boolean = "(bool)",
          BreakStatement = "(brk)",
          Call = "(call)",
          CaseStatement = "(case)",
          Class = "(cls)",
          Constant = "(const)",
          Constructor = "(constr)",
          ContinueStatment = "(cont)",
          Copilot = "(copilot)",
          Declaration = "(decl)",
          Delete = "(del)",
          DoStatement = "(do)",
          Element = "(elem)",
          Enum = "(enum)",
          EnumMember = "(emumMem)",
          Event = "(evt)",
          Field = "(fld)",
          File = "(f)",
          Folder = "(d)",
          ForStatement = "(for)",
          Function = "(fn)",
          GotoStatement = "(goto)",
          Identifier = "(ident)",
          IfStatement = "(if)",
          Interface = "(intf)",
          Keyword = "(kwd)",
          List = "(list)",
          Log = "(log)",
          Lsp = "(lsp)",
          Macro = "(mac)",
          MarkdownH1 = "(h1)",
          MarkdownH2 = "(h2)",
          MarkdownH3 = "(h3)",
          MarkdownH4 = "(h4)",
          MarkdownH5 = "(h5)",
          MarkdownH6 = "(h6)",
          Method = "(mth)",
          Module = "(mod)",
          Namespace = "(ns)",
          Null = "(nul)",
          Number = "(num)",
          Object = "(obj)",
          Operator = "(oper)",
          Package = "(pkg)",
          Pair = "(pair)",
          Property = "(prop)",
          Reference = "(ref)",
          Regex = "(regex)",
          Repeat = "(rep)",
          Return = "(ret)",
          Rule = "(rule)",
          RuleSet = "(ruleset)",
          Scope = "(scope)",
          Section = "(sec)",
          Snippet = "(snip)",
          Specifier = "(spec)",
          Statement = "(stmt)",
          String = "(str)",
          Struct = "(struct)",
          SwitchStatement = "(swit)",
          Table = "(tbl)",
          Terminal = "(term)",
          Text = "(txt)",
          Type = "(type)",
          TypeParameter = "(typepar)",
          Unit = "(unit)",
          Value = "(val)",
          Variable = "(var)",
          WhileStatement = "(whl)",
        },
      },
      ui = {
        bar = {
          separator = "> ",
          extends = "...",
        },
        menu = {
          separator = " ",
          indicator = "> ",
        },
      },
    },
  })
end)

--- Tabs
local tabs = coroutine.create(function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packages/opt/bufferline"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.notify("Installing akinsho/bufferline.nvim...", vim.log.levels.INFO)
    local _ = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/akinsho/bufferline.nvim",
      install_path,
    })
  end
  vim.cmd("packadd bufferline")
  vim.cmd("packloadall")
  require("bufferline").setup({
    options = {
      nubmers = "ordinal",
      separator_style = "slant",
      buffer_close_icon = nerd_font and "" or "x",
      close_icon = nerd_font and "" or "x",
      modified_icon = nerd_font and "" or "m",
      left_trunc_marker = nerd_font and "" or "/",
      right_trunc_marker = nerd_font and "" or "\\",
    },
  })
  -- Go to buffer number with <Space> b <buffer_number><Enter>
  vim.keymap.set("n", "<leader>b", ":BufferLineGoToBuffer ", { desc = "Open [B]uffer (tab) number", noremap = true })
  -- Go to next buffer with <Space> <Tab>
  vim.keymap.set("n", "<leader><Tab>", ":BufferLineCycleNext<CR>", { desc = "Cycle next tab", noremap = true })
  -- Go to previous buffer with <Space> <Shift-Tab>
  vim.keymap.set(
    "n",
    "<leader><Shift-Tab>",
    ":BufferLineCyclePrev<CR>",
    { desc = "Cycle previous tab", noremap = true }
  )
  -- Close current buffer with :bd
end)

--- Formatting
local formatting = coroutine.create(function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packages/opt/conform"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.notify("Installing stevearc/conform.nvim...", vim.log.levels.INFO)
    local _ = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/stevearc/conform.nvim",
      install_path,
    })
  end
  vim.cmd("packadd conform")
  vim.cmd("packloadall")
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { "prettier" },
    },
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = "fallback",
    },
  })
end)

--- LSP configuration
local lsp_config = coroutine.create(function()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      -- Goto definition
      vim.keymap.set("n", "gd", vim.lsp.buf.implementation, { buffer = event.buf })
      -- Enable virtual text
      vim.diagnostic.config({
        virtual_text = {
          source = false,
        },
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
      })
      -- Enable autocompletion while typing
      vim.o.completeopt = "menu,menuone,noinsert,noselect"
      vim.lsp.completion.enable(true, event.data.client_id, event.buf, { autotrigger = true })
    end
  })
end)

--- Auto pairs
local auto_pairs = coroutine.create(function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packages/opt/mini.nvim"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.notify("Installing nvim-mini/mini.nvim...", vim.log.levels.INFO)
    local _ = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/nvim-mini/mini.nvim",
      install_path,
    })
  end
  vim.cmd("packadd mini.nvim")
  vim.cmd("packloadall")
  require("mini.pairs").setup()
end)

--- Scrollbar
local scrollbar = coroutine.create(function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packages/opt/nvim-scrollbar"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.notify("Installing petertriho/nvim-scollbar...", vim.log.levels.INFO)
    local _ = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/petertriho/nvim-scrollbar",
      install_path,
    })
  end
  vim.cmd("packadd nvim-scrollbar")
  vim.cmd("packloadall")
  require("scrollbar").setup({
    handlers = {
      gitsigns = true,
    },
    marks = nerd_font and {} or {
      Cursor = {
        text = "*",
      },
      Search = {
        text = { "-", "=" },
      },
      Error = {
        text = { "-", "=" },
      },
      Warn = {
        text = { "-", "=" },
      },
      Info = {
        text = { "-", "=" },
      },
      Hint = {
        text = { "-", "=" },
      },
      Misc = {
        text = { "-", "=" },
      },
      GitAdd = {
        text = "|",
      },
      GitChange = {
        text = "|",
      },
      GitDelete = {
        text = "_",
      },
    },
  })
end)

--- Automatic indenting
local indent = coroutine.create(function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packages/opt/guess-indent.nvim"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.notify("Installing NMAC427/guess-indent.nvim...", vim.log.levels.INFO)
    local _ = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/NMAC427/guess-indent.nvim",
      install_path,
    })
  end
  vim.cmd("packadd guess-indent.nvim")
  vim.cmd("packloadall")
  require("guess-indent").setup({})
  vim.api.nvim_exec_autocmds("BufReadPost", { buffer = 0 })
end)

--- Zen mode
local zen_mode = coroutine.create(function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packages/opt/zen-mode"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.notify("Installing folke/zen-mode.nvim...", vim.log.levels.INFO)
    local _ = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/folke/zen-mode.nvim",
      install_path,
    })
  end
  vim.cmd("packadd zen-mode")
  vim.cmd("packloadall")
  require("zen-mode").setup({
    window = {
      width = 0.95,
    },
  })
  vim.keymap.set("n", "<leader>z", ":ZenMode<cr>", { noremap = true })
end)

--- Relative number on in normal mode, off in insert mode
local number_toggle = coroutine.create(function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packages/opt/nvim-numbertoggle"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.notify("Installing sitiom/nvim-numbertoggle...", vim.log.levels.INFO)
    local _ = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/sitiom/nvim-numbertoggle",
      install_path,
    })
  end
  vim.cmd("packadd nvim-numbertoggle")
  vim.cmd("packloadall")
end)

--- Lua support
local lua = coroutine.create(function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packages/opt/lazydev.nvim"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.notify("Installing folke/lazydev.nvim...", vim.log.levels.INFO)
    local _ = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/folke/lazydev.nvim",
      install_path,
    })
  end
  vim.cmd("packadd lazydev.nvim")
  vim.cmd("packloadall")
  require('lazydev').setup()
  vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    root_markers = {
      ".luarc.json",
      ".luarc.jsonc",
      ".luacheckrc",
      ".stylua.toml",
      "stylua.toml",
      "selene.toml",
      "selene.yml",
      ".git",
    },
    filetypes = { "lua" },
  })
  vim.lsp.enable("lua_ls")
end)

--- Python support
local python = coroutine.create(function()
  if not misc.is_npm_package_installed("pyright") then
    local _ = vim.fn.system("npm -g install pyright")
  end
  vim.lsp.config("pyright", {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
  })
  vim.lsp.enable("pyright")
end)

--- Bash support
local bash = coroutine.create(function()
  if not misc.is_npm_package_installed("bash-language-server") then
    local _ = vim.fn.system("npm -g install bash-language-server")
  end
  vim.lsp.config("bashls", {
    cmd = { "bash-language-server", "start" },
    settings = {
      bashIde = {
        globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
      },
    },
    filetypes = { "bash", "sh" },
    root_markers = { ".git" },
  })
  vim.lsp.enable("bashls")
end)

--- JavaScript support
local javascript = coroutine.create(function()
  if not misc.is_npm_package_installed("@vue/language-server") then
    local _ = vim.fn.system("@vue/language-server")
  end
  if not misc.is_npm_package_installed("typescript") then
    local _ = vim.fn.system("typescript")
  end
  if not misc.is_npm_package_installed("@vue/typescript-plugin") then
    local _ = vim.fn.system("@vue/typescript-plugin")
  end
  if not misc.is_npm_package_installed("typescript-language-server") then
    local _ = vim.fn.system("typescript-language-server")
  end
  vim.lsp.config("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
  })
  vim.lsp.enable("ts_ls")
end)

--- Markdown support
local markdown = coroutine.create(function()
  local install_path = vim.fn.stdpath("data") .. "/site/pack/packages/opt/render-markdown"
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.notify("Installing MeanderingProgrammer/render-markdown.nvim...", vim.log.levels.INFO)
    local _ = vim.fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/MeanderingProgrammer/render-markdown.nvim",
      install_path,
    })
  end
  vim.cmd("packadd render-markdown")
  vim.cmd("packloadall")
  require('render-markdown').setup({
    completions = {
      lsp = {
        enabled = true,
      },
    }
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function(opts)
      if vim.bo[opts.buf].filetype == "markdown" then
        vim.cmd("RenderMarkdown enable")
      end
    end,
  })
end)

coroutine.resume(theme)
coroutine.resume(icons)
coroutine.resume(file_manager)
vim.defer_fn(function()
  coroutine.resume(picker)
end, 5000)
vim.defer_fn(function()
  coroutine.resume(status_line)
end, 5200)
vim.defer_fn(function()
  coroutine.resume(highlight_todo)
end, 5400)
vim.defer_fn(function()
  coroutine.resume(gitsigns)
end, 5600)
vim.defer_fn(function()
  coroutine.resume(breadcrumbs)
end, 5800)
vim.defer_fn(function()
  coroutine.resume(tabs)
end, 5900)
vim.defer_fn(function()
  coroutine.resume(formatting)
end, 6000)
vim.defer_fn(function()
  coroutine.resume(lsp_config)
end, 6200)
vim.defer_fn(function()
  coroutine.resume(auto_pairs)
end, 6400)
vim.defer_fn(function()
  coroutine.resume(scrollbar)
end, 6600)
vim.defer_fn(function()
  coroutine.resume(indent)
end, 6800)
vim.defer_fn(function()
  coroutine.resume(zen_mode)
end, 7000)
vim.defer_fn(function()
  coroutine.resume(number_toggle)
end, 7200)
vim.defer_fn(function()
  coroutine.resume(lua)
end, 7400)
vim.defer_fn(function()
  coroutine.resume(python)
end, 7600)
vim.defer_fn(function()
  coroutine.resume(bash)
end, 7800)
vim.defer_fn(function()
  coroutine.resume(javascript)
end, 8000)
vim.defer_fn(function()
  coroutine.resume(markdown)
end, 8020)
