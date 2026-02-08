vim.g.mapleader = " " -- Change leader to a <space> before plugins setup

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
--<|editable_region_start|>
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Start plugins setup
require("lazy").setup(
	{
		{
			"ThePrimeagen/99",
			config = function()
				local _99 = require("99")
				-- For logging that is to a file if you wish to trace through requests
				-- for reporting bugs, i would not rely on this, but instead the provided
				-- logging mechanisms within 99.  This is for more debugging purposes
				_99.setup({
					model = "openai/gpt-5.2-codex",
					--- A new feature that is centered around tags
					completion = {
						custom_rules = {
							"./opencode/rules",
						},
						source = "cmp",
					},
					md_files = {
						"AGENTS.md",
					},
				})

				-- Create your own short cuts for the different types of actions
				vim.keymap.set("n", "<c-l>", function()
					_99.fill_in_function()
				end)

				vim.keymap.set("v", "<leader>lv", function()
					_99.visual()
				end)

				--- if you have a request you dont want to make any changes, just cancel it
				vim.keymap.set("v", "<leader>ls", function()
					_99.stop_all_requests()
				end)
			end,
		},
		{
			"esmuellert/codediff.nvim",
			dependencies = { "MunifTanjim/nui.nvim" },
			cmd = "CodeDiff",
		},
		{
			"rachartier/tiny-inline-diagnostic.nvim",
			event = "VeryLazy", -- Or `LspAttach`
			priority = 1000, -- needs to be loaded in first
			config = function()
				require("tiny-inline-diagnostic").setup({
					preset = "minimal",
				})
				vim.diagnostic.config() -- Only if needed in your configuration, if you already have native LSP diagnostics
			end,
		},
		{ -- formating
			"stevearc/conform.nvim",
			opts = {},
			config = function()
				require("conform").setup({
					format_on_save = {
						-- These options will be passed to conform.format()
						timeout_ms = 500,
						lsp_format = "fallback",
					},
					formatters_by_ft = {
						lua = { "stylua" },
						-- Conform will run multiple formatters sequentially
						-- python = { "isort", "black" },
						-- You can customize some of the format options for the filetype (:help conform.format)
						-- rust = { "rustfmt", lsp_format = "fallback" },
						-- Conform will run the first available formatter
						javascript = { "biome-check", "prettierd", "prettier", stop_after_first = true },
						typescript = { "biome-check", "prettierd", "prettier", stop_after_first = true },
						typescriptreact = { "biome-check", "prettierd", "prettier", stop_after_first = true },
						javascriptreact = { "biome-check", "prettierd", "prettier", stop_after_first = true },
					},
				})
			end,
		},
		{
			"brenoprata10/nvim-highlight-colors",
			config = function()
				require("nvim-highlight-colors").setup({})
			end,
		},
		{
			"folke/todo-comments.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = {
				colors = { comment = { "Comment", "#000000" } },
				highlight = { multiline = false, pattern = [[.*<(KEYWORDS)\s*: angrypie]] },
			},
		},
		{
			"karb94/neoscroll.nvim",
			config = function()
				require("neoscroll").setup({
					-- Keys to be mapped to their corresponding default scrolling animation
					mappings = { "<C-u>", "<C-d>" },
				})
			end,
		},
		{
			"Wansmer/treesj",
			keys = { "<leader>m" },
			dependencies = { "nvim-treesitter/nvim-treesitter" },
			config = function()
				require("treesj").setup({})
			end,
		},
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		-- { dir = "/Users/el/Code/github.com/angrypie/moonwalk.nvim" },
		{
			"stevearc/oil.nvim", -- Edit directory as a regular buffer
			config = function()
				require("oil").setup()
			end,
		},
		{
			"jake-stewart/multicursor.nvim",
			branch = "1.0",
			config = function()
				local mc = require("multicursor-nvim")
				mc.setup()
				local set = vim.keymap.set

				set({ "n", "v" }, "<C-n>", function()
					mc.matchAddCursor(1)
				end)
				set({ "n", "v" }, "<leader>A", mc.matchAllAddCursors)
				set({ "n", "v" }, "<leader>x", mc.deleteCursor)

				set("n", "<C-c>", function()
					if not mc.cursorsEnabled() then
						mc.enableCursors()
					elseif mc.hasCursors() then
						mc.clearCursors()
					else
						-- Default <esc> handler.
					end
				end)
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					incremental_selection = {
						enable = true,
						keymaps = {
							init_selection = false,
							node_incremental = "k",
							scope_incremental = "<tab>",
							node_decremental = "m",
						},
					},
					ensure_installed = {
						"go",
						"typescript",
						"tsx",
						"javascript",
						"lua",
						"vim",
						"zig",
						"c",
						"rust",
					},
					sync_install = false,
					auto_install = false,
					ignore_install = {},
					modules = {},
					highlight = {
						enable = true,
					},
				})
			end,
		},

		{
			"catppuccin/nvim",
			name = "catppuccin",
			config = function()
				vim.g.catppuccin_flavour = "mocha"
				require("catppuccin").setup()
				vim.cmd([[colorscheme catppuccin]])
			end,
		},

		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("lualine").setup({
					options = {
						theme = "auto",
					},
				})
			end,
		},

		{ "windwp/nvim-autopairs", config = true },

		{
			"numToStr/Comment.nvim", -- commenting plugin
			opts = {
				toggler = { line = "/" },
				opleader = { line = "/" },
			},
		},

		{
			"phaazon/hop.nvim", -- Easy-motion like file navigation
			config = function()
				require("hop").setup()
				map("n", ";", "<cmd>HopChar2<cr>")    -- experimental
				vim.cmd([[hi HopNextKey2 guifg=#00dfff]]) -- Second character same color as first one
			end,
		},

		{
			"supermaven-inc/supermaven-nvim",
			config = function()
				require("supermaven-nvim").setup({})
			end,
		},

		{
			"ibhagwan/fzf-lua", -- Fuzzy search by directories and files
			config = function()
				local fzf = require("fzf-lua")
				require("fzf-lua").register_ui_select()
				fzf.setup({ fzf_opts = { ["--layout"] = "default" } })
				-- search in config dirs
				vim.keymap.set("n", "<leader>fc", function()
					fzf.files({ cwd = "~/.config" })
				end, { desc = "Search files in config directory" })

				vim.keymap.set("n", "<leader>fcg", function()
					fzf.grep({ cwd = "~/.config", search = "" })
				end, { desc = "Grep files in config directory" })

				vim.keymap.set("n", "<leader>fv", function()
					fzf.grep({ cwd = "~/.config/nvim", search = "" })
				end, { desc = "Search files in config directory" })

				vim.keymap.set("n", "<c-p>", function()
					fzf.files({ winopts = { preview = { hidden = true } } })
				end, { desc = "Search for all files" })

				vim.keymap.set("n", "<c-F>", function()
					fzf.grep_project()
				end, { desc = "Grep in project files" })

				vim.keymap.set("n", "<leader>ht", function()
					fzf.help_tags()
				end, { silent = true, desc = "Search for help tags" })

				vim.keymap.set("n", "<leader>km", function()
					fzf.keymaps()
				end, { silent = true, desc = "Search for keymaps" })

				vim.keymap.set("n", "<leader>st", function()
					require("fzf-lua").grep({
						search = "TODO|FIXME|HACK|NOTE|PERF|WARN",
						prompt = "TODOS >",
						no_esc = true, -- Don't escape the pattern
					})
				end, { silent = true, desc = "Search for keymaps" })
			end,
		},
		{ -- optional cmp completion source for require statements and module annotations
			"hrsh7th/nvim-cmp",
			opts = function(_, opts)
				opts.sources = opts.sources or {}
				table.insert(opts.sources, {
					name = "lazydev",
					group_index = 0, -- set group index to 0 to skip loading LuaLS completions
				})
			end,
			dependencies = {
				{ "hrsh7th/cmp-path" },
				{ "hrsh7th/cmp-buffer" },
				{ "hrsh7th/nvim-cmp" },
				{ "hrsh7th/cmp-nvim-lsp" },
				{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			},
		},
		{ "neovim/nvim-lspconfig" },
		{
			"mason-org/mason.nvim",
			opts = {},
		},
		{ "williamboman/mason-lspconfig.nvim" },
	},
	-- lazy.nvim opts
	vim.tbl_deep_extend("force", require("lazy.core.config").defaults, {
		dev = {
			path = "~/Code/github.com", -- load plugins with { dev: true } from this path
		},
	})
)

vim.api.nvim_create_autocmd("LspAttach", {
	desc = "LSP actions",
	callback = function(event)
		local opts = { buffer = event.buf, silent = true }
		-- these will be buffer-local keybindings
		-- because they only work if you have an active language server
		local fzf = require("fzf-lua")
		map("n", "gd", vim.lsp.buf.definition, opts)
		map("n", "gD", vim.lsp.buf.declaration, opts)
		map("n", "gs", fzf.lsp_workspace_symbols, opts)
		map("n", "gS", fzf.lsp_document_symbols, opts)
		map("n", "gr", fzf.lsp_references, opts)
		map("n", "<leader>ca", fzf.lsp_code_actions, opts)
		map("n", "T", vim.lsp.buf.hover, opts)
		map("n", "N", vim.lsp.buf.signature_help, opts)
		map("n", "<leader>rn", vim.lsp.buf.rename, opts)
	end,
})

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason-lspconfig").setup({
	automatic_enable = true,
	ensure_installed = {
		"ts_ls",
		"gopls",
		"lua_ls",
		"zls",
		"biome",
		"eslint",
		"rust_analyzer",
	},
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({
				capabilities = lsp_capabilities,
			})
		end,
	},
	lua_ls = function()
		require("lspconfig").lua_ls.setup({
			capabilities = lsp_capabilities,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							vim.env.VIMRUNTIME,
						},
					},
				},
			},
		})
	end,
})

local cmp = require("cmp")
cmp.setup({
	sources = {
		{ name = "lazydev" },
		{ name = "nvim_lsp" },
		{ name = "path",                   keyword_length = 2 },
		{ name = "buffer",                 keyword_length = 3 },
		{ name = "nvim_lsp_signature_help" },
	},
	mapping = {
		["<C-f>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item.
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
	},
})

-- Options
local opt = vim.opt
-- UI
opt.termguicolors = true  -- Enable 24-bit RGB colors
opt.number = true         -- Show line number
opt.relativenumber = true -- Show relative line number
opt.showmode = false      -- Hide mode name
opt.splitright = true     -- Vertical split to the right
opt.splitbelow = true     -- Horizontal split to the bottom
opt.ignorecase = true     -- Ignore case letters when search
opt.smartcase = true      -- Ignore lowercase for the whole pattern
opt.scrolloff = 8         -- Set scroll offset
opt.confirm = true        -- Confirm before exiting
opt.signcolumn = "number" -- Show signs in the number column
opt.hlsearch = false      -- Disable search highlight
-- Tabs, indent
opt.shiftwidth = 2        -- Shift 4 spaces when tab
opt.tabstop = 2           -- 1 tab == 4 spaces
opt.softtabstop = 2       -- display 1 tab as 2 spaces
-- opt.smartindent = true    -- Auto indent new lines
-- Performance
opt.updatetime = 700

opt.shortmess:append("sI") -- Disable nvim intro

map("i", "eu", "<ESC>")    -- escape from insert mode

-- Move between panes TODO use tmux like mappings M-h for left etc?
map("n", "<C-w>n", "<C-w>k")
map("n", "<C-w>s", "<C-w>l")
map("n", "<C-w>t", "<C-w>j")
-- Move splits
map("n", "<C-w>N", "<C-w>K")
map("n", "<C-w>S", "<C-w>L")
map("n", "<C-w>T", "<C-w>J")

-- Mappings
-- bulk_map sets keymap for multiple rules and repeats for multiple modes
local function bulk_map(modes, rules)
	for _, mode in pairs(modes) do
		for _, rule in pairs(rules) do
			map(mode, rule[1], rule[2])
		end
	end
end
-- My Dvorak remap (attention: not all keys remapped exactly right, it's just my preferences)
-- stylua: ignore start
bulk_map({ "n", "v", "o" },
	{ { ",", "w" }, { "'", "q" }, { ".", "e" }, { "p", "r" }, { "y", "t" }, { "f", "y" }, { "g", "u" }, { "c", "i" }, { "r", "o" }, { "l", "p" }, { "=", "]" }, { "a", "a" }, { "o", "s" }, { "e", "d" }, { "u", "f" }, { "i", "g" }, { "h", "h" }, { "t", "j" }, { "n", "k" }, { "s", "l" }, { "-", "'" }, { "q", "x" }, { "j", "c" }, { "k", "v" }, { "x", "b" }, { "b", "n" }, { "m", "m" }, { "w", "," }, { "v", "." }, { "z", "/" }, { '"', "Q" }, { "<", "W" }, { ">", "E" }, { "P", "R" }, { "Y", "T" }, { "F", "Y" }, { "G", "U" }, { "C", "I" }, { "R", "O" }, { "L", "P" }, { "?", "{" }, { "+", "}" }, { "A", "A" }, { "O", "S" }, { "E", "D" }, { "U", "F" }, { "I", "G" }, { "D", "H" }, { "H", "J" }, { "T", "K" }, { "N", "L" }, { "_", '"' }, { "Q", "X" }, { "J", "C" }, { "K", "V" }, { "X", "B" }, { "B", "N" }, { "W", "<" }, { "V", ">" }, { "[", "-" }, { "]", "=" }, { "{", "_" }, { "}", "+" }, { "ii", "gg" }, })
-- stylua: ignore end

map("n", "F", [["+yy]]) -- In normal mode copy current line
map("v", "F", [["+y]])  -- In visual mode copy selected lines


local function get_current_diagnostics()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	local diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })
	for _, diag in ipairs(diagnostics) do
		-- Check if cursor is within the diagnostic range
		if col >= diag.col and col <= (diag.end_col or diag.col) then
			print("Diagnostic: " .. diag.message)
		end
	end
end


local function comment_and_insert_diagnostic()
	local bufnr = 0
	local row = vim.api.nvim_win_get_cursor(0)[1]
	local lnum = row - 1 -- 0-indexed

	local diagnostics = vim.diagnostic.get(bufnr, { lnum = lnum })

	if #diagnostics == 0 then
		vim.notify("No diagnostics on current line", vim.log.levels.WARN)
		return
	end

	local cs = vim.bo.commentstring
	if cs == "" or not cs:find("%%s") then
		cs = "// %s"
	end

	-- Comment current line
	local current_line = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1]
	local commented_line = cs:format(current_line)
	vim.api.nvim_buf_set_lines(bufnr, lnum, lnum + 1, false, { commented_line })

	-- Build lines to insert
	local lines_to_insert = {}
	for _, d in ipairs(diagnostics) do
		local severity = vim.diagnostic.severity[d.severity] or "UNKNOWN"
		-- Split message on newlines to handle multi-line diagnostics
		local msg_lines = vim.split(d.message, "\n", { plain = true, trimempty = true })
		for i, msg_line in ipairs(msg_lines) do
			local prefix = i == 1 and string.format("[%s] ", severity) or "  "
			local diag_comment = cs:format(prefix .. msg_line)
			table.insert(lines_to_insert, diag_comment)
		end
	end
	table.insert(lines_to_insert, "") -- Empty line for typing

	vim.api.nvim_buf_set_lines(bufnr, row, row, false, lines_to_insert)

	local new_line = row + #lines_to_insert
	vim.api.nvim_win_set_cursor(0, { new_line, 0 })
	vim.cmd("startinsert")
end

vim.keymap.set('n', '<c-s>', comment_and_insert_diagnostic, { desc = "Comment line, insert diagnostic, start fix" })
