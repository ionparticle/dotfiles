" Use :help <option> to see documentation on the option, might need to
" surround <option> with '' for some of them, e.g.: ":help 'backspace'"

" disable vi compatibility
set nocompatible


" Vundle
" ------
" required while vundle loads
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
" for git integration in vim-airline
Plugin 'tpope/vim-fugitive'
" show git diff in vim's sign column
Plugin 'airblade/vim-gitgutter'
" fancy status line
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" openscad syntax highlighting
Plugin 'sirtaj/vim-openscad'
" coffeescript syntax highlighting
Plugin 'kchmck/vim-coffee-script'
" eco templating syntax highlighting
Plugin 'AndrewRadev/vim-eco' " depends on coffeescript syntax highlighting
" vue component syntax highlighting
Plugin 'posva/vim-vue'
" linter
Plugin 'w0rp/ale'
call vundle#end()
" restore filetype detection after vundle loads, this enables file type based
" indentation and highlighting too
filetype plugin indent on

" Vim-Airline
" -----------
" vim-airline specific fix for not appearing on first load
set laststatus=2
" vim-airline disable separator symbols, don't want them since they're
" in different colored boxes anyways
let g:airline_left_sep = ''
let g:airline_right_sep = ''
" abbreviations for mode indicators, otherwise, they use the full name of the
" mode, only putting in the most common modes for now
let g:airline_mode_map = {
	\ 'n'  : 'n',
	\ 'i'  : 'i',
	\ 'v'  : 'v',
	\ 'V'  : 'V',
	\ }
" light color scheme
let g:airline_theme = 'light'
let g:airline#extensions#whitespace#symbol = '!'
" certain number of spaces are allowed after tabs, but not in between
"let g:airline#extensions#whitespace#mixed_indent_algo = 2
" formatting of white space warning messages
" shortened cause they were getting truncated
let g:airline#extensions#whitespace#trailing_format = '%s tra'
let g:airline#extensions#whitespace#mixed_indent_format = '%s mix'
let g:airline#extensions#whitespace#long_format = '%s long'
let g:airline#extensions#whitespace#mixed_indent_file_format = '%s mix'
" show ALE linter warnings in statusline
let g:airline#extensions#ale#enabled = 1

" vim-gitgutter
" -------------
"  Always enable the gitgutter, since that's taken into account when
"  calculating the column width that gvim is displaying.
if exists('&signcolumn')  " Vim 7.4.2201
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif

" GUI/Terminal Customization
" --------------------------
if has('gui_running')
	" remove toolbar
	set guioptions-=T
	" how many lines of text to show when opened, 60 lines takes up most of
	" the vertical space on a 1080p screen
	set lines=59
	" set columns to account for the width of the line numbers + gitgutter
	au BufRead,TabEnter * let &numberwidth = float2nr(log10(line("$"))) + 2
				\| let &columns = &numberwidth + 84
else
	" make vim use 256 color in terminal mode
	set t_Co=256
	" defer redraws till after command completed, should improve speed
	set lazyredraw
	" indicate fast terminal connection, should improve redraw smoothness
	set ttyfast
endif


" Theme
" -----
" Others:
" - jellybeans, for a dark theme
" Don't use:
" - summerfruit256 doesn't work well with diffs
colorscheme one
" enable syntax highlighting
syntax enable
" line number colors
highlight LineNr term=NONE cterm=NONE ctermfg=DarkGray ctermbg=NONE gui=NONE guifg=DarkGray guibg=NONE


" Editing
" -------
" if no custom indent, then indent at same level as previous line
set autoindent
" allow backspacing over autoindents, line breaks, and start of inserts
set backspace=indent,eol,start
" when searching, highlight all matching patterns
set hlsearch
" show search matches are you type it
set incsearch
" display line numbers
set number
" show highlighted area character counts
set showcmd
" when typing a bracket, briefly highlight matching bracket
set showmatch
" abbreviate and, if necessary, truncate status messages that are too long
set shortmess+=filmnrxoOtT
" disables breaking up long lines on insert
set textwidth=0
" screen wrap long lines
set wrap


" Tabs
" ----
" tabs are sized to 4 spaces, also prefer using actual tab characters
"set noexpandtab
set softtabstop=4
set shiftwidth=4
set tabstop=4


" Large Files Handling
" --------------------
" taken from http://vim.wikia.com/wiki/Faster_loading_of_large_files
" files 10mb or larger counts as a large file
let g:LargeFile = 1024 * 1024 * 10
augroup LargeFile
	autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
augroup END

function LargeFile()
	" no syntax highlighting etc
	set eventignore+=FileType
	" no line numbers
	set nonumber
	" disable vim-gitgutter
	GitGutterDisable
endfunction


" Enable ALE
let g:ale_linters = {
\   'javascript': ['standard'],
\}
let g:ale_fixers = {'javascript': ['standard']}
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
