local misc = require("misc")
local packager = require("packager")

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

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

--- Packages
local packages_co = coroutine.create(function()
  misc.promise_all({
    --- Theme
    packager.install_package("tokyonight", "folke/tokyonight.nvim"),
    --- Icons for file manager
    packager.install_package("nvim-web-devicons", "nvim-tree/nvim-web-devicons"),
    --- File manager
    packager.install_package("nvim-tree", "nvim-tree/nvim-tree.lua"),
    --- Collection of small packages
    packager.install_package("mini.nvim", "nvim-mini/mini.nvim"),
    --- Git icons in sign column
    packager.install_package("gitsigns", "lewis6991/gitsigns.nvim"),
    --- Breadcrumbs
    packager.install_package("dropbar", "Bekaboo/dropbar.nvim"),
    --- Tabs
    packager.install_package("bufferline", "akinsho/bufferline.nvim"),
    --- Auto-complete
    packager.install_package("conform", "stevearc/conform.nvim"),
    --- Formatting for JavaScript
    packager.install_npm("prettier"),
    --- Scrollbar
    packager.install_package("nvim-scrollbar", "petertriho/nvim-scrollbar"),
    --- Indenting
    packager.install_package("guess-indent", "NMAC427/guess-indent.nvim"),
    --- Zen mode
    packager.install_package("zen-mode", "folke/zen-mode.nvim"),
    --- Relative number on in normal mode, off in insert mode
    packager.install_package("nvim-numbertoggle", "sitiom/nvim-numbertoggle"),
    --- NeoVim API support in lua
    packager.install_package("lazydev", "folke/lazydev.nvim"),
    --- Pyton language server
    packager.install_npm("pyright"),
    --- Bash language server
    packager.install_npm("bash-language-server"),
    --- TypeScript SDK
    packager.install_npm("typescript"),
    --- TypeScript language server
    packager.install_npm("typescript-language-server"),
    --- Vue.js language server
    packager.install_npm("@vue/language-server"),
    --- Vue.js plugin for TypeScript language server
    packager.install_npm("@vue/typescript-plugin"),
    --- Render Markdown files in the editor
    packager.install_package("render-markdown", "MeanderingProgrammer/render-markdown.nvim"),
    --- Relative number on in normal mode, off in insert mode
  })
end)

misc.run_coroutine(packages_co)

--- Theme
local theme = coroutine.create(function()
  local tokyonight = packager.try_require("tokyonight")
  if not tokyonight then
    return false
  end
  tokyonight.setup()
  vim.cmd("colorscheme tokyonight")
end)

--- Icons
local icons = coroutine.create(function()
  local nvim_web_devicons = packager.try_require("nvim-web-devicons")
  if not nvim_web_devicons then
    return false
  end
  require("nvim-web-devicons").setup()
end)

--- File manager
local file_manager = coroutine.create(function()
  local nvim_tree = packager.try_require("nvim-tree")
  if not nvim_tree then
    return false
  end
  nvim_tree.setup({
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
end)

--- Picker
local picker = coroutine.create(function()
  local minipick = packager.try_require("mini.pick")
  if not minipick then
    return false
  end
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
  local pick_neovim_config = function()
    local picked_filename = minipick.start({
      source = {
        items = vim.fn.readdir(vim.fn.stdpath("config")),
      },
    })
    local filename_with_path = vim.fn.stdpath("config") .. "/" .. picked_filename
    vim.cmd("edit " .. filename_with_path)
  end
  vim.keymap.set("n", "<leader>sf", ":Pick files<cr>", { noremap = true })
  vim.keymap.set("n", "<leader>sg", ":Pick grep_live<cr>", { noremap = true })
  vim.keymap.set("n", "<leader>sn", pick_neovim_config, { noremap = true })
end)

--- Status line
local status_line = coroutine.create(function()
  local statusline = packager.try_require("mini.statusline")
  if not statusline then
    return false
  end
  statusline.setup({
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
  local git_signs = packager.try_require("gitsigns")
  if not git_signs then
    return false
  end
  git_signs.setup({
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
  local dropbar = packager.try_require("dropbar")
  if not dropbar then
    return false
  end
  dropbar.setup({
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
  local bufferline = packager.try_require("bufferline")
  if not bufferline then
    return false
  end
  bufferline.setup({
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
  local conform = packager.try_require("conform")
  if not conform then
    return false
  end
  conform.setup({
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "isort", "black" },
      javascript = { "prettier" },
      vue = { "prettier" },
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
    end,
  })
end)

--- Auto pairs
local auto_pairs = coroutine.create(function()
  local mini_pairs = packager.try_require("mini.pairs")
  if not mini_pairs then
    return false
  end
  mini_pairs.setup()
end)

--- Scrollbar
local scrollbar = coroutine.create(function()
  local scroll_bar = packager.try_require("scrollbar")
  if not scroll_bar then
    return false
  end
  scroll_bar.setup({
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
  local guess_indent = packager.try_require("guess-indent")
  if not guess_indent then
    return false
  end
  guess_indent.setup({})
  vim.api.nvim_exec_autocmds("BufReadPost", { buffer = 0 })
end)

--- Zen mode
local zen_mode = coroutine.create(function()
  local zenmode = packager.try_require("zen-mode")
  if not zenmode then
    return false
  end
  zenmode.setup({
    window = {
      width = 0.95,
    },
  })
  vim.keymap.set("n", "<leader>z", ":ZenMode<cr>", { noremap = true })
end)

--- Lua support
local lua = coroutine.create(function()
  local lazydev = packager.try_require("lazydev")
  if not lazydev then
    return false
  end
  lazydev.setup()
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
  vim.lsp.config("pyright", {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
  })
  vim.lsp.enable("pyright")
end)

--- Bash support
local bash = coroutine.create(function()
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
  vim.lsp.config("ts_ls", {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
  })
  vim.lsp.enable("ts_ls")
end)

--- Vue.js support
vim.api.nvim_create_autocmd("FileType", {
  pattern = "vue",
  callback = function()
    local function get_root_dir()
      local path = vim.fn.expand("%:p")
      local markers = { "package.json", ".git" }
      for _, m in ipairs(markers) do
        local found = vim.fn.findfile(m, path .. ";")
        if found ~= "" then
          return vim.fn.fnamemodify(found, ":p:h")
        end
      end
      return vim.fn.fnamemodify(path, ":h")
    end
    local tsdk_path
    local local_ts = vim.fn.getcwd() .. "/node_modules/typescript/lib"
    if vim.fn.isdirectory(local_ts) == 1 then
      tsdk_path = local_ts
    else
      tsdk_path = vim.fn.trim(vim.fn.system("npm root -g")) .. "/typescript/lib"
    end
    if vim.fn.isdirectory(tsdk_path) == 0 then
      print("Warning: TypeScript not found at " .. tsdk_path)
    end
    local volar_client
    for _, c in ipairs(vim.lsp.get_clients()) do
      if c.name == "volar" then
        volar_client = c
        break
      end
    end
    if not volar_client then
      local client_id = vim.lsp.start({
        name = "volar",
        cmd = { "vue-language-server", "--stdio" },
        root_dir = get_root_dir(),
        filetypes = { "vue" },
        capabilities = (function()
          local c = vim.lsp.protocol.make_client_capabilities()
          c.textDocument.completion.completionItem.snippetSupport = true
          c.textDocument.semanticTokens = nil
          return c
        end)(),
        init_options = {
          vue = { hybridMode = false },
          typescript = { tsdk = tsdk_path },
        },
      })
      volar_client = vim.lsp.get_client_by_id(client_id)
    end
    vim.lsp.buf_attach_client(0, volar_client.id)
    local function refresh_diagnostics(bufnr)
      bufnr = bufnr or 0
      local clients = vim.lsp.get_clients({ bufnr = bufnr })
      for _, c in ipairs(clients) do
        if c.name == "volar" then
          if c.supports_method("textDocument/diagnostic") then
            vim.lsp.buf_request(
              bufnr,
              "textDocument/diagnostic",
              vim.lsp.util.make_text_document_params(),
              function() end
            )
          end
        end
      end
    end
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
      pattern = "*.vue",
      callback = function()
        refresh_diagnostics()
      end,
    })
  end,
})

-- Markdown support
local markdown = coroutine.create(function()
  local render_markdown = packager.try_require("render-markdown")
  if not render_markdown then
    return
  end
  render_markdown.setup({
    completions = {
      lsp = {
        enabled = true,
      },
    },
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

vim.defer_fn(function()
  coroutine.resume(theme)
end, 0)
vim.defer_fn(function()
  coroutine.resume(icons)
end, 500)
vim.defer_fn(function()
  coroutine.resume(file_manager)
end, 1000)
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
end, 8040)
