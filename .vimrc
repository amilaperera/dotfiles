"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Configuration File
" Author: Amila Perera
" File Name: .vimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"--------------------------------------------------------------
" General
"--------------------------------------------------------------
set nocompatible                    " gets out of vi compatible mode
set noexrc                          " don't use a local version of .(g)vimrc
set hidden                          " hide unsaved buffers
set autochdir                       " changes to the directory containing the file which was opened or selected
set autowriteall                    " writes the contents of the file when moving to another file
set autoread                        " read automatically when a file is changed
set backspace=indent,eol,start      " backspace more flexible
set mouse=n                         " use mouse in normal mode
set noerrorbells                    " no error bells
set novisualbell                    " no visual bells
set visualbell t_vb=                " no beep, no flash NOTE: for some reason this has tobe set in .gvimrc too

set noswapfile                      " no swap files

let mapleader = ","                 " set mapleader to ,

filetype off
call pathogen#infect()
call pathogen#helptags()

filetype on                         " filetype detection on
filetype plugin on                  " filetype plugin on
filetype indent on                  " filetype indent on

syntax on                           " always syntax on

set autoindent                      " auto-indent on
set foldenable                      " enable fold functionality
set foldmethod=syntax               " foldmethod to syntax
set foldtext=MyFoldText()           " custom fold text

set wildmenu                        " command line completion wildmenu
set wildmode=full                   " completes till longest common string
" use all keys to wrap to the previous/next line {
set whichwrap=b,s                   " <BS>, <Space>
set whichwrap+=<,>                  " <Left, Right> Normal & Visual
set whichwrap+=~                    " ~
set whichwrap+=[,]                  " <Left, Right> Insert & Replace
"}
" Ignore below when file name completion {
set wildignore=*.o
set wildignore+=*.obj
set wildignore+=*.a
set wildignore+=*.so
set wildignore+=*.jpg
set wildignore+=*.png
set wildignore+=*.gif
set wildignore+=*.dll
set wildignore+=*.exe
set wildignore+=*.dpkg
set wildignore+=*.rpm
set wildignore+=*.pdf
set wildignore+=*.chm
"}

set history=1000                     " 1000 entries are stored

" Set possible locations for the tags file {
set tags=./tags
set tags+=../tags
set tags+=../../tags
"}

" Allow '/' in directory paths in Windows {
if has('win32') || has('win64')
    set shellslash
endif
"}

"--------------------------------------------------------------
" UI Settings
"--------------------------------------------------------------
set list                                    " strings to be used in list mode
set listchars=tab:\|.,trail:-               " strings to be used in list mode

set tabstop=4                               " number of spaces that a tab counts for
set shiftwidth=4                            " number of spaces to be used in each step of indent
set softtabstop=4                           " number of spaces that a tab counts for while editing
set expandtab                               " use spaces to insert a tab

set cino=:0
set cino=l1

set nocursorline                            " display nocursorline - window redraw is slow
set nocursorcolumn                          " display nocursorcolumn - window redraw is slow

set nonumber                                " show line numbers
set numberwidth=6                           " safe upto 999999

set hlsearch                                " highlight searched phrases
set incsearch                               " highlight as you type your search phrase
set ignorecase                              " if caps are included in search string go case sensitive
set magic                                   " keeps the magic option to its default value for maximum portability

set scrolloff=5                             " keeps 5 lines for scope when scrolling
set matchtime=5                             " tenth of milliseconds to show the matching paren
set lazyredraw                              " don't redraw screen while typing macros
set nostartofline                           " leave my cursor where it was
set showcmd                                 " show the command being typed
set cmdheight=1                             " set command height to 1
set report=0                                " always report the number of lines changed
set ruler                                   " always shows the current position bottom the screen

set textwidth=100                           " maximum width of the text that is being inserted

set title                                   " display title
set display=lastline                        " show as much as possible of the last line


" ColorScheme {
let s:myFavouriteGuiColorScheme     = "xoria256"
let s:myFavouriteTermColorScheme256 = "xoria256"
let s:myFavouriteTermColorSchem     = "default"
if has("gui_running")
    set background=dark                         " set background dark
    " colorscheme for GVIM
    execute "colorscheme " . s:myFavouriteGuiColorScheme
elseif (&term == "xterm-256color" || &term == "screen-256color")
    set background=dark                         " set background dark
    " colorscheme for VIM if it has xterm-256color
    execute "colorscheme " . s:myFavouriteTermColorScheme256
else
    " sets default colorsheme if neither GVIM nor VIM with xterm-256color
    execute "colorscheme " . s:myFavouriteTermColorSchem
endif

"--------------------------------------------------------------
" StatusLine Settings
"--------------------------------------------------------------
" Setting Statusline {
set laststatus=2                                " set status line visible even in single window mode
if has('iconv')
    set statusline=%<%F\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).(&bomb?':BOM':'').']['.&ff.']'}\[TYPE=%Y]\ %{fugitive#statusline()}%=[ASCII=0x%{FencB()}]\ [POS=(%l,%v)]\ [LINES=%L]%8P\ 
else
    set statusline=%<%F\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).(&bomb?':BOM':'').']['.&ff.']'}\[TYPE=%Y]\ %{fugitive#statusline()}%=[ASCII=0x%{FencB()}]\ [POS=(%l,%v)]\ [LINES=%L]%8P\ 
endif

function! FencB()
    let c = matchstr(getline('.'), '.', col('.') - 1)
    let c = iconv(c, &enc, &fenc)
    return s:Byte2hex(s:Str2byte(c))
endfunction

function! s:Str2byte(str)
    return map(range(len(a:str)), 'char2nr(a:str[v:val])')
endfunction

function! s:Byte2hex(bytes)
    return join(map(copy(a:bytes), 'printf("%02X", v:val)'), '')
endfunction
"}

" Changing statusline color in insert mode {
" let g:hi_insert = 'highlight StatusLine guifg=black guibg=yellow gui=none ctermfg=black ctermbg=yellow cterm=none'

" if has('syntax')
    " augroup InsertHook
        " autocmd!
        " autocmd InsertEnter * call s:StatusLine('Enter')
        " autocmd InsertLeave * call s:StatusLine('Leave')
    " augroup END
" endif

" let s:slhlcmd = ''
" function! s:StatusLine(mode)
    " if a:mode == 'Enter'
        " silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
        " silent exec g:hi_insert
    " else
        " highlight clear StatusLine
        " silent exec s:slhlcmd
        " redraw
    " endif
" endfunction

" function! s:GetHighlight(hi)
    " redir => hl
    " exec 'highlight '.a:hi
    " redir END
    " let hl = substitute(hl, '[\r\n]', '', 'g')
    " let hl = substitute(hl, 'xxx', '', '')
    " return hl
" endfunction
"}

"--------------------------------------------------------------
" Japanese Settings
"--------------------------------------------------------------
" Set encoding & fileformat settings {
if has('win32') || has('win64')
    source $HOME\vimfiles\charencode_plugin\encode.vim              " source the encoding file
    set encoding=japan
else
    set encoding=utf-8
    set fileencoding=utf-8
    set fileformats=unix,dos,mac
    set fileencodings=ucs-bom,utf-8,euc-jp,cp932,iso-2022-jp,ucs-2le,ucs-2
endif
"}

" Display ZenkakuSpace, tabs and trailing spaces {
if has("syntax")
    syntax on
    syn sync fromstart
    function! ActivateInvisibleIndicator()
        highlight InvisibleJISX0208Space term=NONE ctermbg=Blue guibg=darkgray gui=NONE
        syntax match InvisibleJISX0208Space "　" display containedin=ALL
    endfunction
    augroup invisible
        autocmd! invisible
        autocmd FileType * call ActivateInvisibleIndicator()
    augroup END
endif

"--------------------------------------------------------------
" Diff Settings
"--------------------------------------------------------------
set diffopt=filler
set diffopt+=vertical
set diffopt+=context:3

"--------------------------------------------------------------
" GUI Specific Settings
"--------------------------------------------------------------
if has("gui_running")
" WindowSize {
    set lines=999
    set columns=999
"}
" GUI options {
    set guioptions=c                        " use console dialogs
    set guioptions+=e                       " use gui tabs
    set guioptions+=m                       " menubar is present
    set guioptions+=g                       " greyout inactive menuitems
    set guioptions+=r                       " righthand scrollbar is always present
    set guioptions+=L                       " for vsplits lefthand scrollbar is present
    set guioptions+=T                       " include toolbar
"}
    set mousehide                           " hide mouse when typing

    if has("unix")
        set guifont=Monospace\ 09           " preferred font font for Linux
    else
        set guifont=Ms\ Gothic:h10          " preferred font for Windows
    endif
endif

"--------------------------------------------------------------
" Dictionary & Spell Checking
"- -------------------------------------------------------------
set spelllang=en                            " set spell language to English
set nospell                                 " no spell checking by default
set dictionary+=/usr/share/dict/words       " set the dictionary file

"--------------------------------------------------------------
" Settings related to external plugins
"--------------------------------------------------------------
" TagList Settings {
map <silent> <right> :Tlist<CR>
let Tlist_Auto_Open            = 0       " let the tag list open automatically
let Tlist_Compact_Format       = 1       " show small menu
let Tlist_Ctags_Cmd            = 'ctags' " location of ctags
let Tlist_Enable_Fold_Column   = 0       " do not show column folding
let Tlist_Exist_OnlyWindow     = 1       " if you are the last, kill yourself
let Tlist_File_Fold_Auto_Close = 0       " fold closed other trees
let Tlist_Sort_Type            = "name"  " order by name
let Tlist_Use_Right_Window     = 1       " split to the right side of the screen
let Tlist_WinWidth             = 40      " Taglist window 40 columns wide
"}

" BufferExplorer mappings {
nnoremap <silent> <F12> :BufExplorer<CR>
"}

" MiniBufExpl Colors {
map <Leader>t :TMiniBufExplorer<cr>

hi MBEVisibleActive guifg=#A6DB29 guibg=fg
hi MBEVisibleChangedActive guifg=#F1266F guibg=fg
hi MBEVisibleChanged guifg=#F1266F guibg=fg
hi MBEVisibleNormal guifg=#5DC2D6 guibg=fg
hi MBEChanged guifg=#CD5907 guibg=fg
hi MBENormal guifg=#808080 guibg=fg
" }

" NerdCommenter Settings {
let g:NERDSpaceDelims       = 1
let g:NERDRemoveExtraSpaces = 1
"}

" Nerdtree settings {
map <silent> <left> :NERDTreeToggle<CR>
let g:NERDTreeShowBookmarks = 1
let g:NERDTreeIgnore        = ['\.o$', '\.a$', '\.so$', '\.dpkg$', '\.rpm$', '\.obj$', '\.exe$', '\.d$','\.swp$', '\.git$', '\~$']
"}

" MRU {
let MRU_Window_Height = 8
nnoremap <silent> <C-CR>   :MRU<CR>
"}

" AutoCompletionPopup {
let g:acp_enableAtStartup = 0                       " disable acp at startup
nnoremap <silent> <Leader>ae      :AcpEnable<CR>
nnoremap <silent> <Leader>ad      :AcpDisable<CR>
"}

" YankRing Settings {
nnoremap <silent> <F11>     :YRShow<CR>
let g:yankring_max_history  = 100
let g:yankring_history_dir  = '$HOME'
let g:yankring_history_file = '.yankring_history'

" Don't let yankring use f, t, /. It doesn't record them properly in macros
" and that's my most common use. Yankring also blocks macros of macros (it
" prompts for the macro register), but removing @ doesn't fix that :(
let g:yankring_zap_keys = 'f F t T / ?'
"}

" FuzzyFinder Settings {
let g:fuf_file_exclude      = '\v\~$|\.(o|exe|dll|obj|d|swp)$|/test/data\.|(^|[/\\])\.(svn|hg|git|bzr)($|[/\\])'
let g:fuf_splitPathMatching = 0
let g:fuf_maxMenuWidth      = 120
let g:fuf_timeFormat        = ''
nmap <silent> <Leader>fv :FufFile ~/.vim/<CR>
nmap <silent> <Leader>fb :FufBuffer<CR>
nmap <silent> <Leader>ff :FufFile<CR>
nmap <silent> <Leader>fd :FufDir<CR>
"}

" EasyGrep Settings {
let g:EasyGrepWindowPosition = "botright"
"}

" SuperTab Settings {
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabNoCompleteBefore      = []
let g:SuperTabNoCompleteAfter       = [',', ';', ':', '{', '}', '(', ')', '[', ']', '<', '>', '\s']
"}

" BuffKill Plugin {
nmap <silent> <Leader>bd :BD<cr>
" }

" FontSize Plugin {
  nmap <silent> <Leader>=  <Plug>FontsizeBegin
  nmap <silent> <Leader>+  <Plug>FontsizeInc
  nmap <silent> <Leader>-  <Plug>FontsizeDec
  nmap <silent> <Leader>0  <Plug>FontsizeDefault
" }

" Auto-Pairs Plugin {
let g:AutoPairsMapCR = 0        " enabling this gives 2 CRs at a single press.
" }

" Doxygen Toolkit Plugin {
let g:load_doxygen_syntax = 1                           " load doxygen syntax by default
nmap <silent> <Leader>do    :Dox<CR>

let g:DoxygenToolkit_blockHeader="***************************************************************************"
let g:DoxygenToolkit_paramTag_pre = "@param[in, out] "
let g:DoxygenToolkit_returnTag = "@retval "
" }

" OmniCppComplete {
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview
"}

" indent guides {
let g:indent_guides_guide_size=1
" }

"--------------------------------------------------------------
" Functions
"--------------------------------------------------------------
" Set a nicer foldtext function
function! MyFoldText()
    " for now, just don't try if version isn't 7 or higher
    if v:version < 701
        return foldtext()
    endif
    " clear fold from fillchars to set it up the way we want later
    let &l:fillchars = substitute(&l:fillchars,',\?fold:.','','gi')
    let l:numwidth = (v:version < 701 ? 8 : &numberwidth)
    if &fdm=='diff'
        let l:linetext=''
        let l:foldtext='---------- '.(v:foldend-v:foldstart+1).' lines the same ----------'
        let l:align = winwidth(0)-&foldcolumn-(&nu ? Max(strlen(line('$'))+1, l:numwidth) : 0)
        let l:align = (l:align / 2) + (strlen(l:foldtext)/2)
        " note trailing space on next line
        setlocal fillchars+=fold:\ 
    elseif !exists('b:foldpat') || b:foldpat==0
        let l:foldtext = ' '.(v:foldend-v:foldstart).' lines folded'.v:folddashes.'|'
        let l:endofline = (&textwidth>0 ? &textwidth : 80)
        let l:linetext = strpart(getline(v:foldstart),0,l:endofline-strlen(l:foldtext))
        let l:align = l:endofline-strlen(l:linetext)
        setlocal fillchars+=fold:-
    elseif b:foldpat==1
        let l:align = winwidth(0)-&foldcolumn-(&nu ? Max(strlen(line('$'))+1, l:numwidth) : 0)
        let l:foldtext = ' '.v:folddashes
        let l:linetext = substitute(getline(v:foldstart),'\s\+$','','')
        let l:linetext .= ' ---'.(v:foldend-v:foldstart-1).' lines--- '
        let l:linetext .= substitute(getline(v:foldend),'^\s\+','','')
        let l:linetext = strpart(l:linetext,0,l:align-strlen(l:foldtext))
        let l:align -= strlen(l:linetext)
        setlocal fillchars+=fold:-
    endif
    return printf('%s%*s', l:linetext, l:align, l:foldtext)
endfunction

" Converts to title case
function! TitleCase()
    let modLine = substitute(getline("."), "\\w\\+", "\\u\\0", "g")
    call setline(line("."), modLine)
endfunction

" QuickFix window toggling function {
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

let g:jah_Quickfix_Win_Height = 10          " setting qfix window height
"}

" Append modeline after last line in buffer.
function! AppendModeline()
    let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d :", &tabstop, &shiftwidth, &textwidth)
    let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
    call append(line("$"), l:modeline)
endfunction

" Diffs with the saved file
function! DiffWithFileFromDisk()
    let filename = expand('%')
    let diffname = filename . '.fileFromBuffer'
    exec 'saveas! ' . diffname
    diffthis
    vsplit
    exec 'edit ' . filename
    diffthis
endfunction

" FileType Settings functions {
" TextFiles only settings
function! TextFilesOnlySettings()
    setlocal tabstop=2              " number of spaces that a tab counts for
    setlocal shiftwidth=2           " number of spaces to be used in each step of indent
    setlocal softtabstop=2          " number of spaces that a tab counts for while editing
    setlocal foldmethod=indent      " fold on indent level
endfunction

" BeckyMails only settings
function! BeckyMailsOnlySettings()
    setlocal tabstop=2              " number of spaces that a tab counts for
    setlocal shiftwidth=2           " number of spaces to be used in each step of indent
    setlocal softtabstop=2          " number of spaces that a tab counts for while editing
    setlocal foldmethod=indent      " fold on indent level
    setlocal colorcolumn=75         " color column for beckymails
    setlocal textwidth=74           " textwidth for beckymails
endfunction

" Shell Files only setlocaltings
function! SHFilesOnlySettings()
    setlocal tabstop=4              " number of spaces that a tab counts for
    setlocal noexpandtab            " don't use spaces to insert a tab since it falis for HERE docs
endfunction

" C Files only setlocaltings
function! CFilesOnlySettings()
    setlocal tabstop=4              " number of spaces that a tab counts for
    setlocal expandtab              " use spaces to insert a tab
    setlocal shiftwidth=4           " number of spaces to be used in each step of indent
    setlocal softtabstop=4          " number of spaces that a tab counts for while editing
endfunction
"}

" Ruby Files only setlocaltings
function! RubyFilesOnlySettings()
    setlocal tabstop=2              " number of spaces that a tab counts for
    setlocal shiftwidth=2           " number of spaces to be used in each step of indent
    setlocal softtabstop=2          " number of spaces that a tab counts for while editing
    setlocal foldmethod=indent      " fold on indent level
endfunction

" function to format XML text
function! DoFormatXML() range
    " Save the file type
    let l:origft = &ft

    " Clean the file type
    set ft=

    " Add fake initial tag (so we can process multiple top-level elements)
    exe ":let l:beforeFirstLine=" . a:firstline . "-1"
    if l:beforeFirstLine < 0
        let l:beforeFirstLine=0
    endif
    exe a:lastline . "put ='</PrettyXML>'"
    exe l:beforeFirstLine . "put ='<PrettyXML>'"
    exe ":let l:newLastLine=" . a:lastline . "+2"
    if l:newLastLine > line('$')
        let l:newLastLine=line('$')
    endif

    " Remove XML header
    exe ":" . a:firstline . "," . a:lastline . "s/<\?xml\\_.*\?>\\_s*//e"

    " Recalculate last line of the edited code
    let l:newLastLine=search('</PrettyXML>')

    " Execute external formatter
    exe ":silent " . a:firstline . "," . l:newLastLine . "!xmllint --noblanks --format --recover -"

    " Recalculate first and last lines of the edited code
    let l:newFirstLine=search('<PrettyXML>')
    let l:newLastLine=search('</PrettyXML>')

    " Get inner range
    let l:innerFirstLine=l:newFirstLine+1
    let l:innerLastLine=l:newLastLine-1

    " Remove extra unnecessary indentation
    exe ":silent " . l:innerFirstLine . "," . l:innerLastLine "s/^  //e"

    " Remove fake tag
    exe l:newLastLine . "d"
    exe l:newFirstLine . "d"

    " Put the cursor at the first line of the edited code
    exe ":" . l:newFirstLine

    " Restore the file type
    exe "set ft=" . l:origft
endfunction
command! -range=% FormatXML <line1>,<line2>call DoFormatXML()

nmap <silent> <leader>x :%FormatXML<CR>
vmap <silent> <leader>x :FormatXML<CR>

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

"--------------------------------------------------------------
" FileTypes
"--------------------------------------------------------------
augroup personal_txt_file_settings
    au!
    autocmd BufNewFile,BufRead *.txt,*.notes      setlocal filetype=text           " set filetype to TEXT
    autocmd BufNewFile,BufRead *.txt,*.notes      setlocal syntax=txt              " recognize *.txt files as txt files
    autocmd BufNewFile,BufRead *.txt,*.notes      :call TextFilesOnlySettings()    " text files only settins
augroup END

augroup personal_bash_file_settings
    au!
    autocmd Filetype sh        :call SHFilesOnlySettings()  " bash files only settings
augroup END

augroup personal_c_file_settings
    au!
    autocmd BufNewFile,BufRead *.c,*.cpp,*.cxx,*.h      :call CFilesOnlySettings()   " C files only settings
augroup END

augroup personal_ruby_file_settings
    au!
    autocmd BufNewFile,BufRead *.rb,*erb     :call RubyFilesOnlySettings() " Ruby files only settings
    autocmd Filetype ruby                    :call RubyFilesOnlySettings() " Ruby files only settings
augroup END

augroup personal_becky_file_settings
    au!
    if has("win32") || has("win64")
        autocmd BufNewFile,BufRead *.tmp     setlocal filetype=beckymail    " set filetype to BECKYMAIL
        autocmd BufNewFile,BufRead *.tmp     setlocal syntax=beckymail      " recoginize .tmp files as Beckymails
        autocmd BufNewFile,BufRead *.tmp     :call BeckyMailsOnlySettings() " beckymail files only settings
    endif
augroup END

augroup personal_qmake_file_settings
    au!
    autocmd BufNewFile,BufRead *.pro setlocal filetype=QT_PROJECT_FILE
    autocmd BufNewFile,BufRead *.pro setlocal syntax=make
augroup END

"--------------------------------------------------------------
" Personal Mappings
"--------------------------------------------------------------
" Fast saving {
nmap <Leader>w :w!<CR><CR>
" }
" Fast editing of the .vimrc/.gvimrc {
map <Leader>v :e! $HOME/.vimrc<CR>
map <Leader>vg :e! $HOME/.gvimrc<CR>

map <Leader>t :e! $HOME/.tmux.conf<CR>
" }
" When .vimrc/.gvimrc is edited, reload it {
autocmd! BufWritePost .vimrc source $HOME/.vimrc
autocmd! BufWritePost .gvimrc source $HOME/.gvimrc
" }
" nohlsearch, after a search {
nnoremap <silent> <Space> :nohlsearch<CR>
"}
" buffer traversal {
nnoremap <silent> <C-k> :bn<CR>
nnoremap <silent> <C-j> :bp<CR>
"}
" retain visual selection after indentation {
vnoremap > >gv
vnoremap < <gv
" }

" vimgrep  {
" Displays a vimgrep command template
map <Leader>g :vimgrep // ../**/*.<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
" Search the current file for the word under the cursor and display matches
nmap <silent> <Leader>gw :vimgrep /<C-r><C-w>/ %<CR>:cclose<CR>:cwindow<CR><C-W>J:nohlsearch<CR>
" }
" force encoding conversion {
map <silent> <Leader>e :e! ++enc=euc-jp<CR>
map <silent> <Leader>u :e! ++enc=utf-8<CR>
" }

" changes directory to the directory of the current buffer {
nmap <silent> <Leader>cd :lcd %:h<CR>:pwd<CR>
"}

" Heading {
noremap <silent> <Leader>h1 yyp^v$r=
noremap <silent> <Leader>h2 yyp^v$r-
noremap <silent> <Leader>he <ESC>070i=<ESC>
noremap <silent> <Leader>hh <ESC>070i-<ESC>
noremap <silent> <Leader>hs <ESC>070i*<ESC>
"}

" Window closing commands {
" Close this window {
noremap <silent> <Leader>clw :close<CR>
"}
" Close the other window {
noremap <silent> <Leader>clj :wincmd j<CR>:close<CR>
noremap <silent> <Leader>clk :wincmd k<CR>:close<CR>
noremap <silent> <Leader>clh :wincmd h<CR>:close<CR>
noremap <silent> <Leader>cll :wincmd l<CR>:close<CR>
"}
"}

" Useful Digraphs {
" diamond(◆)
inoremap <silent> <C-l><C-d> <C-k>Db
" triangle(▲)
inoremap <silent> <C-l><C-t> <C-k>UT
" circle(●)
inoremap <silent> <C-l><C-r> <C-k>0M
" star(★)
inoremap <silent> <C-l><C-s> <C-k>*2
" alpha(α)
inoremap <silent> <C-l><C-a> <C-k>a*
" beta(β)
inoremap <silent> <C-l><C-b> <C-k>b*
" }

"--------------------------------------------------------------
" Mappings for functions
"--------------------------------------------------------------
" QuickFixWindow Toggle {
nmap <silent> <Leader>q <ESC>:QFix<CR>
"}
" Next/Previous Error in QuickFixWindow {
nmap <silent> <F3> <ESC>:cnext<CR>
nmap <silent> <S-F3> <ESC>:cprevious<CR>
" }
" Append a modeline {
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
"}
" Diffs with the original file from disk {
nnoremap <silent> <F7>   :call DiffWithFileFromDisk()<CR>
"}
" Space-Tab conversion {
nmap <silent> <Leader>ta <ESC>:Space2Tab<CR>
nmap <silent> <Leader>sp <ESC>:Tab2Space<CR>
" }
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim: set ts=4 sw=4 tw=100 :
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
