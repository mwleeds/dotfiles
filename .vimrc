set nocompatible " don't emulate vi bugs
set tabstop=4
set shiftwidth=4
set expandtab
colorscheme desert
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
so ~/.vim/plugin/detectindent.vim
DetectIndent
set cursorline " underline current line
