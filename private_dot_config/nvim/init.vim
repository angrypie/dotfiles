let path = system('pwd')

:source ~/.config/nvim/settings.vim
"

"=========================
"=== START PLUGINS SECTION
"=========================
call plug#begin("~/.config/nvim/plugged")
" Lua plugins
Plug 'phaazon/hop.nvim' "Easy-motion like file navigation
Plug 'hoob3rt/lualine.nvim' "Fast statusline plugin
Plug 'windwp/nvim-autopairs' "autopairs lua plugin

" Pulg is syntax language pack for Vim.
Plug 'sheerun/vim-polyglot'



" Color scheme
Plug 'arcticicestudio/nord-vim'

 "Text Editor behavior
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-multiple-cursors'


" Appearance
" ==========


" Language support
" ================
"Autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"Fuzzy find
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'


"Snippets
Plug 'mattn/emmet-vim', { 'for': ['html', 'css', 'javascript',  'javascriptreact', 'typescriptreact', 'rescript'] }

"Add plugins to &runtimepath
call plug#end()
"=========================
"=== END PLUGINS SECTION
"=========================


"===========MIGRATED FROM after.vim=======
"this code suposed to go after all configs
"TODO figure out what necessary here
if (has("termguicolors"))
	set termguicolors
endif

colorscheme nord

"===== AUTOCMD ====
"==================
"au BufRead,BufNewFile *.asm set filetype=nasm
"Emmet enable just for .html, .css and .tag
autocmd FileType html,css,tag,javascriptreact,typescriptreact,rescript EmmetInstall

autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

command! -nargs=0 OR :call CocAction('format')
autocmd BufWritePre *.go :OR
autocmd BufWritePre *.re :OR
"
"hop.nvim
map <Leader>s :HopWord<cr>
lua require'hop.highlight'.insert_highlights()

"-- Lua code
"
lua << EOF
require("lualine").setup({ options = { theme = 'nord' } })
require("nvim-autopairs").setup()
EOF


exe "cd " . path

