set debuginfod enabled on

# general
set print pretty on
set print array on
set print object on
set print static-members on
set print vtbl on
set print demangle on
set demangle-style gnu-v3
set print sevenbit-strings off

# history
set history save on
set history remove-duplicates 0
set history size 1000
set history expansion on

# aliases
alias sb = save breakpoints .break_points
alias ssb = source .break_points

