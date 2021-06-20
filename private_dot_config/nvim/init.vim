let path = system('pwd')

:source ~/.config/nvim/settings.vim

"=========================
"=== START PLUGINS SECTION
"=========================
call plug#begin("~/.config/nvim/plugged")

" Pulg is syntax language pack for Vim.
Plug 'sheerun/vim-polyglot'


" Color scheme
Plug 'nanotech/jellybeans.vim'
Plug 'arcticicestudio/nord-vim'

 "Text Editor behavior
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-multiple-cursors'
Plug 'easymotion/vim-easymotion'


" Appearance
" ==========
" A light statusline plugin for Vim
Plug 'itchyny/lightline.vim'
" Distraction-free writing in Vim
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }


" Language support
" ================
"Autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Rescript support
Plug 'rescript-lang/vim-rescript', { 'for': 'rescript' }

"Fuzzy find
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

"==== Tools
"Send text to terminal (tmux etc.)
Plug 'jpalardy/vim-slime', { 'for': 'lisp' }

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


"easymotion
map <Leader> <Plug>(easymotion-prefix)

exe "cd " . path

