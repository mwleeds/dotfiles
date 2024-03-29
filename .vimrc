set nocompatible " don't emulate vi bugs
set tabstop=4
set shiftwidth=4
set expandtab
colorscheme desert
hi Comment ctermfg=blue
set number " line numbers
set smartcase
set incsearch " search as characters are typed
set hlsearch " highlight search matches
set encoding=utf-8
nmap \t :set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
nmap \T :set expandtab tabstop=8 shiftwidth=8 softtabstop=4<CR>
nmap \M :set noexpandtab tabstop=8 softtabstop=4 shiftwidth=4<CR>
nmap \m :set expandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>
let fortran_free_source=1
syntax enable
set showcmd
set visualbell
set t_vb=
set mouse=r
set pastetoggle=<F2>
set cursorline " underline current line
set listchars=eol:•,tab:→\ ,trail:␣,extends:↷,precedes:↶,nbsp:⁔
set list
highlight Search ctermfg=black
highlight IncSearch ctermfg=black
filetype plugin indent on
set title
set titleold=""
command Q q
set number " line numbers
set backspace=indent,eol,start " make backspace work under flatpak
set ruler

" Automatically detect indentation
so ~/.vim/plugin/detectindent.vim
DetectIndent

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

command! -nargs=+ Foldsearch exe "normal /".<q-args>."" | setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\|\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2

" Automatically disable autoindent when pasting text (otherwise extra tabs are
" inserted)
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction
