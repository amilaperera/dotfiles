# general
# set debuginfod enabled on

set print pretty on
set print array on
set print object on
set print static-members on
set print vtbl on
set print demangle on
set demangle-style gnu-v3
set print sevenbit-strings off

show print pretty
show print array
show print object

# history
set history save on
set history remove-duplicates 0
set history size 1000
set history expansion on

define savebps
    save breakpoints .gdb_bps
end

define loadbps
    source .gdb_bps
end

