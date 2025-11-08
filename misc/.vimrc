"
" Minimal .vimrc
"

" Basic settings
set nocompatible          " Disable compatibility with vi, enabling Vim features
set backspace=indent,eol,start " Make backspace work better
set encoding=utf-8        " Set default encoding to UTF-8

" Interface improvements
set number                " Show line numbers
set relativenumber        " Relative numbers on
set cursorline            " Highlight the current line
set showcmd               " Display incomplete commands
set showmatch             " Highlight matching brackets

" Editing
set autoindent            " Enable auto-indentation
set smartindent           " Enable smart indentation
set expandtab             " Use spaces instead of tabs
set tabstop=4             " Number of spaces for a tab
set shiftwidth=4          " Number of spaces to use for auto-indenting
set softtabstop=4         " Number of spaces per Tab in insert mode
set wrap                  " Enable line wrapping
set noswapfile            " Don't create a swapfile

" Search settings
set hlsearch              " Highlight search results
set incsearch             " Show search matches as you type
set ignorecase            " Case-insensitive search...
set smartcase             " ...unless the search contains uppercase letters

" Visuals
syntax on                 " Enable syntax highlighting
filetype plugin indent on " Enable file type plugins and indent
colorscheme desert

" Mappings
" Clears highlight
nnoremap <C-l> :noh<CR>

" Optional: basic status line
set laststatus=2          " Always show the status line
set ruler                 " Show cursor position at the bottom

