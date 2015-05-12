"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Plugins File
" Author: Amila Perera
" File Name: .vimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Vundle setup
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage the plugins
Plugin 'gmarik/Vundle.vim'

" General enhancements
Plugin 'vim-scripts/AutoComplPop'
Plugin 'vim-scripts/DrawIt'
Plugin 'vim-scripts/EasyGrep'
Plugin 'vim-scripts/FuzzyFinder'
Plugin 'vim-scripts/VisIncr'
Plugin 'vim-scripts/ZoomWin'
Plugin 'vim-scripts/highlight.vim'
Plugin 'vim-scripts/mru.vim'
Plugin 'vim-scripts/vcscommand.vim'
Plugin 'vim-scripts/L9'
Plugin 'vim-scripts/txt.vim'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-eunuch'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'ervandew/supertab'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'nelstrom/vim-visual-star-search'
Plugin 'godlygeek/tabular'
Plugin 'Raimondi/delimitMate'
Plugin 'maxbrunsfeld/vim-yankstack'
Plugin 'rking/ag.vim'
Plugin 'jimsei/winresizer'
Plugin 'majutsushi/tagbar'
Plugin 'brookhong/cscope.vim'
Plugin 'mhinz/vim-signify'
Plugin 'sjl/gundo.vim.git'

" Using the updated version of bufkill plugin
" since the original vim-script repository is not yet
" updated, get the fork it and updated it
Plugin 'amilaperera/bufkill.vim'

" General development related
Plugin 'vim-scripts/DoxygenToolkit.vim'

" Vim tmux integration
Plugin 'tpope/vim-tbone'

" Vim custom text objects
Plugin 'kana/vim-textobj-user'
Plugin 'kana/vim-textobj-entire'
Plugin 'kana/vim-textobj-indent'
Plugin 'kana/vim-textobj-syntax'
Plugin 'kana/vim-textobj-line'
Plugin 'nelstrom/vim-textobj-rubyblock'

" HTML editing
Plugin 'mattn/emmet-vim'
Plugin 'othree/html5.vim'

" C/C++ enhancements
Plugin 'vim-scripts/a.vim'

" Colorschemes
" Using my own colorschemes
" This is a fork from https://github.com/flazz/vim-colorschemes
Plugin 'amilaperera/vim-colorschemes'

" Ruby enhancements
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-rake'
Plugin 'vim-ruby/vim-ruby'

" Snipmate plugin, related dependencies & snippets
Plugin 'sirver/ultisnips'
" Using my own snippets
" This is a fork from https://github.com/honza/vim-snippets
Plugin 'amilaperera/vim-snippets'

call vundle#end()
