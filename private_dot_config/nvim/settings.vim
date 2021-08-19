let mapleader=";"
"split window
set splitbelow
set splitright

filetype plugin on

"interface setings
set number
syntax on
set scrolloff=4 "show lines, top and bottom, while skroling
set confirm "using dialog for warning
set noshowmode


set visualbell


"search
"set hlsearch "highlight searh
set incsearch
set ignorecase
"
"tab setings
set tabstop=2
set softtabstop=2
set shiftwidth=2
set noexpandtab

"indent settings
set showcmd 
set smartindent
set autoindent

" search settins
set nohlsearch
set incsearch


"Emmet-vim
let g:user_emmet_install_global = 0
"	remap the default <C-Y> leader
let g:user_emmet_leader_key='Z'



"jsx
let g:jsx_ext_required = 0

"fzf fuzzy search
map <C-p> :FZF<CR>
let $FZF_DEFAULT_COMMAND = 'rg --files'

"coc.nvim settings
"=================
" Remap keys for gotos
let g:coc_global_extensions = ['coc-tslint-plugin', 'coc-tsserver', 'coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-yank', 'coc-prettier', 'coc-snippets', 'coc-go']
"
"
inoremap <silent><expr> <C-f> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
nmap <leader>rn <Plug>(coc-rename)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <leader>ac  <Plug>(coc-codeaction)
"Always show sign column
set signcolumn=number
"Highlight errors background
hi CocUnderline ctermbg=DarkGrey

" coc-prettier
vmap <leader>p  <Plug>(coc-format-selected)
nmap <leader>p  :CocCommand prettier.formatFile<CR>

" Use K to show documentation in preview window.
nnoremap <silent> H :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction


let g:multi_cursor_exit_from_insert_mode = 0
let g:multi_cursor_quit_key='<C-c>'
nnoremap <C-c> :call multiple_cursors#quit()<CR>




"This will close vim if the quickfix window is the only window visible (and only tab).
aug QFClose
		au!
	au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
aug END

"========= mooved from mapings.vim
"dvorak mapings
no , w
no . e
no p r
no y t
no f y
no g u
no c i
no r o
no l p
no / [
no = ]
no a a
no o s
no e d
no u f
no i g
no h h
no t j
no n k
no s l
"no s ;
no - '
no ; z
no q x
no j c
no k v
no x b
no b n
no m m
no w ,
no v .
no z /
no " Q
no < W
no > E
no P R
no Y T
no F Y
no G U
no C I
no R O
no L P
no ? {
no + }
no A A
no O S
no E D
no U F
no I G
no D H
"no H J
no T K
no N L
"no S :
no _ "
"no : Z
no Q X
no J C
no K V
no X B
no B N
no W <
no V >
"no Z ?
no [ -
no ] =
no { _
no } +


"coc maping to complete suggestions
ino <C-e> <C-d>
ino <C-y> <C-t>
noremap <C-b> n
noremap <C-S-b> N

"move between panes
no <C-w>j <C-w>t
no <C-w>n <C-w>k
no <C-w>s <C-w>l
no <C-w>t <C-w>j


"eu is super weapon :)
ino eu <ESC>
