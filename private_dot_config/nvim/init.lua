-- TODO
-- Why undo laging?
-- Use tmux-like maping M-h for left etc
--

vim.g.mapleader = ';'       -- Change leader to a semicolon before plugins setup

function map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
-- Bootstrap  packer.nvim (auto-download)
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
	use 'arcticicestudio/nord-vim'		-- Original nord now supports treesitter
	use 'hoob3rt/lualine.nvim'				-- Fast statusline plugin
	use 'windwp/nvim-autopairs'				-- autopairs lua plugin
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use 'b3nj5m1n/kommentary'					-- Commenting plugin		
	use 'phaazon/hop.nvim'						-- Easy-motion like file navigation
	use 'ibhagwan/fzf-lua'						-- Fuzzy search by directories and files

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)

require('lualine').setup()
require("nvim-autopairs").setup()

require('nvim-treesitter.configs').setup {
	ensure_installed = {'go', 'typescript', 'javascript', 'lua', 'vim'}, 
  highlight = {
    enable = true,
  },
}

require('kommentary.config').configure_language("default", {
	prefer_single_line_comments = true,
})
-- map("n", "/", "<Plug>kommentary_line_default", {})

require'hop'.setup()
map('', '<leader>s', '<cmd>HopWord<cr>')

require('fzf-lua').setup{fzf_opts = { ['--layout'] = "default" }}
map('n', '<c-P>', "<cmd>lua require('fzf-lua').files({winopts = { preview = { hidden = 'hidden' }}})<CR>", { silent = true })
map('n', '<c-F>', "<cmd>lua require('fzf-lua').grep_project()<CR>", { silent = true })



-- bulk_map sets keymaps for multiple rules and repeats for multiple modes
function bulk_map(modes, rules)
	for _, mode in pairs(modes) do 
		for _, rule in pairs(rules) do
			map(mode,rule[1], rule[2])
		end
	end
end



vim.cmd [[colorscheme nord]] -- Set the nord colorscheme

local opt = vim.opt
-- UI
opt.termguicolors = true    -- Enable 24-bit RGB colors
opt.number = true           -- Show line number
opt.showmode = false        -- Hide mode name
opt.splitright = true       -- Vertical split to the right
opt.splitbelow = true       -- Horizontal split to the bottom
opt.ignorecase = true       -- Ignore case letters when search
opt.smartcase = true        -- Ignore lowercase for the whole pattern
opt.scrolloff = 8 					-- Set scroll offset
opt.confirm = true 				  -- Confirm before exiting
opt.signcolumn = 'number'   -- Show signs in the number column
opt.hlsearch = false        -- Disable search highlight
-- Tabs, indent
opt.shiftwidth = 2          -- Shift 4 spaces when tab
opt.tabstop = 2             -- 1 tab == 4 spaces
opt.softtabstop = 2         -- display 1 tab as 2 spaces
opt.smartindent = true      -- Autoindent new lines
-- Perfomance
opt.synmaxcol = 300         -- Maximum column numbers for syntax to highlight
opt.updatetime = 700

opt.shortmess:append "sI" -- Disable nvim intro

map('i', 'eu', '<ESC>') -- escape from insert mode

--move between panes TODO use tmux-like maping M-h for left etc?
map('n', '<C-w>j', '<C-w>t')
map('n', '<C-w>n', '<C-w>k')
map('n', '<C-w>s', '<C-w>l')
map('n', '<C-w>t', '<C-w>j')


-- my dvorak remap (attention: not all keys remaped exactly right, it's just my preferences)
bulk_map({'n', 'v', 'o'}, {{',','w'},{'\'', 'q'},{'.','e'},{'p','r'},{'y','t'},{'f','y'},{'g','u'},{'c','i'},{'r','o'},{'l','p'},{'=',']'},{'a','a'},{'o','s'},{'e','d'},{'u','f'},{'i','g'},{'h','h'},{'t','j'},{'n','k'},{'s','l'},{'-','\''},{'q','x'},{'j','c'},{'k','v'},{'x','b'},{'b','n'},{'m','m'},{'w',','},{'v','.'},{'z','/'},{'"','Q'},{'<','W'},{'>','E'},{'P','R'},{'Y','T'},{'F','Y'},{'G','U'},{'C','I'},{'R','O'},{'L','P'},{'?','{'},{'+','}'},{'A','A'},{'O','S'},{'E','D'},{'U','F'},{'I','G'},{'D','H'}, {'H','J'},{'T','K'},{'N','L'},{'_','"'},{'Q','X'},{'J','C'},{'K','V'},{'X','B'},{'B','N'},{'W','<'},{'V','>'},{'[','-'},{']','='},{'{','_'},{'}','+'},{'ii', 'gg'}})
