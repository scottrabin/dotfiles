" disable compatibility mode
set nocompatible

" Pathogen!
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

" turn plugin/indent back on
filetype plugin indent on

" enable more colors
set t_Co=256

" Syntax highlighting
syntax on
set background=dark
colorscheme solarized
" set the encoding
set encoding=utf-8
" backspace over everything
set backspace=indent,eol,start
" show line numbers
set number
" status line
highlight User9 ctermfg=LightGray ctermbg=DarkGray
set statusline=%9*\ %y\ (\ %l\ /\ %L\ ):%v\ (%P)\ %F\ %m%=%{fugitive#statusline()}\    
" always show the status line
set laststatus=2
" Show some context while scrolling (keep this many lines visible above/below
" cursor)
set scrolloff=5

" Show trailing whitespace:
autocmd InsertLeave,ColorScheme,FileType *
	\ highlight TrailingWhitespace ctermbg=darkred guibg=darkred |
	\ match TrailingWhitespace /\s\+$/

" do not highlight trailing whitespace while in insert mode (the flashing
" red highlight can get very annoying
autocmd InsertEnter * match

" pep8 4-spaces instead of tabs
autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4

" treat json as javascript for syntax highlighting
autocmd BufNewFile,BufRead *.json set ft=javascript

" Indent most of the form, even for very large ones (e.g. in tests)
let g:clojure_maxlines = 300

" Rainbow Parentheses: always on
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
let g:rbpt_colorpairs = [
			\ ['brown',       'RoyalBlue3'],
			\ ['Darkblue',    'SeaGreen3'],
			\ ['darkgray',    'DarkOrchid3'],
			\ ['darkgreen',   'firebrick3'],
			\ ['darkcyan',    'RoyalBlue3'],
			\ ['darkred',     'SeaGreen3'],
			\ ['darkmagenta', 'DarkOrchid3'],
			\ ['brown',       'firebrick3'],
			\ ['gray',        'RoyalBlue3'],
			\ ['darkmagenta', 'DarkOrchid3'],
			\ ['Darkblue',    'firebrick3'],
			\ ['darkgreen',   'RoyalBlue3'],
			\ ['darkcyan',    'SeaGreen3'],
			\ ['darkred',     'DarkOrchid3'],
			\ ]
let g:rbpt_max = len(g:rbpt_colorpairs)

" tabs
set tabstop=4     " tabs are 4 spaces wide
set softtabstop=4 " indent 4 columns (one tab) when the tab key is pressed
set shiftwidth=4  " indent/dedent columns when >> or << command is used
set smarttab      " use shiftwidth instead of tabstop when pretting Tab in front of a line
set noexpandtab   " use tabs for indentation

" search & highlight
set incsearch     " show where the currently-typed pattern matches as it is being typed
set hlsearch      " highlight all search matches
set smartcase     " if the search pattern contains uppercase characters, use case-sensitive matching
set ignorecase    " default ignore case when searching
highlight IncSearch term=reverse cterm=reverse ctermfg=3 guifg=Black guibg=Yellow

set colorcolumn=80
set textwidth=96

" change backup directory
if isdirectory($HOME . '/.vim/backup') == 0
	:silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir=~/.vim/backup//
set backup

" change swap directory
if isdirectory($HOME . '/.vim/swap') == 0
	:silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=~/.vim/swap//

" viminfo stores the state of your previous editing session
set viminfo+=n~/.vim/viminfo

" change undo directory
if exists("+undofile")
	if isdirectory($HOME . '/.vim/undo') == 0
		:silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
	endif
	set undodir=~/.vim/undo//
	set undofile
endif

" working dir: nearest ancestor dir containing .git/.hg/.svn/.bzr/_darcs
let g:ctrlp_working_path_mode = 2
let g:ctrlp_user_command = ['.git', 'git --git-dir=%s/.git ls-files -oc --exclude-standard | grep -v node_modules']

" custom functions
let mapleader = ","
let maplocalleader = "\\"

" tabs
map <leader>a :tabnew<cr>
map <leader>c :tabclose<cr>
map <leader>r :tabp<cr>
map <leader>s :tabn<cr>

" Ctrl-P
map <leader>t :CtrlP<cr>

" Change linewise up/down to rowwise up/down
nmap j gj
nmap k gk

" delimitMate customization
" insert extra space inside delimiters
let delimitMate_expand_space = 1
" insert extra CR when pressing enter on end delimiter
let delimitMate_expand_cr = 2
" allow using closing delimiters to jump to next line if possible
let delimitMate_jump_expansion = 1
" attempt to match the number of opening/closing delimiters on a line
let delimitMate_balance_matchpairs = 1
