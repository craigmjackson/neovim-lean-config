---@diagnostic disable: need-check-nil
---@diagnostic disable: undefined-field
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

--- Highlight TODOs
vim.api.nvim_set_hl(0, "TodoHighlight", { link = "Todo" })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function()
    vim.fn.matchadd("TodoHighlight", [[\<TODO\>]])
    vim.api.nvim_set_hl(0, "TodoHighlight", { link = "Todo" })
  end,
})
vim.api.nvim_exec_autocmds("BufEnter", { buffer = 0 })

--- LSP configuration
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

--- Theme
local function load_theme()
  return function(cb)
    local tokyonight = packager.try_require("tokyonight")
    if not tokyonight then
      cb(false, nil)
    end
    tokyonight.setup()
    vim.cmd("colorscheme tokyonight")
    cb(true, nil)
  end
end

--- Icons
local function load_icons()
  return function(cb)
    local nvim_web_devicons = packager.try_require("nvim-web-devicons")
    if not nvim_web_devicons then
      cb(false, nil)
    end
    require("nvim-web-devicons").setup()
    cb(true, nil)
  end
end

--- File manager
local function load_file_manager()
  return function(cb)
    local nvim_tree = packager.try_require("nvim-tree")
    if not nvim_tree then
      cb(false, nil)
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
    cb(true, nil)
  end
end

--- Picker
local function load_picker()
  return function(cb)
    local minipick = packager.try_require("mini.pick")
    if not minipick then
      cb(false, nil)
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
    cb(true, nil)
  end
end

--- Status line
local function load_status_line()
  return function(cb)
    local statusline = packager.try_require("mini.statusline")
    if not statusline then
      cb(false, nil)
    end
    statusline.setup({
      use_icons = nerd_font,
    })
    cb(true, nil)
  end
end

--- Git signs
local function load_gitsigns()
  return function(cb)
    local git_signs = packager.try_require("gitsigns")
    if not git_signs then
      cb(false, nil)
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
    cb(true, nil)
  end
end

--- Breadcrumbs
local function load_breadcrumbs()
  return function(cb)
    local dropbar = packager.try_require("dropbar")
    if not dropbar then
      cb(false, nil)
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
    cb(true, nil)
  end
end

--- Tabs
local function load_tabs()
  return function(cb)
    local bufferline = packager.try_require("bufferline")
    if not bufferline then
      cb(false, nil)
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
    cb(true, nil)
  end
end

--- Formatting
local function load_formatting()
  return function(cb)
    local conform = packager.try_require("conform")
    if not conform then
      cb(false, nil)
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
    cb(true, nil)
  end
end

--- Auto pairs
local function load_auto_pairs()
  return function(cb)
    local mini_pairs = packager.try_require("mini.pairs")
    if not mini_pairs then
      cb(false, nil)
    end
    mini_pairs.setup()
    cb(true, nil)
  end
end

--- Scrollbar
local function load_scrollbar()
  return function(cb)
    local scroll_bar = packager.try_require("scrollbar")
    if not scroll_bar then
      cb(false, nil)
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
    cb(true, nil)
  end
end

--- Automatic indenting
local function load_indent()
  return function(cb)
    local guess_indent = packager.try_require("guess-indent")
    if not guess_indent then
      cb(false, nil)
    end
    guess_indent.setup({})
    vim.api.nvim_exec_autocmds("BufReadPost", { buffer = 0 })
    cb(true, nil)
  end
end

--- Zen mode
local function load_zen_mode()
  return function(cb)
    local zenmode = packager.try_require("zen-mode")
    if not zenmode then
      cb(false, nil)
    end
    zenmode.setup({
      window = {
        width = 0.95,
      },
    })
    vim.keymap.set("n", "<leader>z", ":ZenMode<cr>", { noremap = true })
    return cb(true, nil)
  end
end

--- Lua support
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.lua",
  callback = function()
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
      settings = {
        Lua = {
          codeLens = {
            enable = true,
          },
          hint = {
            enable = true,
            semicolon = "Disable",
          },
        },
      },
    })
    vim.lsp.enable("lua_ls")
  end,
})

--- Python support
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.py",
  callback = function()
    vim.lsp.config("pyright", {
      cmd = { "pyright-langserver", "--stdio" },
      filetypes = { "python" },
    })
    vim.lsp.enable("pyright")
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.sh", "*.bash" },
  callback = function()
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
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.ts", "*.js", "*.mjs" },
  callback = function()
    vim.lsp.config("ts_ls", {
      cmd = { "typescript-language-server", "--stdio" },
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
    })
    vim.lsp.enable("ts_ls")
  end,
})

--- Vue.js support
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.vue",
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

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*.md",
  callback = function()
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
    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "*.md",
      callback = function(opts)
        if vim.bo[opts.buf].filetype == "markdown" then
          vim.cmd("RenderMarkdown enable")
        end
      end,
    })
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.json", "*.jsonc" },
  callback = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    vim.lsp.config("jsonls", {
      cmd = { "vscode-json-language-server", "--stdio" },
      filetypes = { "json", "jsonc" },
      init_options = {
        provideFormatter = true,
      },
      root_markers = { ".git" },
      capabilities = capabilities,
    })
    vim.lsp.enable("jsonls")
  end,
})

--- Install essential packages to be loaded immediately
local first_packages_co = coroutine.create(function()
  misc.promise_all({
    --- Theme
    packager.install_package("tokyonight", "folke/tokyonight.nvim"),
    --- Icons for file manager
    packager.install_package("nvim-web-devicons", "nvim-tree/nvim-web-devicons"),
    --- File manager
    packager.install_package("nvim-tree", "nvim-tree/nvim-tree.lua"),
    --- Collection of small packages
    packager.install_package("mini.nvim", "nvim-mini/mini.nvim"),
  })
end)
misc.run_coroutine(first_packages_co)

--- Load first set of coroutines for essential packages
local first_loads_co = coroutine.create(function()
  misc.promise_all({
    --- Theme
    load_theme(),
    --- Icons for file manager
    load_icons(),
    --- File manager
    load_file_manager(),
    --- Collection of small packages
    load_picker,
  })
end)
misc.run_coroutine(first_loads_co)

--- Install remainig packages
local second_packages_co = coroutine.create(function()
  misc.promise_all({
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
    --- JSON language server
    packager.install_npm("vscode-langservers-extracted"),
  })
end)

--- Load remaining packages
local second_loads_co = coroutine.create(function()
  misc.promise_all({
    load_status_line(),
    load_gitsigns(),
    load_breadcrumbs(),
    load_tabs(),
    load_formatting(),
    load_auto_pairs(),
    load_scrollbar(),
    load_indent(),
    load_zen_mode(),
  })
end)
vim.defer_fn(function()
  misc.run_coroutine(second_packages_co)
  misc.run_coroutine(second_loads_co)
end, 100)
