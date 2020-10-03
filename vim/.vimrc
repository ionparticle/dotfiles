" Use :help <option> to see documentation on the option, might need to
" surround <option> with '' for some of them, e.g.: ":help 'backspace'"

" disable vi compatibility
set nocompatible

" Vim-Plug - Plugin Manager
" ------
" Switching from Vundle for plugin management as it's encountering maintenance
" issues, vim-plug is very similar.

" Auto install vim-plug if needed, I do miss vundle's self updater
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" linter
Plug 'w0rp/ale'

" checks if plugins are outdated, displays a message below the status bar
Plug 'semanser/vim-outdated-plugins'

"""""""" Vim Airline """"""""
" for git integration in vim-airline
Plug 'tpope/vim-fugitive'
" show git diff in vim's sign column
Plug 'airblade/vim-gitgutter'

" fancy status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"""""""" Syntax Highlighting """"""""
" openscad syntax highlighting
Plug 'sirtaj/vim-openscad', {'for': 'openscad'}
" python requirement files, on-demand loading specified by 'for'
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}
" vue component syntax highlighting
Plug 'posva/vim-vue', {'for': 'vue'}
" laravel blade templates
Plug 'jwalton512/vim-blade'

"""""""" Indentation """"""""
" fix multi-line indent inside brackets defaulting to 2 levels, would prefer 1
Plug 'Vimjas/vim-python-pep8-indent', {'for': 'python'}

"""""""" Colorscheme """"""""
" customized vim-one
Plug 'ionparticle/vim-one'
" Plug 'rakr/vim-one'
" Plug 'caglartoklu/bridle.vim'
" Plug 'ku-s-h/summerfruit256.vim'

" Initialize plugin system
call plug#end()

" Commented out to note that both lines following are enabled by vim-plug
"filetype plugin indent on " enable filetype detection for indent/highlighting
"syntax enable " enable syntax highlighting

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
"  Always enable the gitgutter
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
	" set columns, used to have a dynamic column size that calculates how
	" large the gutter ends up being, but there's some annoying edge cases
	" that it didn't handle, and most of the time, it ends up being around 90
	" anyways so might as well just use the static value
	set columns=90
else
	" defer redraws till after command completed, should improve speed
	set lazyredraw
	" indicate fast terminal connection, should improve redraw smoothness
	set ttyfast
endif


" Theme
" -----
"  Enable true color support, from vim-one readme
if (empty($TMUX))
	if (has("termguicolors"))
		set termguicolors
	endif
endif

colorscheme one
set background=light

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
" highlight the column 80
set colorcolumn=80


" Indents
" ----
" I give up, the spaces people are right, use spaces for indents
set expandtab
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
	\ 'javascript': ['eslint'],
	\ 'html': ['tidy'],
	\ 'python': ['flake8'],
	\ 'php': ['phpmd']
\}
" let g:ale_fixers = {'javascript': ['standard']}
let g:ale_lint_on_save = 1
" not trusting automatic fixes
let g:ale_fix_on_save = 0
" disable flake8 errors
" E2 whitespace issues (not including indents)
" E302 expect 2 blank lines after defs
" E501 line too long
let g:ale_python_flake8_options = '--extend-ignore=E2,E501'
