syntax on

nnoremap <silent> <F6> :set number!<CR>

" General settings
set cursorline
set showmatch
set tabstop=4
set shiftwidth=4
set ruler 
set hlsearch
set ignorecase
set noerrorbells
set novisualbell
set expandtab
set incsearch
set textwidth=80
set formatoptions=cq

autocmd FileType make setlocal noexpandtab
autocmd FileType python set tabstop=4|set shiftwidth=4|set expandtab
autocmd FileType cuda set tabstop=4|set shiftwidth=4|set expandtab
autocmd FileType fortran set tabstop=3|set shiftwidth=3|set expandtab
autocmd FileType c set tabstop=4|set shiftwidth=4|set expandtab
au BufEnter *.h setf c
au BufEnter *.f setf c

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

cnoreabbrev Wq wq
cnoreabbrev WQ wq
cnoreabbrev wQ wq
cnoreabbrev W w
cnoreabbrev Q q

execute pathogen#infect()
filetype plugin on
let mapleader = "," 

colorscheme gruvbox
set background=dark " Setting dark mode

" To make the persistent undo
set undofile

" Avoiding the creating of un file all over places. 
set undodir=~/.vim/undodir

" Inclusive search
"/Map /  <Plug>(incsearch-forward)
"map ?  <Plug>(incsearch-backward)
"map g/ <Plug>(incsearch-stay)

"Taglist
"let Tlist_Use_Right_Window=1
let Tlist_Auto_Open=0
let Tlist_Enable_Fold_Column=0
let Tlist_Compact_Format=0
let Tlist_WinWidth=28
let Tlist_Exit_OnlyWindow=1
let Tlist_File_Fold_Auto_Close = 1
map <Leader>tt :Tlist<CR>

" For nerdtree.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeIgnore=['\~$', '^\.git', '\.swp$', '\.DS_Store$', '\.pyc$']
"let NERDTreeShowHidden=1
map <Leader>nn <plug>NERDTreeTabsToggle<CR>

" For pydiction
let g:pydiction_location='/Users/SMasuti/.vim/bundle/pydiction/complete-dict'
let g:pydiction_menu_height=3

" Matrix shortcut.
map <Leader>mm :Matrix<CR>

" vim-latex 
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'

" Ignore compiled files 
set wildignore=*.pyc

" MRU shortcut 
map <Leader>rr :MRU<CR>

" To draw line at column 80 
let &colorcolumn=join(range(81,999),",")
let &colorcolumn="80,".join(range(400,999),",")

" CtrlP options
let g:ctrlp_match_window='bottom,order:ttb'
let g:ctrlp_switch_buffer=0
let g:ctrlp_working_path_mode=0

" Python syntax highlighting
let python_highlight_all = 1

" Disable atp
let g:no_atp=1

" Source Explorer
" // Set the height of Source Explorer window 
let g:SrcExpl_winHeight = 20 
map <Leader>ss :SrcExpl<CR>
map <Leader>sc :SrcExplClose<CR>
let g:SrcExpl_searchLocalDef = 1

" Launching trinity
map <Leader>ww :TrinityToggleAll<CR>

"let g:solarized_termtrans=1
"let g:solarized_termcolors=256
"let g:solarized_contrast="high"
"let g:solarized_visibility="high"
"colorscheme solarized
