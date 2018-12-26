" General: Notes
"
" Author: Samuel Roeca
" Maintainer: Konrad Jimenez
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
"General: Global config ------------ {{{

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

" Change line number highlight color
" highlight LineNr guibg=red

" Redraw window whenever I've regained focus
augroup redraw_on_refocus
  au FocusGained * :redraw!
augroup END

" }}}
" General: Plugin Install --------------------- {{{

call plug#begin('~/.vim/plugged')

" Commands run in vim's virtual screen and don't pollute main shell
Plug 'fcpg/vim-altscreen'

" Basic coloring
Plug 'itchyny/lightline.vim'
Plug 'ErichDonGubler/vim-sublime-monokai'
Plug 'NLKNguyen/papercolor-theme'

" Utils
Plug 'tpope/vim-commentary'
" Plug 'tpope/vim-surround'
Plug 'myusuf3/numbers.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'christoomey/vim-system-copy'
Plug 'mhinz/vim-startify'
Plug 'terryma/vim-multiple-cursors'
Plug 'simeji/winresizer'

" Language-specific syntax
Plug 'hdima/python-syntax'
Plug 'leafgarland/typescript-vim'
Plug 'magicalbanana/sql-syntax-vim'
Plug 'mxw/vim-jsx'
Plug 'sukima/xmledit'

" Extensions for markdown
Plug 'majutsushi/tagbar'
Plug 'lvht/tagbar-markdown'
Plug 'JamshedVesuna/vim-markdown-preview'

" Previewers
function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

" Indentation
Plug 'hynek/vim-python-pep8-indent'

" NerdTree
Plug 'scrooloose/nerdtree'

" NerdTree git plugin
Plug 'Xuyuanp/nerdtree-git-plugin'

" Preview
Plug 'greyblake/vim-preview'
Plug 'tyru/open-browser.vim'
Plug 'mpetazzoni/autopreview.vim'


" Python auto-completion
Plug 'davidhalter/jedi-vim'

" Autocompletion
Plug 'ternjs/tern_for_vim'

" Typescript autoimports
Plug 'Quramy/tsuquyomi'

" Autocomplete html tags
Plug 'alvan/vim-closetag'

" Android
Plug 'hsanson/vim-android'

" Javascript
Plug 'pangloss/vim-javascript'

" Python Indentation
Plug 'hynek/vim-python-pep8-indent'

" Intentline
Plug 'Yggdroot/indentLine'

" CSS coloring
Plug 'ap/vim-css-color'

" Choosewin
Plug 't9md/vim-choosewin'

" Vim sandwich
Plug 'machakann/vim-sandwich'

" Bullets
Plug 'dkarter/bullets.vim'

" Abolish
Plug 'tpope/vim-abolish'

Plug 'aklt/plantuml-syntax'
Plug 'weirongxu/plantuml-previewer.vim'

" AutoPep8
Plug 'tell-k/vim-autopep8'

" Pydocstring
" Plug 'heavenshell/vim-pydocstring'

" Asyncronous linting
Plug 'w0rp/ale'

" Jenkins Syntax
Plug 'khalliday7/Jenkinsfile-vim-syntax'
Plug 'vim-scripts/groovyindent-unix'

" Poetry Syntax
Plug 'cespare/vim-toml'
Plug 'maralla/vim-toml-enhance'

" Todo plugin
Plug 'Dimercel/todo-vim'

" Color-scheme switcher
Plug 'xolox/vim-colorscheme-switcher'
Plug 'xolox/vim-misc'

" SQL Utilities
Plug 'jezcope/vim-align'
Plug 'vim-scripts/SQLUtilities'

" Google Formatter
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'

call plug#end()

" }}}
" General: Indentation (tabs, spaces, width, etc)------------- {{{

augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  " autocmd FileType python AutoFormatBuffer yapf
  autocmd FileType python AutoFormatBuffer autopep8
augroup END

" }}}
" General: AutoFormatter------------- {{{

augroup autoformat_settings
  autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript AutoFormatBuffer clang-format
  autocmd FileType dart AutoFormatBuffer dartfmt
  autocmd FileType go AutoFormatBuffer gofmt
  autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  " autocmd FileType python AutoFormatBuffer yapf
  autocmd FileType python AutoFormatBuffer autopep8
augroup END

" }}}
" General: Folding Settings --------------- {{{

augroup fold_settings
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType zsh setlocal foldmethod=marker foldlevelstart=0
  autocmd FileType vim setlocal foldlevelstart=0
  autocmd FileType * setlocal foldnestmax=1
augroup END

augroup folding_methods
    au!
    au FileType python setlocal foldmethod=indent
    au FileType javascript setlocal foldmethod=syntax
augroup END


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

" }}}
" General: Syntax highlighting ---------------- {{{

" Papercolor: options
let g:PaperColor_Theme_Options = {}
let g:PaperColor_Theme_Options['theme'] = {
      \     'default': {
      \       'transparent_background': 1
      \     }
      \ }
let g:PaperColor_Theme_Options['language'] = {
      \     'python': {
      \       'highlight_builtins' : 1
      \     },
      \     'cpp': {
      \       'highlight_standard_library': 1
      \     },
      \     'c': {
      \       'highlight_builtins' : 1
      \     }
      \ }

" Python: Highlight self and cls keyword in class definitions
augroup python_syntax
  autocmd!
  autocmd FileType python syn keyword pythonBuiltinObj self
  autocmd FileType python syn keyword pythonBuiltinObj cls
augroup end

" Syntax: select global syntax scheme
" Make sure this is at end of section
try
  set t_Co=256 " says terminal has 256 colors
  set background=dark
  syntax on
  " colorscheme sublimemonokai
  colorscheme PaperColor
catch
endtry

" }}}
"  Plugin: Configure ------------ {{{

" Python highlighting
let g:python_highlight_space_errors = 0
let g:python_highlight_all = 1

"  }}}
" General: Key remappings ----------------------- {{{

" Put your key remappings here
" Prefer nnoremap to nmap, inoremap to imap, and vnoremap to vmap
"
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

" ToggleRelativeNumber: uses custom functions
nnoremap <silent><leader>r :NumbersToggle<CR>

" TogglePluginWindows:
nnoremap <silent> <space>j :NERDTreeToggle<CR>
nnoremap <silent> <space>J :call NERDTreeToggleCustom()<CR>
nnoremap <silent> <space>u :UndotreeToggle<CR>

" Exiting: allows to get out from files easily
nnoremap <c-q> <esc>:q<CR>

" Resizing: allows to resize vim panes
nnoremap <leader>l :vertical resize+5<CR>
nnoremap <leader>h :vertical resize-5<CR>
nnoremap <leader>k :horizontal resize+5<CR>
nnoremap <leader>j :horizontal resize-5<CR>

" ResizeWindow: up and down; relies on custom functions
nnoremap <silent> <leader><leader>h mz:call ResizeWindowHeight()<CR>`z
nnoremap <silent> <leader><leader>w mz:call ResizeWindowWidth()<CR>`z

" Tagbar
nnoremap <silent> <space>l :TagbarToggle <CR>

" Choosewin
nnoremap <leader>q :ChooseWin<CR>

" PlugInstall
nnoremap <leader>po :PlantumlOpen<CR>

" Autopep8 indentation
nnoremap <leader>p :Autopep8<CR>

" ALEDisable
nnoremap <leader>d :ALEDisable<CR>

" IndentLines: toggle if indent lines is visible
nnoremap <silent> <leader>i :IndentLinesToggle<CR>

" Vim Plug Mappings
nnoremap <silent> <space>pi :PlugInstall<CR>
nnoremap <silent> <space>pc :PlugClean<CR>

" Todo Plugin
nnoremap <silent> <space>t :TODOToggle<CR>

" ColorSchemeChanger
nnoremap <silent> <space>n :NextColorScheme<CR>
nnoremap <silent> <space>p :NextColorScheme<CR>

" Google Formatter
nnoremap <leader>f :FormatCode<CR>

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
"  Plugin: Startify ------------- {{{

let g:startify_list_order = []
let g:startify_fortune_use_unicode = 1
let g:startify_enable_special = 1
let g:startify_custom_header = []
let g:startify_custom_footer = [
      \' _                                _',
      \'| | __ __   _ __  _ __  __ _   __| |',
      \'| |/ / _ \ |    \| __/ /  ` | / _` |',
      \'|   < (_)  | | | | |  | (_| || (_| |',
      \'|_|\_\___/ |_| |_|_|   \__,_| \__,_|',
      \'',
      \] + map(startify#fortune#cowsay(), {idx, val -> '' . val})

"  }}}
"  Plugin: Plugin Configure ------------- {{{
"
" Python:
" Open module, e.g. :Pyimport os (opens the os module)
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = 0
let g:jedi#auto_close_doc = 1
let g:jedi#smart_auto_mappings = 0
let g:jedi#force_py_version = 3

" mappings
" auto_vim_configuration creates space between where vim is opened and
" closed in my bash terminal. This is annoying, so I disable and manually
" configure. See 'set completeopt' in my global config for my settings
let g:jedi#auto_vim_configuration = 0
let g:jedi#goto_command = "<C-]>"
let g:jedi#documentation_command = "<leader>sd"
let g:jedi#usages_command = "<leader>su"
let g:jedi#rename_command = "<leader>sr"

" VimJavascript:
let g:javascript_plugin_flow = 1

" JSX: for .js files in addition to .jsx
let g:jsx_ext_required = 0

" JsDoc:
let g:jsdoc_enable_es6 = 1

" AutoPEP8:
let g:autopep8_disable_show_diff = 1

" IndentLines:
let g:indentLine_enabled = 0  " indentlines disabled by default

" WinResize:
let g:winresizer_start_key = '<C-\>'
let g:winresizer_vert_resize = 1
let g:winresizer_horiz_resize = 1

" Bullets
let g:bullets_enabled_file_types = [
    \ 'markdown',
    \ 'text',
    \ 'gitcommit',
    \ 'scratch'
    \]

" Typescript
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" Markdown preview
let vim_markdown_preview_github=1

" Javascript:
let g:tern#command = ["npx", "tern"]
let g:tern_show_argument_hints = 'on_move'
let g:tern_show_signature_in_pum = 1
augroup javascript_complete
  autocmd!
  autocmd FileType javascript nnoremap <buffer> <C-]> :TernDef<CR>
  autocmd FileType javascript nnoremap <buffer> <leader>gd :TernDoc<CR>
augroup END


"  }}}
" General: Filetype specification ------------ {{{

augroup filetype_recognition
  autocmd!
  autocmd BufNewFile,BufRead,BufEnter *.hql,*.q set filetype=hive
  autocmd BufNewFile,BufRead,BufEnter *.config set filetype=yaml
  autocmd BufNewFile,BufRead,BufEnter *.bowerrc,*.babelrc,*.eslintrc,*.slack-term
        \ set filetype=json
  autocmd BufNewFile,BufRead,BufEnter *.handlebars set filetype=html
  autocmd BufNewFile,BufRead,BufEnter *.m,*.oct set filetype=octave
  autocmd BufNewFile,BufRead,BufEnter *.jsx set filetype=javascript.jsx
  autocmd BufNewFile,BufRead,BufEnter *.gs set filetype=javascript
  autocmd BufNewFile,BufRead,BufEnter *.cfg,*.ini,.coveragerc,.pylintrc
        \ set filetype=dosini
  autocmd BufNewFile,BufRead,BufEnter *.tsv set filetype=tsv
  autocmd BufNewFile,BufRead,BufEnter Dockerfile.* set filetype=Dockerfile
  autocmd BufNewFile,BufRead,BufEnter Makefile.* set filetype=make
  autocmd BufNewFile,BufRead,BufEnter poetry.lock set filetype=toml
augroup END

augroup filetype_vim
  autocmd!
  autocmd BufWritePost *vimrc so $MYVIMRC |
        \if has('gui_running') |
        \so $MYGVIMRC |
        \endif
augroup END

" }}}
" General: Resize Window --- {{{

" WindowWidth: Resize window to a couple more than longest line
" modified function from:
" https://stackoverflow.com/questions/2075276/longest-line-in-vim
function! ResizeWindowWidth()
  let maxlength   = 0
  let linenumber  = 1
  while linenumber <= line("$")
    exe ":" . linenumber
    let linelength  = virtcol("$")
    if maxlength < linelength
      let maxlength = linelength
    endif
    let linenumber  = linenumber+1
  endwhile
  exe ":vertical resize " . (maxlength + 4)
endfunction

function! ResizeWindowHeight()
  let initial = winnr()

  " this duplicates code but avoids polluting global namespace
  wincmd k
  if winnr() != initial
    exe initial . "wincmd w"
    exe ":1"
    exe "resize " . (line('$') + 1)
    return
  endif

  wincmd j
  if winnr() != initial
    exe initial . "wincmd w"
    exe ":1"
    exe "resize " . (line('$') + 1)
    return
  endif
endfunction

" }}}
"  Plugin: Tagbar ------ {{{
let g:tagbar_map_showproto = '`'
let g:tagbar_show_linenumbers = -1
let g:tagbar_autofocus = 1
let g:tagbar_indent = 1
let g:tagbar_sort = 0  " order by order in sort file
let g:tagbar_case_insensitive = 1
let g:tagbar_width = 37
let g:tagbar_silent = 1
let g:tagbar_foldlevel = 0
" }}}
