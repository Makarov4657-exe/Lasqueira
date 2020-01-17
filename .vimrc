" to remove a set option prepend 'no' to the option
" use VIM config instead of VI
set nocompatible
syntax enable
filetype plugin on
let mapleader = " "
set background=dark
colorscheme snazzy
set autoread

" ===== FUNCTIONS
function! FoldConfig()
	let line = getline(v:lnum)
	if match(line, '^[#"!]\s=') > -1
		return ">1"
	else
		return "="
	endif
endfunction
function! TextFold()
	let foldSize = (v:foldend-v:foldstart)
	return getline(v:foldstart).' ('.foldSize.' lines)'
endfunction
function! s:Marks()
	marks abcdefghijklmnopqrstuvwxyz.
	echo "\nJump to mark: "
	let mark_char = nr2char(getchar())
	redraw
	if match(mark_char, '\w') > -1
		execute 'normal! `' . mark_char
	endif
endfunction
function! s:Regs()
	reg abcdefghijklmnopqrstuvwxyz1234567890
	echo "\nPaste register: "
	let reg_char = nr2char(getchar())
	redraw
	if match(reg_char, '\w') > -1
		execute 'normal! "' . reg_char . 'p=`]'
	endif
endfunction

" ===== AUTOCMDS
" highlight merge conflict markers
au VimEnter,WinEnter * if !exists('w:_vsc_conflict_marker_match') |
	\   let w:_vsc_conflict_marker_match = matchadd('ErrorMsg', '^\(<\|=\||\|>\)\{7\}\([^=].\+\)\?$') |
\ endif
autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %
autocmd BufEnter *.c setlocal foldmethod=syntax
autocmd FileType vim,sh,xdefaults,conf,tmux setlocal foldmethod=expr foldexpr=FoldConfig() foldtext=TextFold() foldlevel=0 foldenable
" update file in real-time
autocmd CursorHold,CursorHoldI,FocusGained,BufEnter * :silent! checktime
" create aliases for functions
command! Marks call s:Marks()
command! Regs call s:Regs()

" ===== SETS
set number
set numberwidth=4
set relativenumber
" search
set hlsearch
set ignorecase
set incsearch
" show typed cmd
set showcmd
set autoindent
set encoding=UTF-8
" set history change
set undodir=~/.vim/undodir
set undofile
" highlight current line
set nocursorline
" draw screen config
set lazyredraw
set redrawtime=10000
" tab config
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
" show matching curly, paren or bracket
set showmatch
set splitbelow splitright
" :find [file]
set path+=**
" show nice menu on command mode
set wildmenu
" show tabs and spaces
set list
set listchars=tab:▸\ ,trail:•
" complete
set omnifunc=syntaxcomplete#Complete
set completeopt=menu,longest
set complete=.,w,b,u,t,i
" fold
"set foldmethod=syntax
set nofoldenable
set foldlevel=2
" remove esc delay
set timeoutlen=1000 ttimeoutlen=0
" fix backspace
set backspace=indent,eol,start
set backspace=2
set tags=tags,.tags;
" remove backup and swap files
set nobackup
set nowritebackup
set noswapfile
" better colors and cursor
set t_Co=256
set guicursor=
if &t_Co >= 256 || has("gui_running")
	let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
	if (has("termguicolors"))
		set termguicolors
	endif
endif
" better diff
set diffopt=vertical,filler,foldcolumn:1
if has('nvim-0.3.2') || has("patch-8.1.0360")
	set diffopt+=internal,algorithm:patience,indent-heuristic
endif
" html indent
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"
" PHP Generated Code Highlights (HTML & SQL)
let php_sql_query=1
let php_htmlInStrings=1

" ===== HIGHLIGHTS
autocmd BufEnter * setlocal notermguicolors
autocmd BufEnter *.css setlocal termguicolors | AirlineRefresh
hi Pmenu ctermfg=white ctermbg=darkgrey guifg=white guibg=darkgrey
hi Pmenusel ctermfg=black ctermbg=white guifg=black guibg=white
" hi CursorLine ctermfg=white ctermbg=darkred guifg=white guibg=darkred
hi SpecialKey ctermfg=darkgrey guifg=darkgrey
" highlight whitespaces
" hi ExtraWhitespace ctermbg=red guibg=red
" match ExtraWhitespace /\s\+$/

" transparent bg
	hi! Normal ctermbg=NONE guibg=NONE
	hi! NonText ctermbg=NONE guibg=NONE
	hi! LineNr ctermbg=NONE guibg=NONE
	hi! CursorLineNr ctermbg=NONE guibg=NONE
	" hi! Folded guibg=NONE ctermbg=NONE ctermfg=white guifg=#ffffff
	set nocursorline
    set notermguicolors

" ===== MAPS
nnoremap <leader>p :!git --work-tree=/home/coaching/Documentos/plataforma --git-dir=/home/coaching/Documentos/plataforma/.git debug <CR>
" compile C
noremap <leader>cc :w<CR>:!clear && gcc % -lm && time ./a.out && rm a.out<CR>
" compile C++
noremap <leader>cC :w<CR>:!clear && g++ % && time ./a.out && rm a.out<CR>
" compile Php
noremap <leader>cp :w<CR>:!clear && time php %<CR>
" compile Bash
noremap <leader>cb :w<CR>:!clear && chmod +x % && ./%<CR>
" map Marks
nnoremap <leader>M :Marks<CR>
" map Regs
nnoremap <leader>R :Regs<CR>
" fix pasting
nnoremap p p=`]
" jump to next character
inoremap <C-c> <C-o>a
" move cursor in insert mode
" inoremap <C-l> <Right>
" inoremap <C-k> <Up>
" inoremap <C-j> <Down>
" unmap K (display man of current word)
nnoremap K <Nop>
" remove highlight last search
noremap <silent> ,<leader> :nohls<CR>
" get changes of the current file
noremap <leader>cd :w !diff % -<CR>
" source .vimrc
nnoremap <leader>r :w<CR>:source ~/.vimrc<CR>:AirlineRefresh<CR>:nohls<CR>:e!<CR>
" navigate diffs
" resize splits with arrow keys
nnoremap <silent> <Right> <C-W>3>
nnoremap <silent> <Left> <C-W>3<
nnoremap <silent> <expr> <Up> &diff ? '[czz' : ':resize +3<CR>'
nnoremap <silent> <expr> <Down> &diff ? ']czz' : ':resize -3<CR>'
" move correctly in wrapped lines
nnoremap j gj
nnoremap k gk
" tab navigation
nnoremap tn :tabnew<Space>
nnoremap tk :tabnext<CR>
nnoremap tj :tabprev<CR>
nnoremap tl :tablast<CR>
nnoremap th :tabfirst<CR>
nnoremap tK :tabmove +1<CR>
nnoremap tJ :tabmove -1<CR>
nnoremap tL :tabmove +2<CR>
nnoremap tH :tabmove -2<CR>
" split screen navigation
nnoremap gh :sp<Space>
nnoremap gv :vs<Space>
nnoremap <C-h> <C-w>h
noremap <expr> <C-j> &diff ? ']czz' : '<C-w>j'
noremap <expr> <C-k> &diff ? '[czz' : '<C-w>k'
nnoremap <C-l> <C-w>l
" multiple cursors feature
nnoremap c* *Ncgn
" save and exit
nnoremap <leader>s :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>
nnoremap <leader>as :wall<CR>
nnoremap <leader>aq :qall<CR>
nnoremap <leader>aQ :qall!<CR>
" open .vimrc
nnoremap <leader>vv :e ~/.vimrc<CR>
nnoremap <leader>vt :tabnew ~/.vimrc<CR>
" preview markdown
nnoremap <leader>pm :InstantMarkdownPreview<CR>
nnoremap <leader>ue :UltiSnipsEdit<CR>
nnoremap <leader>x :!clear<CR><CR>
nnoremap <leader><leader> za
nnoremap <silent> <C-t> :TagbarToggle<CR>
nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T
nnoremap <leader>. :bn<CR>
nnoremap <leader>, :bp<CR>
nnoremap <leader>d :windo difft<CR>:windo set wrap<CR>
nnoremap <leader>D :windo diffo<CR>
" move in quickfix list
nnoremap <leader>m :cn<CR>zz
nnoremap <leader>n :cp<CR>zz
nnoremap cO :copen<CR>:set nowrap<CR>
nnoremap cC :cclose<CR>
" remove trailing whitespaces and indent
nnoremap <leader>0 gg=G:%s/\s\+$//e<CR>:nohls<CR>:w<CR>:e!<CR>
" vimwiki toggle list item
nnoremap <leader><C-x> :VimwikiToggleListItem<CR>
" disable arrow keys on insert mode
inoremap <Up>    <C-O>:<CR>
inoremap <Down>  <C-O>:<CR>
inoremap <Left>  <C-O>:<CR>
inoremap <Right> <C-O>:<CR>

" ===== PLUGINS
call plug#begin()

" ----- APPEARANCE
Plug 'rodgeroliver/vim-snazzy'
Plug 'flazz/vim-colorschemes'
Plug 'flrnprz/plastic.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/goyo.vim'

" ----- GIT
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'Xuyuanp/nerdtree-git-plugin'

" ----- FILE BROWSING AND SEARCH
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'mileszs/ack.vim'

" ----- TAGS
Plug 'majutsushi/tagbar'
Plug 'ludovicchabant/vim-gutentags'

" ----- SNIPPETS
Plug 'sirver/ultisnips'
Plug 'honza/vim-snippets'

" ----- UTILITIES
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'austintaylor/vim-commaobject'
Plug 'christoomey/vim-system-copy'
Plug 'mariappan/dragvisuals.vim'

" ----- FRONT-END
Plug 'ap/vim-css-color'
Plug 'turbio/bracey.vim'
" Plug 'othree/html5.vim'
" Plug 'mattn/emmet-vim'

" ----- PHP
Plug 'vim-vdebug/vdebug'
Plug 'shawncplus/phpcomplete.vim'
Plug 'captbaritone/better-indent-support-for-php-with-html'

" ----- SYNTAX CHECKER
Plug 'scrooloose/syntastic'

" ----- CODE COMPLETION
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" if has('nvim')
" 	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
" 	Plug 'Shougo/deoplete.nvim'
" 	Plug 'roxma/nvim-yarp'
" 	Plug 'roxma/vim-hug-neovim-rpc'
" endif
" let g:deoplete#enable_at_startup = 1

" ----- OTHER
Plug 'vimwiki/vimwiki'
Plug 'suan/vim-instant-markdown'
Plug 'godlygeek/tabular'
Plug 'terryma/vim-smooth-scroll'
" Plug 'ervandew/supertab'
" Plug 'easymotion/vim-easymotion'
" Plug 'matze/vim-move'
" Plug 'valloric/youcompleteme'
" Plug 'terryma/vim-multiple-cursors'
" Plug 'christoomey/vim-sort-motion'
" Plug 'christoomey/vim-titlecase'
" Plug 'wincent/scalpel'

call plug#end()

" ===== AIRLINE
let g:airline_powerline_fonts = 1
let g:airline_theme='cool'
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#formatter = 'unique_tail'
" function
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
" unicode symbols
let g:airline_left_sep = '>>'
"let g:airline_left_sep = '▶'
let g:airline_right_sep = '<<'
"let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'
" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = '㏑'

" ===== NERD TREE
nnoremap <C-n> :NERDTreeToggle<CR>
let g:NERDTreeIndicatorMapCustom = {
			\ "Modified"  : "✹",
			\ "Staged"    : "✚",
			\ "Untracked" : "✭",
			\ "Renamed"   : "➜",
			\ "Unmerged"  : "═",
			\ "Deleted"   : "✖",
			\ "Dirty"     : "✗",
			\ "Clean"     : "✔︎",
			\ 'Ignored'   : '☒',
			\ "Unknown"   : "?"
			\ }

" ===== GIT GUTTER
set updatetime=100

" ===== VIM INSTANT MARKDOWN
let g:instant_markdown_autostart = 0

" ===== VIM WIKI
let index = {}
let index.path = '$NOTES_PATH/remote/'
let index.syntax = 'markdown'
let index.ext = '.md'

let local_notes = {}
let local_notes.path = '$NOTES_PATH/local/'
let local_notes.syntax = 'markdown'
let local_notes.ext = '.md'

let g:vimwiki_list = [index, local_notes]
let g:vimwiki_ext2syntax = {'.wiki': 'default', '.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
" don't use wiki syntax on other .md files
" let g:vimwiki_global_ext = 0

" ===== UTILSNIPS
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<S-tab>'
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir='~/.vim/plugged/vim-snippets/UltiSnips/'
let g:UltiSnipsSnippetDirectories=["~/.vim/plugged/vim-snippets/UltiSnips/"]

" ===== CTRLP
let g:ctrlp_extensions = ['tag']

" ===== VIM-SYSTEM-COPY
let g:system_copy#copy_command='xclip -sel clipboard'

" ===== GUTENTAGS
let g:gutentags_ctags_exclude = ['*.css', '*.html', '*.js', '*.json', '*.xml',
\ '*.phar', '*.ini', '*.rst', '*.md','*/vendor/*',
\ '*vendor/*/test*', '*vendor/*/Test*',
\ '*vendor/*/fixture*', '*vendor/*/Fixture*',
\ '*var/cache*', '*var/log*']
let g:gutentags_ctags_tagfile = ".tags"
let g:gutentags_project_root = ['tags', '.tags']
let g:gutentags_add_default_project_roots = 0

" ===== SYNTASTIC
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_highlighting = 0

" Syntastic configuration for PHP
let g:syntastic_php_checkers = ['php']

" ===== DRAGVISUALS
vmap <expr>  <LEFT>   DVB_Drag('left')
vmap <expr>  <RIGHT>  DVB_Drag('right')
vmap <expr>  <DOWN>   DVB_Drag('down')
vmap <expr>  <UP>     DVB_Drag('up')
vmap <expr>  D        DVB_Duplicate()
vmap <expr>  <C-H>   DVB_Drag('left')
vmap <expr>  <C-L>  DVB_Drag('right')
vmap <expr>  <C-J>   DVB_Drag('down')
vmap <expr>  <C-K>    DVB_Drag('up')

" ===== SCROLL
noremap <silent> <C-u> :call smooth_scroll#up(&scroll, 20, 2)<CR>
noremap <silent> <C-d> :call smooth_scroll#down(&scroll, 20, 2)<CR>
noremap <silent> <C-b> :call smooth_scroll#up(&scroll*2, 10, 4)<CR>
noremap <silent> <C-f> :call smooth_scroll#down(&scroll*2, 10, 4)<CR>

" ===== VIM MOVE
" execute 'set <A-j>=\ej'
" execute 'set <A-k>=\ek'
" let g:move_key_modifier = 'C'

" ===== YCM
" let g:ycm_key_list_select_completion = ['<C-j>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']
" let g:ycm_key_list_accept_completion = ['<C-y>']

" ===== SUPERTAB
" let g:SuperTabDefaultCompletionType = '<C-x><C-n>'
" let g:SuperTabDefaultCompletionType = 'context'

" ===== VDEBUG
" let g:vdebug_options = {
" 	\ 'break_on_open': 0,
" 	\ 'server': '127.0.0.1',
" 	\ 'port': '9000',
" 	\ 'ide_key': 'netbeans-xdebug'
" 	\ }

