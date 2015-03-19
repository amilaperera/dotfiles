"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Plugins File
" Author: Amila Perera
" File Name: .vimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Vundle setup {{{
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage the plugins {{{2
Plugin 'gmarik/Vundle.vim'
" }}}2

" General enhancements {{{2
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
" }}}2

" Using the updated version of bufkill plugin {{{2
" since the original vim-script repository is not yet
" updated, get the fork it and updated it
Plugin 'amilaperera/bufkill.vim'
" }}}2

" General development related {{{2
Plugin 'vim-scripts/DoxygenToolkit.vim'
" }}}2

" Vim tmux integration {{{2
Plugin 'tpope/vim-tbone'
" }}}2

" Vim custom text objects {{{2
Plugin 'kana/vim-textobj-user'
Plugin 'kana/vim-textobj-entire'
Plugin 'kana/vim-textobj-indent'
Plugin 'kana/vim-textobj-syntax'
Plugin 'kana/vim-textobj-line'
Plugin 'nelstrom/vim-textobj-rubyblock'
" }}}2

" HTML editing {{{2
Plugin 'mattn/emmet-vim'
Plugin 'othree/html5.vim'
" }}}2

" C/C++ enhancements {{{2
Plugin 'vim-scripts/a.vim'
Plugin 'jabbourb/omnicpp'
" }}}2

" Colorschemes {{{2
" Using my own colorschemes
" This is a fork from https://github.com/flazz/vim-colorschemes
Plugin 'amilaperera/vim-colorschemes'
" }}}2

" Ruby enhancements {{{2
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-rake'
Plugin 'vim-ruby/vim-ruby'
" }}}2

" Snipmate plugin, related dependencies & snippets {{{2
Plugin 'sirver/ultisnips'
" Using my own snippets
" This is a fork from https://github.com/honza/vim-snippets
Plugin 'amilaperera/vim-snippets'
" }}}2

call vundle#end()
" }}}
