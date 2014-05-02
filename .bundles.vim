" Vundle setup {{{
set nocompatible
filetype off

set rtp+=!/.vim/bundle/vundle
call vundle#rc()

" let Vundle manage Vundle {{{2
Bundle 'gmarik/vundle'
" }}}2

filetype plugin indent on

" let Vundle manage pathogen {{{2
" For a brand new vim installation download vim-pathogen to bundle directory
" and create a link to $HOME/.vim/bundle/vim-pathogen/autoload in $HOME/.vim
Bundle 'tpope/vim-pathogen'
" }}}2

" General enhancements {{{2
Bundle 'vim-scripts/AutoComplPop'
Bundle 'vim-scripts/DrawIt'
Bundle 'vim-scripts/EasyGrep'
Bundle 'vim-scripts/FuzzyFinder'
Bundle 'vim-scripts/VisIncr'
Bundle 'vim-scripts/ZoomWin'
Bundle 'vim-scripts/highlight.vim'
Bundle 'vim-scripts/mru.vim'
Bundle 'vim-scripts/vcscommand.vim'
Bundle 'vim-scripts/L9'
Bundle 'vim-scripts/txt.vim'
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-eunuch'
Bundle 'jlanzarotta/bufexplorer'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'ervandew/supertab'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'nelstrom/vim-visual-star-search'
Bundle 'godlygeek/tabular'
Bundle 'Raimondi/delimitMate'
Bundle 'maxbrunsfeld/vim-yankstack'
Bundle 'rking/ag.vim'
Bundle 'jimsei/winresizer'
Bundle 'majutsushi/tagbar'
Bundle 'brookhong/cscope.vim'
Bundle 'mhinz/vim-signify'
" }}}2

" Using the updated version of bufkill plugin {{{2
" since the original vim-script repository is not yet
" updated, get the fork it and updated it
Bundle 'amilaperera/bufkill.vim'
" }}}2

" General development related {{{2
Bundle 'vim-scripts/DoxygenToolkit.vim'
" }}}2

" Vim tmux integration {{{2
Bundle 'tpope/vim-tbone'
" }}}2

" Vim custom text objects {{{2
Bundle 'kana/vim-textobj-user'
Bundle 'kana/vim-textobj-entire'
Bundle 'kana/vim-textobj-indent'
Bundle 'kana/vim-textobj-syntax'
Bundle 'kana/vim-textobj-line'
Bundle 'nelstrom/vim-textobj-rubyblock'
" }}}2

" HTML editing {{{2
Bundle 'mattn/emmet-vim'
Bundle 'othree/html5.vim'
" }}}2

" C/C++ enhancements {{{2
Bundle 'vim-scripts/a.vim'
Bundle 'jabbourb/omnicpp'
" }}}2

" Colorschemes {{{2
" Using my own colorschemes
" This is a fork from https://github.com/flazz/vim-colorschemes
Bundle 'amilaperera/vim-colorschemes'
" }}}2

" Ruby enhancements {{{2
Bundle 'tpope/vim-bundler'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-rake'
Bundle 'vim-ruby/vim-ruby'
" }}}2

" Snipmate plugin, related dependencies & snippets {{{2
Bundle 'garbas/vim-snipmate'
Bundle 'tomtom/tlib_vim'
Bundle 'MarcWeber/vim-addon-mw-utils'
" Using my own snippets
" This is a fork from https://github.com/honza/vim-snippets
Bundle 'amilaperera/vim-snippets'
" }}}2
" }}}
