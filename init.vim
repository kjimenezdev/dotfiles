" General: Notes
"
" Author: Samuel Roeca
" Date: August 15, 2017
" TLDR: vimrc minimum viable product for Python programming
"
" I've noticed that many vim/neovim beginners have trouble creating a useful
" vimrc. This file is intended to get a Python programmer who is new to vim
" set up with a vimrc that will enable the following:
"   1. Sane editing of Python files
"   2. Sane defaults for vim itself
"   3. An organizational skeleton that can be easily extended
"
" Notes:
"   * When in normal mode, scroll over a folded section and type 'za'
"       this toggles the folded section
"
" Initialization:
"   1. Follow instructions at https://github.com/junegunn/vim-plug to install
"      vim-plug for either Vim or Neovim
"   2. Open vim (hint: type vim at command line and press enter :p)
"   3. :PlugInstall
"   4. :PlugUpdate
"   5. You should be ready for MVP editing
"
" Updating:
"   If you want to upgrade your vim plugins to latest version
"     :PlugUpdate
"   If you want to upgrade vim-plug itself
"     :PlugUpgrade
" General: Leader mappings -------------------- {{{

let mapleader = ","
let maplocalleader = "\\"

" }}}
" General: global config ------------ {{{

"A comma separated list of options for Insert mode completion
"   menuone  Use the popup menu also when there is only one match.
"            Useful when there is additional information about the
"            match, e.g., what file it comes from.

"   longest  Only insert the longest common text of the matches.  If
"            the menu is displayed you can use CTRL-L to add more
"            characters.  Whether case is ignored depends on the kind
"            of completion.  For buffer text the 'ignorecase' option is
"            used.

"   preview  Show extra information about the currently selected
"            completion in the preview window.  Only works in
"            combination with 'menu' or 'menuone'.
set completeopt=menuone,longest,preview

" Enable buffer deletion instead of having to write each buffer
set hidden

" Mouse: enable GUI mouse support in all modes
set mouse=a

" SwapFiles: prevent creation
set nobackup
set noswapfile

" Avoid wrapping lines
set nowrap

" Set column to light grey at 80 characters
if (exists('+colorcolumn'))
  set colorcolumn=80
  highlight ColorColumn ctermbg=9
endif

" Remove query for terminal version
" This prevents un-editable garbage characters from being printed
" after the 80 character highlight line
set t_RV=

filetype plugin indent on

set spelllang=en_us

set showtabline=2

set autoread

" When you type the first tab hit will complete as much as possible,
" the second tab hit will provide a list, the third and subsequent tabs
" will cycle through completion options so you can complete the file
" without further keys
set wildmode=longest,list,full
set wildmenu

" Turn off complete vi compatibility
set nocompatible

" Enable using local vimrc
set exrc

" Make sure numbering is set
set number

" Split settings (splitright , split below
set splitright

" Avoid using set paste
set pastetoggle=<c-_>

" Make terminal zsh
set shell=/user/bin/zsh

" Redraw window whenever I've regained focus
augroup redraw_on_refocus
  au FocusGained * :redraw!
augroup END

" Useful copy and paste mappings
" vmap <C-c> "+yi
" vmap <C-x> "+c
" vmap <C-v> c<ESC>"+p
" imap <C-v> <ESC>"+pa
"

" }}}
" General: Plugin Install --------------------- {{{

call plug#begin('~/.vim/plugged')

" Commands run in vim's virtual screen and don't pollute main shell
Plug 'fcpg/vim-altscreen'

" Basic coloring
Plug 'itchyny/lightline.vim'
Plug 'NLKNguyen/papercolor-theme'

" Utils
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'myusuf3/numbers.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'christoomey/vim-system-copy'
Plug 'mhinz/vim-startify'
Plug 'terryma/vim-multiple-cursors'

" Language-specific syntax
Plug 'hdima/python-syntax'

" Extensions for markdown
Plug 'majutsushi/tagbar'
Plug 'lvht/tagbar-markdown'

" Indentation
Plug 'hynek/vim-python-pep8-indent'

" NerdTree
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Preview
Plug 'tyru/open-browser.vim'

" Autocompletion
Plug 'davidhalter/jedi-vim'
Plug 'mxw/vim-jsx'
Plug 'sukima/xmledit'
Plug 'alvan/vim-closetag'


call plug#end()

" }}}
" General: Filetype specification ---------- {{{

augroup filetype_recognition
  autocmd!
  autocmd BufNewFile,BufRead,BufEnter *.jsx set filetype=javascript.jsx
augroup END


" }}}
" General: Indentation (tabs, spaces, width, etc)------------- {{{

augroup indentation_sr
  autocmd!
  autocmd Filetype * setlocal expandtab shiftwidth=2 softtabstop=2 tabstop=8
  autocmd Filetype python setlocal shiftwidth=4 softtabstop=4 tabstop=8
  autocmd Filetype yaml setlocal indentkeys-=<:>
  autocmd Filetype make setlocal tabstop=4 softtabstop=0 shiftwidth=4 noexpandtab

augroup END

" }}}
" General: Folding Settings --------------- {{{

augroup fold_settings
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType vim setlocal foldlevelstart=0
  autocmd FileType * setlocal foldnestmax=1
augroup END

" Set folding settings
" set foldmethod=indent
" set foldlevel=99

" }}}
" General: Trailing whitespace ------------- {{{

" This section should go before syntax highlighting
" because autocommands must be declared before syntax library is loaded
function! TrimWhitespace()
  if &ft == 'markdown'
    return
  endif
  let l:save = winsaveview()
  %s/\s\+$//e
  call winrestview(l:save)
endfunction

highlight EOLWS ctermbg=red guibg=red
match EOLWS /\s\+$/
augroup whitespace_color
  autocmd!
  autocmd ColorScheme * highlight EOLWS ctermbg=red guibg=red
  autocmd InsertEnter * highlight EOLWS NONE
  autocmd InsertLeave * highlight EOLWS ctermbg=red guibg=red
augroup END

augroup fix_whitespace_save
  autocmd!
  autocmd BufWritePre * call TrimWhitespace()
augroup END

" Avoids whitespace issues
" augroup BufRead,BufNewFile,*.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" }}}
"  Plugin: Configure ------------ {{{

" Python highlighting
let g:python_highlight_space_errors = 0
let g:python_highlight_all = 1

"  }}}
" General: Key remappings ----------------------- {{{

" Put your key remappings here
" Prefer nnoremap to nmap, inoremap to imap, and vnoremap to vmap

" inoremap " ""<left>
" inoremap ' ''<left>
" inoremap ( ()<left>
" inoremap [ []<left>
" inoremap { {}<left>
" inoremap {<CR> {<CR>}<ESC>O
" inoremap {;<CR> {<CR>};<ESC>O

" inoremap <BS>'b
" create a mapping to erase the whole '' when erase one '
" create a mapping to erase add the '' surround a word to 'string' it

" Save: allows saving easily
:nnoremap <c-s> <esc>:w<CR>

" No Highlight: allows to execute the :noh command with a key binding
:nnoremap <c-n> <esc>:noh<CR>

" Escape also clear highlighting
:nnoremap <silent><esc> :noh<CR>

" Folding: enable folding with the spacebar
nnoremap <space> za

" MovePanes: moving easily through vim panes
:nnoremap <c-j> <c-w>j
:nnoremap <c-h> <c-w>h
:nnoremap <c-k> <c-w>k
:nnoremap <c-l> <c-w>l

" MoveTabs: moving forward, backward, and to number with vim tabs
" nnoremap <silent> L gt
" nnoremap <silent> H gT
" nnoremap <A-1> 1gt
" nnoremap <A-2> 2gt
" nnoremap <A-3> 3gt
" nnoremap <A-4> 4gt
" nnoremap <A-5> 5gt
" nnoremap <A-6> 6gt
" nnoremap <A-7> 7gt
" nnoremap <A-8> 8gt
" nnoremap <A-9> 9gt

" ToggleRelativeNumber: uses custom functions
nnoremap <silent><leader>r :NumbersToggle<CR>

" TogglePluginWindows:
nnoremap <silent> <space>j :NERDTreeToggle<CR>
nnoremap <silent> <space>J :call NERDTreeToggleCustom()<CR>
nnoremap <silent> <space>l :TagbarToggle <CR>
nnoremap <silent> <space>u :UndotreeToggle

" Exiting: allows to get out from files easily
nnoremap <c-q> <esc>:q<CR>
nnoremap <c-w> <esc>:wq<CR>

" Multiline Editing: shortcut to allow editing multiple lines at once
nnoremap <c-t> <esc>vip<c-n>i


" }}}
" General: Cleanup ------------------ {{{
" commands that need to run at the end of my vimrc

" disable unsafe commands in your project-specific .vimrc files
" This will prevent :autocmd, shell and write commands from being
" run inside project-specific .vimrc files unless they’re owned by you.
set secure

" ShowCommand: turn off character printing to vim status line
set noshowcmd

" }}}
"  Plugin: Startify ------------- {{{

let g:startify_list_order = []
let g:startify_fortune_use_unicode = 1
let g:startify_enable_special = 1
let g:startify_custom_header = []
let g:startify_custom_footer = [
      \' _                                _',
      \'| | __ ___  _ __  _ __  __ _   __| |',
      \'| |/ / _ \ |    \| __/ /  ` | / _` |',
      \'|   < (_)  | | | | |  | (_| || (_| |',
      \'|_|\_\___/ |_| |_|_|   \__,_| \__,_|',
      \'',
      \] + map(startify#fortune#boxed(), {idx, val -> '$$$ ' . val})

"  }}}
"  Plugin: Vim CloseTag   ------------- {{{

" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml, *.jsx'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
"
let g:closetag_filetypes = 'html,xhtml,phtml,jsx'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
"
let g:closetag_xhtml_filetypes = 'xhtml,jsx'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
"
let g:closetag_emptyTags_caseSensitive = 1

" Shortcut for closing tags, default is '>'
"
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
"
let g:closetag_close_shortcut = '<leader>>'

"  }}}
