"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Configuration File
" Author: Amila Perera
" File Name: .gvimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set visualbell t_vb=                        "no beep, no flash

"Display a different cursor color in IME mode {
if has('multi_byte_ime') || has('xim')
  highlight CursorIM guibg=Purple guifg=NONE
  set iminsert=0 imsearch=0
endif
"}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim: set ts=4 sw=4 tw=100 :
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
