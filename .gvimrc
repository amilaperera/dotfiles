"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Graphical Vim Configuration File
" Author: Amila Perera
" File Name: .gvimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('gui_running')
  set visualbell t_vb= "no beep, no flash

  " setting colorscheme"
  let s:myFavouriteGuiColorScheme = "xoria256"
  set background=dark
  execute "colorscheme " . s:myFavouriteGuiColorScheme

  " maximize window
  set lines=999
  set columns=999

  set mousehide    " hide mouse when typing

  "Display a different cursor color in IME mode
  if has('multi_byte_ime') || has('xim')
    highlight CursorIM guibg=Purple guifg=NONE
    set iminsert=0 imsearch=0
  endif
endif

" GUI options
set guioptions=c   " use console dialogs
set guioptions+=e  " use gui tabs
set guioptions+=m  " menubar is present
set guioptions+=g  " greyout inactive menuitems
set guioptions+=r  " righthand scrollbar is always present
set guioptions+=L  " for vsplits lefthand scrollbar is present
set guioptions-=T  " hide toolbar

if has('x11')
  set guifont=DejaVu\ Sans\ Mono\ 9  " preferred font font for Linux
elseif has('gui_win32')
  set guifont=Consolas:h9       " preferred font for Windows
endif
