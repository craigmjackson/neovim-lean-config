---@diagnostic disable: need-check-nil
local packager = require("packager")

--- General LSP configuration
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

-- Lua support
-- Install NeoVim API support in lua
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.lua",
	callback = function()
		packager.install_package("lazydev", "folke/lazydev.nvim")
		local lazydev = packager.try_require("lazydev")
		if not lazydev then
			return false
		end
		lazydev.setup()
		vim.lsp.config("lua_ls", {
			on_init = function(client)
				if client.workspace_folders then
					local path = client.workspace_folders[1].name
					if
						path ~= vim.fn.stdpath("config")
						and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
					then
						return
					end
				end
				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						version = "LuaJIT",
						path = {
							"lua/?.lua",
							"lua/?/init.lua",
						},
					},
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
						},
					},
				})
			end,
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

-- Python support
-- Install Python language server
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.py",
	callback = function()
		if vim.g.manage_npm then
			packager.install_npm("pyright")
		end
		if not packager.is_npm_package_installed("pyright") then
			return
		end
		vim.lsp.config("pyright", {
			cmd = { "pyright-langserver", "--stdio" },
			filetypes = { "python" },
		})
		vim.lsp.enable("pyright")
	end,
})

-- Bash support
-- Install Bash language server
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.sh", "*.bash" },
	callback = function()
		if vim.g.manage_npm then
			packager.install_npm("bash-language-server")
		end
		if not packager.is_npm_package_installed("bash-language-server") then
			return
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
	end,
})

-- JavaScript support
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.ts", "*.js", "*.mjs" },
	callback = function()
		if vim.g.manage_npm then
			packager.install_npm("typescript")
			packager.install_npm("typescript-language-server")
		end
		if not packager.is_npm_package_installed("typescript") then
			return
		end
		if not packager.is_npm_package_installed("typescript-language-server") then
			return
		end
		vim.lsp.config("ts_ls", {
			cmd = { "typescript-language-server", "--stdio" },
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
		})
		vim.lsp.enable("ts_ls")
	end,
})

-- Vue.js support
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.vue",
	callback = function()
		if vim.g.manage_npm then
			packager.install_npm("@vue/language-server")
			packager.install_npm("@vue/typescript-plugin")
		end
		if not packager.is_npm_package_installed("@vue/language-server") then
			return
		end
		if not packager.is_npm_package_installed("@vue/typescript-plugin") then
			return
		end
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

-- Markdown rendering support
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.md",
	callback = function()
		packager.install_package("render-markdown", "MeanderingProgrammer/render-markdown.nvim")
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

-- JSON support
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.json", "*.jsonc" },
	callback = function()
		if vim.g.manage_npm then
			packager.install_npm("vscode-langservers-extracted")
		end
		if not packager.is_npm_package_installed("vscode-langservers-extracted") then
			return
		end
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

-- HTML support
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.html",
	callback = function()
		if vim.g.manage_npm then
			packager.install_npm("vscode-langservers-extracted")
		end
		if not packager.is_npm_package_installed("vscode-langservers-extracted") then
			return
		end
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		vim.lsp.config("html", {
			capabilities = capabilities,
			cmd = {
				"vscode-html-language-server",
				"--stdio",
			},
			filetypes = {
				"html",
				"templ",
			},
			init_options = {
				configurationSection = {
					"html",
					"css",
					"javascript",
				},
				embeddedLanguages = {
					css = true,
					javascript = true,
				},
				provideFormatter = true,
			},
			root_markers = {
				"package.json",
				".git",
			},
			settings = {},
		})
		vim.lsp.enable("html")
	end,
})

-- CSS support
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.css", "*.scss", "*.less" },
	callback = function()
		if vim.g.manage_npm then
			packager.install_npm("vscode-langservers-extracted")
		end
		if not packager.is_npm_package_installed("vscode-langservers-extracted") then
			return
		end
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		vim.lsp.config("cssls", {
			capabilities = capabilities,
			cmd = { "vscode-css-language-server", "--stdio" },
			filetypes = {
				"css",
				"scss",
				"less",
			},
			init_options = {
				provideFormatter = true,
			},
			root_markers = {
				"package.json",
				".git",
			},
			settings = {
				css = {
					validate = true,
				},
				scss = {
					validate = true,
				},
				less = {
					validate = true,
				},
			},
		})
		vim.lsp.enable("cssls")
	end,
})

-- SQL support
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.sql",
	callback = function()
		if vim.g.manage_npm then
			packager.install_npm("sql-language-server")
		end
		if not packager.is_npm_package_installed("sql-language-server") then
			return
		end
		vim.lsp.config("sqlls", {
			cmd = { "sql-language-server", "up", "--method", "stdio" },
			filetypes = { "sql", "mysql" },
			root_markers = { ".sqllsrc.json" },
			settings = {},
		})
		vim.lsp.enable("sqlls")
	end,
})

-- Yaml support
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.yaml", "*.yml" },
	callback = function()
		if vim.g.manage_npm then
			packager.install_npm("yaml-language-server")
		end
		if not packager.is_npm_package_installed("yaml-language-server") then
			return
		end
		vim.lsp.config("yamlls", {
			cmd = { "yaml-language-server", "--stdio" },
			filetypes = { "yaml" },
			root_markers = { ".git" },
			settings = {
				redhat = {
					telemetry = {
						enabled = false,
					},
				},
				yaml = {
					format = {
						enable = true,
					},
				},
			},
			on_init = function(client)
				client.server_capabilities.documentFormattingProvider = true
			end,
		})
		vim.lsp.enable("yamlls")
	end,
})
