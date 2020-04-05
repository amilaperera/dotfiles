"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Configuration File
" Author: Amila Perera
" File Name: .vimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin manager setup {{{
call plug#begin(stdpath('data') . '/plugged')

" General enhancements
Plug 'vim-scripts/VisIncr'
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'jlanzarotta/bufexplorer'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'Lokaltog/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'jimsei/winresizer'
Plug 'sjl/gundo.vim'

" ctags related & dependencies
Plug 'majutsushi/tagbar'
Plug 'xolox/vim-misc'

" General development related
Plug 'vim-scripts/DoxygenToolkit.vim'

" Vim tmux integration
Plug 'tpope/vim-tbone'
Plug 'benmills/vimux'

" C/C++ enhancements
Plug 'vim-scripts/a.vim'
Plug 'octol/vim-cpp-enhanced-highlight'

" Vim-Jinja2 syntax hightlighting
Plug 'Glench/Vim-Jinja2-Syntax'

" Colorschemes
Plug 'flazz/vim-colorschemes'

" Snippets plugin, related dependencies & snippets
Plug 'sirver/ultisnips'

" Vim-snippets to be used along with UltiSnips & SnipMate
Plug 'honza/vim-snippets'

" Vim Grepper - fully async grep plugin that works with ag, ack, git grep etc.
Plug 'mhinz/vim-grepper'

" git diff shower
Plug 'airblade/vim-gitgutter'

" asynchronous command runner
Plug 'skywind3000/asyncrun.vim'

" vim-airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" auto-closing
Plug 'cohama/lexima.vim'

" scratch pad
Plug 'konfekt/vim-scratchpad'

" code completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

call plug#end()
" }}}

" General settings {{{
"
set exrc                       " use a local version of .(g)vimrc
set secure                     " disable unsafe commands in local .vimrc files

set hidden                     " hide unsaved buffers
set autochdir                  " changes to the directory containing the file which was opened or selected
set autowriteall               " writes the contents of the file when moving to another file
set autoread                   " read automatically when a file is changed
set backspace=indent,eol,start " backspace more flexible
set noerrorbells               " no error bells
set novisualbell               " no visual bells
set visualbell t_vb=           " no beep, no flash NOTE: for some reason this has tobe set in .gvimrc too
set noswapfile                 " no swap files
set helpheight=35              " height of the help window
set mouse=nvi                  " use mouse in normal, visual & insert modes
set mousemodel=popup           " right mosue button pops up a menu
set updatetime=250             " vim update time - affects the behaviour of certain plugins(git-gutter)
set laststatus=2               " status line always
set noshowmode                 " mode is evident via statusline plugin
" }}}

" Changing map leader {{{
let mapleader = "," " set mapleader to ','
" }}}

" Paste toggling {{{
set pastetoggle=<F2>
" }}}

" Miscellaneous {{{
filetype on               " filetype detection on
filetype plugin on        " filetype plugin on
filetype indent on        " filetype indent on
syntax on                 " always syntax on

runtime! macros/matchit.vim " autoload the matchit plugin on startup
runtime! ftplugin/man.vim   " load the man page file type plugin on startup

set autoindent            " auto-indent on
set foldenable            " enable fold functionality
set foldmethod=syntax     " foldmethod to syntax
set foldtext=NeatFoldText()

" Wildmenu settings {{{2
set wildmenu              " command line completion wildmenu
set wildmode=full         " completes till longest common string
" }}}2

" Timeout settings {{{2
set timeoutlen=1200 " more time for macros
set ttimeoutlen=50  " makes Esc to work faster
" }}}2

" Moving cursor to prev/next lines {{{2
set whichwrap=b,s,<,>,~,[,]
" }}}2

" Ignore below when file name completion {{{2
set wildignore=*.o,*.obj,*.a,*.so,*.jpg,*.png,*.gif,*.dll,*.exe,*.dpkg,*.rpm,*.pdf,*.chm
" }}}2

" History settings {{{2
set history=1000
" }}}2

" Set possible locations for the tags file {{{2
set tags=./tags
set tags+=../tags
set tags+=../../tags
set tags+=../../../tags
set tags+=../../../../tags
set tags+=../../../../../tags
set tags+=../../../../../../tags
set tags+=../../../../../../../tags
set tags+=../../../../../../../../tags
set tags+=../../../../../../../../../tags
" }}}2
" }}}

" UI Settings {{{
set list                      " strings to be used in list mode
set listchars=tab:\|.,trail:- " strings to be used in list mode

set tabstop=2                 " number of spaces that a tab counts for
set shiftwidth=2              " number of spaces to be used in each step of indent
set softtabstop=2             " number of spaces that a tab counts for while editing
set expandtab                 " use spaces to insert a tab

set cino=:0
set cino=l1

set cursorline                " display cursor line(This might make the window redraw a little slow)
set nocursorcolumn            " display nocursorcolumn - window redraw is slow

set nonumber                  " show line numbers
set numberwidth=6             " safe upto 999999

set hlsearch                  " highlight searched phrases
set incsearch                 " highlight as you type your search phrase
set ignorecase                " if caps are included in search string go case sensitive
set magic                     " keeps the magic option to its default value for maximum portability

set scrolloff=2               " keeps 5 lines for scope when scrolling
set matchtime=10              " tenth of milliseconds to show the matching paren
set lazyredraw                " don't redraw screen while typing macros
set nostartofline             " leave my cursor where it was
set showcmd                   " show the command being typed
set cmdheight=2               " set command height to 2
set report=0                  " always report the number of lines changed
set ruler                     " always shows the current position bottom the screen

set textwidth=100             " maximum width of the text that is being inserted

set title                     " display title
set display=lastline          " show as much as possible of the last line

" ColorScheme {{{2
set termguicolors
set background=dark
colorscheme molokai
set t_Co=256                   " letting vim know that we're using 256 color terminal
" }}}2

" }}}

" Set encoding & fileformat settings {{{
set encoding=utf-8
set fileencoding=utf-8
set fileformats=unix,dos,mac
set fileencodings=ucs-bom,utf-8,euc-jp,cp932,iso-2022-jp,ucs-2le,ucs-2
" }}}

" Diff Settings {{{
set diffopt=filler
set diffopt+=vertical
set diffopt+=context:3
" }}}

" Dictionary & Spell Checking {{{
set spelllang=en                      " set spell language to English
set nospell                           " no spell checking by default
set dictionary+=/usr/share/dict/words " set the dictionary file
" }}}

" Settings related to external plugins {{{
" vim-airline {{{2
let g:airline_powerline_fonts = 1
let g:airline_theme='molokai'
" }}}

" Deoplete {{{2
let g:deoplete#enable_at_startup = 1
" }}}

" BufferExplorer mappings {{{2
nnoremap <silent> <F12> :BufExplorer<CR>
" }}}2

" NerdCommenter Settings {{{2
let g:NERDSpaceDelims       = 1
let g:NERDRemoveExtraSpaces = 1
imap <C-c> <plug>NERDCommenterInsert
" }}}2

" Nerdtree settings {{{2
map <silent> <left> :NERDTreeToggle<CR>
let g:NERDTreeDirArrows     = 1
let g:NERDTreeShowHidden    = 0
let g:NERDTreeWinSize       = 32
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeChDirMode     = 2         "CWD is changed whenever the root directory is changed
let g:NERDTreeIgnore        = ['\.o$', '\.a$', '\.so$', '\.so.*$', '\.dpkg$', '\.rpm$', '\.obj$', '\.exe$', '\.d$','\.swp$', '\.git$', '\~$']
map <leader>r :NERDTreeFind<CR>
" }}}2

" Tagbar settings {{{2
map <silent> <right> :TagbarToggle<CR>
" }}}2

" CtrlP {{{2
" disable the key mapping
nnoremap <Leader>p :CtrlP<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>m :CtrlPMRU<CR>
let g:ctrlp_map =''
let g:ctrlp_show_hidden = 1
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_root_markers = ['']
" }}}2

" Tabularize {{{2
nmap <silent> <Leader>a= :Tabularize /=<CR>
vmap <silent> <Leader>a= :Tabularize /=<CR>
nmap <silent> <Leader>a: :Tabularize /:\zs<CR>
vmap <silent> <Leader>a: :Tabularize /:\zs<CR>
" }}}2

" yankstack {{{2
" load the yankstack plugin immediately
" otherwise the vS mapping of the vim-surround gets clobbered
call yankstack#setup()
nmap <C-p> <Plug>yankstack_substitute_older_paste
nmap <C-n> <Plug>yankstack_substitute_newer_paste
" }}}2

" winresizer {{{2
let g:winresizer_vert_resize = 2
let g:winresizer_horiz_resize = 1
" }}}2

" ultisnips {{{2
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"
" }}}2

" gundo {{{2
if has('python3')
  let g:gundo_prefer_python3 = 1   " enable Gundo with python3+ support
endif
nnoremap <F5> :GundoToggle<CR>
" }}}2

" Grepper {{{2
nnoremap <leader>gg :Grepper -tool git -highlight<cr>
nnoremap <leader>ga :Grepper -tool ag -highlight<cr>
nnoremap <leader>*  :Grepper -tool ag -cword -noprompt -highlight<cr>

let g:grepper           = {}
let g:grepper.dir       = 'repo,cwd' " current working directory if repo fails
let g:grepper.tools     = ['git', 'ag', 'grep']
let g:grepper.next_tool = '<leader>g'

let g:grepper.git = {
  \ 'grepprg': 'git grep -nI --no-color'
  \ }
" }}}2

" ScrachPad {{{2
let g:scratchpad_ftype = 'markdown'
" }}}2

" Functions {{{
" Custom fold text {{{2
" taken from http://dhruvasagar.com/2013/03/28/vim-better-foldtext
function! NeatFoldText()
  let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
  let foldchar = matchstr(&fillchars, 'fold:\zs.')
  let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(foldchar, 8)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
" }}}2

" QuickFix window toggling function {{{2
command! -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
  else
    execute "botright cwindow " . g:jah_Quickfix_Win_Height
  endif
endfunction

" used to track the quickfix window
augroup QFixToggle
  autocmd!
  autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
  autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
augroup END

let g:jah_Quickfix_Win_Height = 10 " setting qfix window height
" }}}2

" tabs to spaces & spaces to tabs conversion {{{2
" Return indent (all whitespace at start of a line), converted from
" tabs to spaces if what = 1, or from spaces to tabs otherwise.
" When converting to tabs, result has no redundant spaces.
function! Indenting(indent, what, cols)
  let spccol = repeat(' ', a:cols)
  let result = substitute(a:indent, spccol, '\t', 'g')
  let result = substitute(result, ' \+\ze\t', '', 'g')
  if a:what == 1
    let result = substitute(result, '\t', spccol, 'g')
  endif
  return result
endfunction

" Convert whitespace used for indenting (before first non-whitespace).
" what = 0 (convert spaces to tabs), or 1 (convert tabs to spaces).
" cols = string with number of columns per tab, or empty to use 'tabstop'.
" The cursor position is restored, but the cursor will be in a different
" column when the number of characters in the indent of the line is changed.
function! IndentConvert(line1, line2, what, cols)
  let savepos = getpos('.')
  let cols = empty(a:cols) ? &tabstop : a:cols
  execute a:line1 . ',' . a:line2 . 's/^\s\+/\=Indenting(submatch(0), a:what, cols)/e'
  call histdel('search', -1)
  call setpos('.', savepos)
endfunction
command! -nargs=? -range=% Space2Tab call IndentConvert(<line1>,<line2>,0,<q-args>)
command! -nargs=? -range=% Tab2Space call IndentConvert(<line1>,<line2>,1,<q-args>)
command! -nargs=? -range=% RetabIndent call IndentConvert(<line1>,<line2>,&et,<q-args>)
" }}}2

" vimux settings{{{2
 " Prompt for a command to run
 map <Leader>vp :VimuxPromptCommand<CR>
 " Run last command executed by VimuxRunCommand
 map <Leader>vl :VimuxRunLastCommand<CR>
 " Inspect runner pane
 map <Leader>vi :VimuxInspectRunner<CR>
 " Close vim tmux runner opened by VimuxRunCommand
 map <Leader>vq :VimuxCloseRunner<CR>
 " Interrupt any command running in the runner pane
 map <Leader>vx :VimuxInterruptRunner<CR>
 " Zoom the runner pane (use <bind-key> z to restore runner pane)
 map <Leader>vz :call VimuxZoomRunner()<CR>
 "}}}2

" }}}

" File type specific settings {{{
augroup FTCheck
  autocmd!
  autocmd BufNewFile,BufRead *.text,*.notes,*.memo setl ft=txt
augroup END

augroup FTOptions
  autocmd!
  autocmd Filetype sh,zsh,csh,tcsh setl ts=2 noet fdm=marker
  autocmd Filetype yaml            setl ts=4 sw=4 sts=4 fdm=indent
  autocmd Filetype html,css        setl ts=2 sw=2 sts=2 fdm=indent
  autocmd Filetype vim             setl ts=2 sw=2 sts=2 fdm=marker
  autocmd Filetype txt,mail        setl ts=2 sw=2 sts=2 fdm=indent
  autocmd Filetype php             setl ts=2 sw=2 sts=2 fdm=indent
  autocmd Filetype perl            setl ts=2 sw=2 sts=2 fdm=indent
  autocmd Filetype gitcommit,markdown    setl spell

  autocmd BufNewFile,BufRead *.c,*.cpp,*.c++,*.cxx,*.h,*hpp setl ts=2 sw=2 sts=2
  autocmd BufNewFile,BufRead *.pro setl ft=QT_PROJECT_FILE syn=make
  autocmd BufNewFile,BufRead *.tmpl set ft=jinja
  autocmd BufNewFile,BufRead SCons* set ft=scons
  autocmd BufNewFile,BufRead Config.in set ft=config
augroup END
" }}}

" Personal Mappings {{{

" When .vimrc is edited, reload it {{{2
if has('win32') || has('win64')
  autocmd! BufWritePost _vimrc source $MYVIMRC
  autocmd! BufWritePost init.vim source $MYVIMRC
  autocmd! BufWritePost vimrc source $MYVIMRC
  autocmd! BufWritePost _gvimrc source $HOME/_gvimrc
  autocmd! BufWritePost gvimrc source $HOME/gvimrc
else
  autocmd! BufWritePost .vimrc source $MYVIMRC
  autocmd! BufWritePost init.vim source $MYVIMRC
  autocmd! BufWritePost .gvimrc source $HOME/.gvimrc
endif
" }}}2

" Fast editing of the vim, tmux configuration files {{{2
map <Leader>v :e! $MYVIMRC<CR>
if has('win32') || has('win64')
  map <Leader>gv :e! $HOME/_gvimrc<CR>
else
  map <Leader>gv :e! $HOME/.gvimrc<CR>
endif
" }}}2

" nohlsearch, after a search {{{2
nnoremap <silent> <C-L> :nohlsearch<CR>
" }}}2

" retain visual selection after indentation {{{2
vnoremap > >gv
vnoremap < <gv
" }}}2

" vimgrep {{{2
" Displays a vimgrep command template
map <Leader>g :vimgrep // ../**/*.<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
" Search the current file for the word under the cursor and display matches
nmap <silent> <Leader>gw :vimgrep /<C-r><C-w>/ %<CR>:cclose<CR>:cwindow<CR><C-W>J:nohlsearch<CR>
" }}}2

" force encoding conversion {{{2
map <silent> <Leader>e :e! ++enc=euc-jp<CR>
map <silent> <Leader>u :e! ++enc=utf-8<CR>
" }}}2

" changes directory to the directory of the current buffer {{{2
nmap <silent> <Leader>cd :lcd %:h<CR>:pwd<CR>
" }}}2

" get the full path of the file in the buffer {{{2
nmap <Leader> <Space> :echo expand('%:p')<CR>
" }}}2

" Heading {{{2
noremap <silent> <Leader>h1 yyp^v$r=
noremap <silent> <Leader>h2 yyp^v$r-
noremap <silent> <Leader>he <ESC>070i=<ESC>
noremap <silent> <Leader>hh <ESC>070i-<ESC>
noremap <silent> <Leader>hs <ESC>070i*<ESC>
" }}}2

" Window closing commands {{{2
" Close this window
noremap <silent> <Leader>clw :close<CR>
" Close the other window
noremap <silent> <Leader>clj :wincmd j<CR>:close<CR>
noremap <silent> <Leader>clk :wincmd k<CR>:close<CR>
noremap <silent> <Leader>clh :wincmd h<CR>:close<CR>
noremap <silent> <Leader>cll :wincmd l<CR>:close<CR>
" }}}2

" merge consecutive empty lines and clean up trailing spaces(from tpope's .vimrc file) {{{2
map <Leader>fm :g/^\s*$/,/\S/-j<Bar>%s/\s\+$//<CR>
" }}}2

" Mappings for functions {{{2
" QuickFixWindow Toggle
nmap <silent> <Leader>q <ESC>:QFix<CR>
" }}}2

" }}}
