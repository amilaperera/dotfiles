"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Configuration File
" Author: Amila Perera
" File Name: .vimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin manager setup
call plug#begin('~/.vim/plugged')

" General enhancements
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'qpkorr/vim-bufkill'
Plug 'thinca/vim-visualstar'
Plug 'cohama/lexima.vim'

" Statusline plugin
Plug 'itchyny/lightline.vim'

" Git stuff
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Vim-Tmux integration
Plug 'tpope/vim-tbone'
Plug 'benmills/vimux'

" Colorschemes
Plug 'flazz/vim-colorschemes'

" Enhanced cpp syntax highlighting
Plug 'octol/vim-cpp-enhanced-highlight'

" FZF
Plug 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
Plug 'junegunn/fzf.vim'

" Language Server Protocol
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" Auto Completion
Plug 'lifepillar/vim-mucomplete'

" Highlight
Plug 'azabiong/vim-highlighter'

call plug#end()


" General settings
set nocompatible               " Be improved
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
set t_Co=256                   " letting vim know that we're using 256 color terminal
let mapleader = ","            " set mapleader to ','
set pastetoggle=<F2>

" Miscellaneous
filetype on               " filetype detection on
filetype plugin on        " filetype plugin on
filetype indent on        " filetype indent on
syntax on                 " always syntax on

" more plugins
runtime! macros/matchit.vim " autoload the matchit plugin on startup
runtime! ftplugin/man.vim   " load the man page file type plugin on startup

set autoindent            " auto-indent on
set nofoldenable          " disable fold functionality
set foldmethod=syntax     " foldmethod to syntax
set foldtext=NeatFoldText()

" Wildmenu settings
set wildmenu              " command line completion wildmenu
set wildmode=full         " completes till longest common string
set wildignorecase        " ignores case when completing file names & directories
" Ignore below when file name completion
set wildignore=*.o,*.obj,*.a,*.so,*.jpg,*.png,*.gif,*.dll,*.exe,*.dpkg,*.rpm,*.pdf,*.chm

" Timeout settings
set timeoutlen=1200 " more time for macros
set ttimeoutlen=50  " makes Esc to work faster

" Moving cursor to prev/next lines
set whichwrap=b,s,<,>,~,[,]

" History settings
set history=1000

" UI Settings
set list                      " strings to be used in list mode
set listchars=tab:\|.,trail:- " strings to be used in list mode

set tabstop=4                 " number of spaces that a tab counts for
set shiftwidth=4              " number of spaces to be used in each step of indent
set softtabstop=4             " number of spaces that a tab counts for while editing
set expandtab                 " use spaces to insert a tab

set cino=:0
set cino=l1

set cursorline              " display cursor line(This might make the window redraw a little slow)

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
set textwidth=100             " maximum width of the text that is being inserted
set title                     " display title
set display=lastline          " show as much as possible of the last line

" source a file if it exists
function! SourceIfExists(file)
    if filereadable(expand(a:file))
        execute 'source' a:file
    endif
endfunction

" ColorScheme
" set the colorscheme only for terminal vim
" for gui vim use the colorscheme in the .gvimrc
if ! has('gui_running')
    set background=dark
    if (&term == "xterm-256color" || &term == "screen-256color" || &term == "tmux-256color")
        colorscheme gruvbox
    else
        colorscheme default
    endif
endif

" Set encoding & fileformat settings
set encoding=utf-8
set fileencoding=utf-8
set fileformats=unix,dos,mac
set fileencodings=ucs-bom,utf-8,euc-jp,cp932,iso-2022-jp,ucs-2le,ucs-2

" Diff Settings
set diffopt=filler
set diffopt+=vertical
set diffopt+=context:3

" Dictionary & Spell Checking
set spelllang=en                      " set spell language to English
set nospell                           " no spell checking by default
set dictionary+=/usr/share/dict/words " set the dictionary file

" Lightline
let g:lightline = {
      \ 'colorscheme': 'default',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" Fugitive
" Git grep with qiuck-fix window
nmap <Leader>gq :Ggrep -q<Space>
" Git grep the current word under the cursor
nmap <Leader>gw :Ggrep -q -w <C-R><C-W><Space>
" Logging the last 10000 commits (helpful in big projects)
nmap <Leader>gl :Gclog -10000<CR>

" NerdCommenter Settings
let g:NERDSpaceDelims       = 1
let g:NERDRemoveExtraSpaces = 1
imap <C-c> <plug>NERDCommenterInsert

" Nerdtree settings
map <silent> <C-e> :NERDTreeToggle<CR>
let g:NERDTreeDirArrows     = 1
let g:NERDTreeShowHidden    = 0
let g:NERDTreeWinSize       = 32
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeChDirMode     = 2         "CWD is changed whenever the root directory is changed
let g:NERDTreeIgnore        = ['\.o$', '\.a$', '\.so$', '\.so.*$', '\.dpkg$', '\.rpm$', '\.obj$', '\.exe$', '\.d$','\.swp$', '\.git$', '\~$']
map <leader>r :NERDTreeFind<CR>

" Enhanced cpp highlighting
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1
let c_no_curly_error = 1

" fzf
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>fg :GFiles<CR>
nnoremap <Leader>m :History<CR>
nnoremap <Leader>fb :Buffers<CR>
let g:fzf_preview_window=[]

" yankstack
" load the yankstack plugin immediately
" otherwise the vS mapping of the vim-surround gets clobbered
call yankstack#setup()
nmap <C-p> <Plug>yankstack_substitute_older_paste
nmap <C-n> <Plug>yankstack_substitute_newer_paste

" vimux settings
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

" lsp
call SourceIfExists("~/.local/.lsp-server-settings.vim")

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> <leader>gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    let g:lsp_format_sync_timeout = 1000
    let g:lsp_diagnostics_enabled = 0
    let g:lsp_diagnostics_highlights_enabled = 0
    let g:lsp_diagnostics_signs_enabled = 0
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" MUcomplete
" Mandatory options for plugin to work
set completeopt+=menuone
set completeopt+=noselect

" Shut off completion messages
set shortmess+=c

" prevent a condition where vim lags due to searching include files.
set complete-=i
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#chains = {}
let g:mucomplete#chains.default  = ['path', 'omni', 'keyn', 'dict', 'uspl', 'ulti']
let g:mucomplete#chains.markdown = ['path', 'keyn', 'dict', 'uspl']
let g:mucomplete#chains.vim      = ['path', 'keyn', 'dict', 'uspl']
map muc :MUcompleteAutoToggle<CR>

" Functions

" Custom fold text
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

" QuickFix window toggling function
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

" File type specific settings
augroup FTCheck
    autocmd!
    autocmd BufNewFile,BufRead *.text,*.notes,*.memo setl ft=txt
augroup END

augroup FTOptions
    autocmd!
    autocmd Filetype sh,zsh,csh,tcsh setl ts=4 sw=4 sts=4 fdm=marker
    autocmd Filetype yaml            setl ts=4 sw=4 sts=4 fdm=indent
    autocmd Filetype html,css        setl ts=4 sw=4 sts=4 fdm=indent
    autocmd Filetype vim             setl ts=4 sw=4 sts=4 fdm=marker
    autocmd Filetype txt,mail        setl ts=4 sw=4 sts=4 fdm=indent
    autocmd Filetype php             setl ts=4 sw=4 sts=4 fdm=indent
    autocmd Filetype perl            setl ts=4 sw=4 sts=4 fdm=indent
    autocmd Filetype gitcommit       setl spell

    autocmd BufNewFile,BufRead *.c,*.cpp,*.c++,*.cxx,*.h,*hpp setl ts=4 sw=4 sts=4
    autocmd BufNewFile,BufRead *.pro setl ft=QT_PROJECT_FILE syn=make
    autocmd BufNewFile,BufRead SCons* set ft=scons
    autocmd BufNewFile,BufRead Config.in set ft=config
augroup END

" Personal Mappings

" Fast editing of vimrc
map <Leader>v :tabedit $MYVIMRC<CR>
" sourcing of vimrc upon save
" ++nested hack is to prevent lightline lose colors.
" https://github.com/itchyny/lightline.vim/issues/406
autocmd! BufWritePost $MYVIMRC ++nested so $MYVIMRC

" encoding conversion
map <silent> <Leader>u :e! ++enc=utf-8<CR>

" nohlsearch, after a search
nnoremap <silent> <C-L> :nohlsearch<CR>

" retain visual selection after indentation
vnoremap > >gv
vnoremap < <gv

" window resizing
map <Up> :resize +1<CR>
map <Down> :resize -1<CR>
map <Left> :vertical resize -1<CR>
map <Right> :vertical resize +1<CR>

" changes directory to the directory of the current buffer
nmap <silent> <Leader>cd :lcd %:h<CR>:pwd<CR>

" get the full path of the file in the buffer
nmap <Leader> <Space> :echo expand('%:p')<CR>

" Heading
noremap <silent> <Leader>h1 yyp^v$r=
noremap <silent> <Leader>h2 yyp^v$r-

" merge consecutive empty lines and clean up trailing spaces(from tpope's .vimrc file)
map <Leader>fm :g/^\s*$/,/\S/-j<Bar>%s/\s\+$//<CR>

" switching tabs made easy
nmap <Leader>1 1gt
nmap <Leader>2 2gt
nmap <Leader>3 3gt
nmap <Leader>4 4gt
nmap <Leader>5 5gt
nmap <Leader>6 6gt
nmap <Leader>7 7gt
nmap <Leader>8 8gt
nmap <Leader>9 9gt

" Mappings for functions
" QuickFixWindow Toggle
nmap <silent> <Leader>q <ESC>:QFix<CR>

" Invoke termdebug
function! StartGdb(bin)
    packadd termdebug
    execute 'Termdebug ' . a:bin
endfunction

function! StartGdbW(bin)
    packadd termdebug
    let g:termdebug_wide=1
    execute 'Termdebug ' . a:bin
endfunction

command! -nargs=1 -complete=file StartGdb call StartGdb(<q-args>)
command! -nargs=1 -complete=file StartGdbW call StartGdbW(<q-args>)

" Sending commands to gdb
map <Leader>dn :call TermDebugSendCommand('n')<CR>
map <Leader>ds :call TermDebugSendCommand('s')<CR>
map <Leader>df :call TermDebugSendCommand('finish')<CR>
map <Leader>dc :call TermDebugSendCommand('continue')<CR>

" Source particular environment related vim settings
call SourceIfExists("~/.local/.env-settings.vim")
