vim.g.mapleader = ';' -- Change leader to a semicolon before plugins setup

local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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
require('lazy').setup({
	---@module 'snacks'
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			lazygit = { enabled = true, },
			picker = {
				enabled = true,
				sources = {
					files = { hidden = true },
				},
				layout = {
					preset = "telescope",
					preview = false,
				}
			}
		},
		keys = {
			{ "<c-y>",      function() Snacks.picker.files() end, desc = "Find Files" },
			{ "<leader>lg", function() Snacks.lazygit() end,      desc = "LazyGit" },
		}
	},
	{
		"dlants/magenta.nvim",
		lazy = true, -- you could also bind to <leader>mt
		build = "npm install --frozen-lockfile",
		keys = {
			{ "<leader>mt", "<cmd>Magenta toggle<cr>", desc = "Magenta" },
		},
		opts = {},
	},
	{
		"karb94/neoscroll.nvim",
		config = function()
			require('neoscroll').setup({
				-- Keys to be mapped to their corresponding default scrolling animation
				mappings = { '<C-u>', '<C-d>', }
			})
		end
	},
	{
		'Wansmer/treesj',
		keys = { '<leader><space>m', '<leader><space>j', '<leader><space>s' },
		dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
		config = function()
			require('treesj').setup({})
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
		'stevearc/oil.nvim', -- Edit directory as a regular buffer
		config = function()
			require('oil').setup()
		end,
	},
	{
		"jake-stewart/multicursor.nvim",
		branch = "1.0",
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()
			local set = vim.keymap.set

			set({ "n", "v" }, "<C-n>", function() mc.matchAddCursor(1) end)
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
		end
	},
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup({
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
					'go', 'typescript', 'tsx', 'javascript', 'lua', 'vim', 'zig', "c", 'rust',
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
		'catppuccin/nvim',
		name = 'catppuccin',
		config = function()
			vim.g.catppuccin_flavour = "mocha"
			local mocha = require("catppuccin.palettes").get_palette "mocha"
			require("catppuccin").setup {
				highlight_overrides = { mocha = { LineNr = { fg = mocha.overlay0 } } }
			} -- make relative number more visible
			vim.cmd [[colorscheme catppuccin]]
		end,
	},

	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require('lualine').setup {
				options = {
					theme = 'auto',
				},
			}
		end,
	},

	{ 'windwp/nvim-autopairs', config = true },

	{
		'numToStr/Comment.nvim', -- commenting plugin
		opts = {
			toggler = { line = '/', },
			opleader = { line = '/', },
		}
	},

	{
		'phaazon/hop.nvim', -- Easy-motion like file navigation
		config = function()
			require 'hop'.setup()
			map('n', '<space>', '<cmd>HopChar2<cr>') -- experimental, on downside <space> can't be <leader> now
			vim.cmd [[hi HopNextKey2 guifg=#00dfff]] -- Second character same color as first one
		end,
	},

	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({})
		end,
	},

	{
		'ibhagwan/fzf-lua', -- Fuzzy search by directories and files
		config = function()
			require('fzf-lua').setup { fzf_opts = { ['--layout'] = "default" } }
			require("fzf-lua").register_ui_select()
			map('n', '<c-P>',
				"<cmd>lua require('fzf-lua').files({winopts = { preview = { hidden = 'hidden' }}})<CR>",
				{ silent = true })
			map('n', '<c-F>', "<cmd>lua require('fzf-lua').grep_project()<CR>", { silent = true })
			map('n', ';ht', "<cmd>lua require('fzf-lua').help_tags()<CR>", { silent = true })
			map('n', ';km', "<cmd>lua require('fzf-lua').keymaps()<CR>", { silent = true })
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
	},
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v2.x',
		dependencies = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' }, -- Required
			{
				-- Optional
				'williamboman/mason.nvim',
				build = ":MasonUpdate",
			},
			{ 'williamboman/mason-lspconfig.nvim' }, -- Optional
			{ 'L3MON4D3/LuaSnip' },               -- Required
			{ 'hrsh7th/cmp-path' },               -- Required
			{ 'hrsh7th/cmp-buffer' },             -- Required
			{ 'hrsh7th/nvim-cmp' },               -- Required
			{ 'hrsh7th/cmp-nvim-lsp' },           -- Required
			{ 'hrsh7th/cmp-nvim-lsp-signature-help' },

		}
	}
})


-- lsp-zero settings
local lsp = require('lsp-zero').preset({})
lsp.on_attach(function(_, bufnr)
	lsp.default_keymaps({
		buffer = bufnr,
		preserve_mappings = false,
		omit = { 'K', '<Tab>' },
	})



	local fzf = require('fzf-lua')

	map('n', 'gs', fzf.lsp_workspace_symbols, { buffer = bufnr })
	map('n', 'gS', fzf.lsp_document_symbols, { buffer = bufnr })
	map('n', 'gr', fzf.lsp_references, { buffer = bufnr })
	map('n', '<leader>ca', fzf.lsp_code_actions, { buffer = bufnr })
	vim.keymap.set('n', 'T', vim.lsp.buf.hover, { buffer = bufnr })
	vim.keymap.set('n', 'N', vim.lsp.buf.signature_help, { buffer = bufnr })
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr })

	-- From https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-1130373799
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = { "*.go" },
		callback = function()
			local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding(bufnr))
			params.context = { only = { "source.organizeImports" } }

			local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
			for _, res in pairs(result or {}) do
				for _, r in pairs(res.result or {}) do
					if r.edit then
						vim.lsp.util.apply_workspace_edit(r.edit,
							vim.lsp.util._get_offset_encoding(bufnr))
					else
						vim.lsp.buf.execute_command(r.command)
					end
				end
			end
		end,
	})
end)

lsp.format_on_save({
	format_opts = {
		async = false,
		timeout_ms = 1000,
	},
	servers = {
		['lua_ls'] = { 'lua' },
		['biome'] = { 'javascript', 'typescript', 'typescriptreact', 'javascriptreact', 'json' },
	}
})

lsp.ensure_installed({
	'ts_ls', 'gopls', 'lua_ls', 'zls', 'rust_analyzer', 'biome',
})
-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
require('lspconfig').biome.setup({})

lsp.setup()

local cmp = require('cmp')
cmp.setup({
	sources = {
		{ name = 'lazydev' },
		{ name = 'nvim_lsp' },
		{ name = 'path',                   keyword_length = 2 },
		{ name = 'buffer',                 keyword_length = 3 },
		{ name = 'nvim_lsp_signature_help' },
	},
	mapping = {
		["<C-f>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item.
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
	},
})

-- setup (disable) diagnostic virtual text
vim.diagnostic.config({
	-- virtual_text = false,
	severity_sort = true,
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
opt.signcolumn = 'number' -- Show signs in the number column
opt.hlsearch = false      -- Disable search highlight
-- Tabs, indent
opt.shiftwidth = 2        -- Shift 4 spaces when tab
opt.tabstop = 2           -- 1 tab == 4 spaces
opt.softtabstop = 2       -- display 1 tab as 2 spaces
opt.smartindent = true    -- Auto indent new lines
-- Performance
opt.updatetime = 700

opt.shortmess:append "sI" -- Disable nvim intro

-- Mappings
-- bulk_map sets keymap for multiple rules and repeats for multiple modes
local function bulk_map(modes, rules)
	for _, mode in pairs(modes) do
		for _, rule in pairs(rules) do
			map(mode, rule[1], rule[2])
		end
	end
end

map('i', 'eu', '<ESC>') -- escape from insert mode


-- Move between panes TODO use tmux like mappings M-h for left etc?
map('n', '<C-w>n', '<C-w>k')
map('n', '<C-w>s', '<C-w>l')
map('n', '<C-w>t', '<C-w>j')
-- Move splits
map('n', '<C-w>N', '<C-w>K')
map('n', '<C-w>S', '<C-w>L')
map('n', '<C-w>T', '<C-w>J')


-- My Dvorak remap (attention: not all keys remapped exactly right, it's just my preferences)
bulk_map({ 'n', 'v', 'o' },
	{ { ',', 'w' }, { '\'', 'q' }, { '.', 'e' }, { 'p', 'r' }, { 'y', 't' }, { 'f', 'y' }, { 'g', 'u' },
		{ 'c', 'i' },
		{ 'r', 'o' }, { 'l', 'p' }, { '=', ']' }, { 'a', 'a' }, { 'o', 's' }, { 'e', 'd' }, { 'u', 'f' },
		{ 'i', 'g' },
		{ 'h', 'h' }, { 't', 'j' }, { 'n', 'k' }, { 's', 'l' }, { '-', '\'' }, { 'q', 'x' }, { 'j', 'c' },
		{ 'k', 'v' },
		{ 'x', 'b' }, { 'b', 'n' }, { 'm', 'm' }, { 'w', ',' }, { 'v', '.' }, { 'z', '/' }, { '"', 'Q' },
		{ '<', 'W' },
		{ '>', 'E' }, { 'P', 'R' }, { 'Y', 'T' }, { 'F', 'Y' }, { 'G', 'U' }, { 'C', 'I' }, { 'R', 'O' },
		{ 'L', 'P' },
		{ '?', '{' }, { '+', '}' }, { 'A', 'A' }, { 'O', 'S' }, { 'E', 'D' }, { 'U', 'F' }, { 'I', 'G' },
		{ 'D', 'H' },
		{ 'H', 'J' }, { 'T', 'K' }, { 'N', 'L' }, { '_', '"' }, { 'Q', 'X' }, { 'J', 'C' }, { 'K', 'V' },
		{ 'X', 'B' },
		{ 'B', 'N' }, { 'W', '<' }, { 'V', '>' }, { '[', '-' }, { ']', '=' }, { '{', '_' }, { '}', '+' },
		{ 'ii', 'gg' } })

map('n', 'F', [["+yy]]) -- In normal mode copy current line
map('v', 'F', [["+y]])  -- In visual mode copy selected lines
