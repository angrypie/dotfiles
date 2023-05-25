vim.g.mapleader = ';' -- Change leader to a semicolon before plugins setup
local function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Bootstrap lazy.nvim
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

-- Start plugins setup
require('lazy').setup({
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = function()
			require('nvim-treesitter.configs').setup {
				ensure_installed = { 'go', 'typescript', 'javascript', 'lua', 'vim' },
				highlight = {
					enable = true,
				},
			}
		end,
	},

	{
		'catppuccin/nvim',
		name = 'catppuccin',
		config = function()
			vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
			local mocha = require("catppuccin.palettes").get_palette "mocha"
			require("catppuccin").setup {
				highlight_overrides = { mocha = { LineNr = { fg = mocha.overlay0 } } }
			} -- make relative number more visible
			vim.cmd [[colorscheme catppuccin]]
		end,
	},

	{
		'hoob3rt/lualine.nvim', -- Fast statusline plugin
		config = function()
			require("lualine").setup({ options = { theme = 'catppuccin' } })
		end,
	},

	{ 'windwp/nvim-autopairs', config = true }, -- autopairs lua plugin

	{
		'b3nj5m1n/kommentary', -- Commenting plugin
		config = function()
			require('kommentary.config').configure_language("default", {
				prefer_single_line_comments = true,
			})
			map("n", "/", "<Plug>kommentary_line_default", {})
			map("v", "/", "<Plug>kommentary_visual_default<C-c>", {})
		end,
	},

	{
		'phaazon/hop.nvim', -- Easy-motion like file navigation
		config = function()
			require 'hop'.setup()
			map('n', '<leader>s', '<cmd>HopWord<cr>') -- hop to start of the all words
			map('n', '<space>', '<cmd>HopChar2<cr>') -- experimental, on downside <space> can't be <leader> now
			vim.cmd [[hi HopNextKey2 guifg=#00dfff]] -- second character same color as first one
		end,
	},

	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	cmd = "Copilot",
	-- 	event = "InsertEnter",
	-- 	config = function()
	-- 		require('copilot').setup({
	-- 			suggestion = {
	-- 				auto_trigger = true,
	-- 				keymap = { accept = "<Tab>" },
	-- 			},
	-- 		})
	-- 	end,
	-- },

	{
		'ibhagwan/fzf-lua', -- Fuzzy search by directories and files
		config = function()
			require('fzf-lua').setup { fzf_opts = { ['--layout'] = "default" } }
			map('n', '<c-P>', "<cmd>lua require('fzf-lua').files({winopts = { preview = { hidden = 'hidden' }}})<CR>",
				{ silent = true })
			map('n', '<c-F>', "<cmd>lua require('fzf-lua').grep_project()<CR>", { silent = true })
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
				build = function()
					pcall(vim.cmd, 'MasonUpdate')
				end,
			},
			{ 'williamboman/mason-lspconfig.nvim' }, -- Optional

			-- Autocompletion
			{ 'hrsh7th/cmp-path' },  -- Required
			{ 'hrsh7th/cmp-buffer' }, -- Required
			{ 'hrsh7th/nvim-cmp' },  -- Required
			{ 'hrsh7th/cmp-nvim-lsp' }, -- Required
			{ 'L3MON4D3/LuaSnip' },  -- Required
		}
	}
})


local lsp = require('lsp-zero').preset({
	manage_nvim_cmp = {
		set_sources = 'recommended'
	}
})
lsp.on_attach(function(_, bufnr)
	lsp.default_keymaps({
		buffer = bufnr,
		preserve_mappings = false,
		omit = { 'K' },
	})
	lsp.buffer_autoformat()

	vim.keymap.set('n', 'T', vim.lsp.buf.hover, { buffer = bufnr })
	vim.keymap.set('n', 'N', vim.lsp.buf.signature_help, { buffer = bufnr })
end)

lsp.ensure_installed({ 'tsserver', 'gopls', 'lua_ls' })
-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

local cmp = require('cmp')
cmp.setup({
	mapping = {
		["<C-f>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item.
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
	},
	preselect = 'item',
	completion = {
		completeopt = 'menu,menuone,noinsert'
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
opt.scrolloff = 8         -- Set pcroll offset
opt.confirm = true        -- Confirm before exiting
opt.signcolumn = 'number' -- Show signs in the number column
opt.hlsearch = false      -- Disable search highlight
-- Tabs, indent
opt.shiftwidth = 2        -- Shift 4 spaces when tab
opt.tabstop = 2           -- 1 tab == 4 spaces
opt.softtabstop = 2       -- display 1 tab as 2 spaces
opt.smartindent = true    -- Autoindent new lines
-- Perfomance
opt.synmaxcol = 300       -- Maximum column numbers for syntax to highlight
opt.updatetime = 700

opt.shortmess:append "sI" -- Disable nvim intro

-- Mappings
-- bulk_map sets keymaps for multiple rules and repeats for multiple modes
local function bulk_map(modes, rules)
	for _, mode in pairs(modes) do
		for _, rule in pairs(rules) do
			map(mode, rule[1], rule[2])
		end
	end
end

map('i', 'eu', '<ESC>') -- escape from insert mode

--move between panes TODO use tmux-like maping M-h for left etc?
map('n', '<C-w>n', '<C-w>k')
map('n', '<C-w>s', '<C-w>l')
map('n', '<C-w>t', '<C-w>j')
-- move splits
map('n', '<C-w>N', '<C-w>K')
map('n', '<C-w>S', '<C-w>L')
map('n', '<C-w>T', '<C-w>J')


-- my dvorak remap (attention: not all keys remaped exactly right, it's just my preferences)
bulk_map({ 'n', 'v', 'o' },
	{ { ',', 'w' }, { '\'', 'q' }, { '.', 'e' }, { 'p', 'r' }, { 'y', 't' }, { 'f', 'y' }, { 'g', 'u' }, { 'c', 'i' },
		{ 'r', 'o' }, { 'l', 'p' }, { '=', ']' }, { 'a', 'a' }, { 'o', 's' }, { 'e', 'd' }, { 'u', 'f' }, { 'i', 'g' },
		{ 'h', 'h' }, { 't', 'j' }, { 'n', 'k' }, { 's', 'l' }, { '-', '\'' }, { 'q', 'x' }, { 'j', 'c' }, { 'k', 'v' },
		{ 'x', 'b' }, { 'b', 'n' }, { 'm', 'm' }, { 'w', ',' }, { 'v', '.' }, { 'z', '/' }, { '"', 'Q' }, { '<', 'W' },
		{ '>', 'E' }, { 'P', 'R' }, { 'Y', 'T' }, { 'F', 'Y' }, { 'G', 'U' }, { 'C', 'I' }, { 'R', 'O' }, { 'L', 'P' },
		{ '?', '{' }, { '+', '}' }, { 'A', 'A' }, { 'O', 'S' }, { 'E', 'D' }, { 'U', 'F' }, { 'I', 'G' }, { 'D', 'H' },
		{ 'H', 'J' }, { 'T', 'K' }, { 'N', 'L' }, { '_', '"' }, { 'Q', 'X' }, { 'J', 'C' }, { 'K', 'V' }, { 'X', 'B' },
		{ 'B', 'N' }, { 'W', '<' }, { 'V', '>' }, { '[', '-' }, { ']', '=' }, { '{', '_' }, { '}', '+' }, { 'ii', 'gg' } })
