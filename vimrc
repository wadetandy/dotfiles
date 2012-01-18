" Load our Pathogen bundles
call pathogen#infect()

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Disable modeline security vulns
set modelines=0

" Tab Settings
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" Wrapping
"set nowrap
set textwidth=72
set colorcolumn=80
set formatoptions=qrn1
set sidescroll=5

" wildmenu completion
set wildmenu
set wildmode=list:longest

set wildignore+=.hg,.git,.svn                    " version control
set wildignore+=*.aux,*.out,*.toc                " latex intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " vim swap files
set wildignore+=*.ds_store                       " osx stuffs

" backup and swap
set undodir=~/.vim/tmp/undo//
set backupdir=~/.vim/tmp/backup//
set directory=~/.vim/tmp/swap//
set backup

" color scheme
syntax enable
set background=dark

" random settings
set backspace=indent,eol,start
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set encoding=utf-8
set scrolloff=5
set autoindent
set showmode
set hidden      " buffers with edits can exist without being 'open'
set wildmenu
set wildmode=list:longest
set visualbell
set ttyfast
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set laststatus=2
"set relativenumber
set number
            
" remap leader key
let mapleader = ","

" hit jj to escape instead of moving your hand
inoremap jj <esc> 

" searching and movement ====================================================

" sane regex
nnoremap / /\v
vnoremap / /\v

set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

" move by screen line instead of file line
nnoremap j gj
nnoremap k gk

" shouldn't need to shift for colon
nnoremap ; :

" remap f1 to escape to stop hitting help by accident
inoremap <f1> <esc>
nnoremap <f1> <esc>
vnoremap <f1> <esc>

" split window stuff
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <leader>w <c-w>v<c-w>l
nnoremap <leader>e <c-w>s<c-w>j

" plugin configuration =======================================================

" nerd tree
map <leader>t :nerdtreetoggle<cr>
let nerdtreemapopenvsplit='w'
let nerdtreemapopensplit='e'
let nerdtreemapopenexpl='s'
let nerdtreehijacknetrw='0'
let nerdtreeignore=['.vim$', '\~$', '.*\.pyc$', 'pip-log\.txt$']
"let nerdtreewinpos="right"
let nerdtreesortorder=['^__\.py$', '\/$', '*', '\.bak$', '\~$']
autocmd vimenter * if !argc() | nerdtree | endif " open nerd tree automatically if no files are specified
autocmd bufenter * if (winnr("$") == 1 && exists("b:nerdtreetype") && b:nerdtreetype == "primary") | q | endif
            " ^^ if nerd tree is the only open buffer, close vim

" Rails.vim
map <Leader>rm :Rmodel 
map <Leader>rc :Rcontroller 
map <Leader>rv :Rview 
map <Leader>ru :Runittest 
map <Leader>rf :Rfunctionaltest 
map <Leader>rtm :RTmodel 
map <Leader>rtc :RTcontroller 
map <Leader>rtv :RTview 
map <Leader>rtu :RTunittest 
map <Leader>rtf :RTfunctionaltest 
map <Leader>rwm :RVmodel 
map <Leader>rwc :RVcontroller 
map <Leader>rwv :RVview 
map <Leader>rwu :RVunittest 
map <Leader>rwf :RVfunctionaltest 
map <Leader>rem :RSmodel 
map <Leader>rec :RScontroller 
map <Leader>rev :RSview 
map <Leader>reu :RSunittest 
map <Leader>ref :RSfunctionaltest 
            
" stuff i'm toying with at the moment ========================================

" for win32 gui: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" don't use ex mode, use q for formatting
map q gq

" ctrl-u in insert mode deletes a lot.  use ctrl-g u to first break undo,
" so that you can undo ctrl-u after inserting a line break.
inoremap <c-u> <c-g>u<c-u>

" in many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" switch syntax highlighting on, when the terminal has colors
" also switch on highlighting the last used search pattern.
" Turning this off for now since I don't think I need it
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" only do this part when compiled with support for autocommands.
if has("autocmd")

  " enable file type detection.
  " use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in c files, etc.
  " also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " put these in an autocmd group, so that we can delete them easily.
  augroup vimrcex
  au!

  " for all text files set 'textwidth' to 78 characters.
  autocmd filetype text setlocal textwidth=78

  " when editing a file, always jump to the last known cursor position.
  " don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd bufreadpost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup end

endif " has("autocmd")

" convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" only define it when not defined already.
if !exists(":Difforig")
  command Difforig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" language and filetype specific stuff ==========================================
" stolen from https://bitbucket.org/sjl/dotfiles/src/tip/vim/.vimrc
" c {{{

"augroup ft_c
"    au!
"    au filetype c 
"augroup end

" }}}
" html and htmldjango {{{

augroup ft_html
    au!

    au bufnewfile,bufread *.html setlocal filetype=htmldjango
    au filetype html,jinja,htmldjango setlocal foldmethod=manual

    " use <localleader>f to fold the current tag.
    au filetype html,jinja,htmldjango nnoremap <buffer> <localleader>f vatzf

    " use shift-return to turn this:
    "     <tag>|</tag>
    "
    " into this:
    "     <tag>
    "         |
    "     </tag>
    au filetype html,jinja,htmldjango nnoremap <buffer> <s-cr> vit<esc>a<cr><esc>vito<esc>i<cr><esc>

    " smarter pasting
    au filetype html,jinja,htmldjango nnoremap <buffer> p :<c-u>yrpaste 'p'<cr>v`]=`]
    au filetype html,jinja,htmldjango nnoremap <buffer> p :<c-u>yrpaste 'p'<cr>v`]=`]
    au filetype html,jinja,htmldjango nnoremap <buffer> π :<c-u>yrpaste 'p'<cr>
    au filetype html,jinja,htmldjango nnoremap <buffer> ∏ :<c-u>yrpaste 'p'<cr>

    " django tags
    au filetype jinja,htmldjango inoremap <buffer> <c-t> {%<space><space>%}<left><left><left>

    " django variables
    au filetype jinja,htmldjango inoremap <buffer> <c-f> {{<space><space>}}<left><left><left>
augroup end

" }}}
" javascript {{{

augroup ft_javascript
    au!

    "au filetype javascript setlocal foldmethod=marker
    au filetype javascript setlocal foldmarker={,}
augroup end

" }}}
" markdown {{{

augroup ft_markdown
    au!

    au bufnewfile,bufread *.m*down setlocal filetype=markdown

    " use <localleader>1/2/3 to add headings.
    au filetype markdown nnoremap <buffer> <localleader>1 yypvr=
    au filetype markdown nnoremap <buffer> <localleader>2 yypvr-
    au filetype markdown nnoremap <buffer> <localleader>3 i### <esc>
augroup end

" }}}
" nginx {{{

augroup ft_nginx
    au!

    au bufread,bufnewfile /etc/nginx/conf/*                      set ft=nginx
    au bufread,bufnewfile /etc/nginx/sites-available/*           set ft=nginx
    au bufread,bufnewfile /usr/local/etc/nginx/sites-available/* set ft=nginx
    au bufread,bufnewfile vhost.nginx                            set ft=nginx

    au filetype nginx setlocal foldmethod=marker foldmarker={,}
augroup end

" }}}
" python {{{

augroup ft_python
    au!

    au filetype python setlocal omnifunc=pythoncomplete#complete
    au filetype python setlocal define=^\s*\\(def\\\\|class\\)
    "au filetype python compiler nose
    au filetype man nnoremap <buffer> <cr> :q<cr>
    
    " jesus tapdancing christ, built-in python syntax, you couldn't let me
    " override this in a normal way, could you?
    au filetype python if exists("python_space_error_highlight") | unlet python_space_error_highlight | endif
augroup end

" }}}
" ruby {{{

augroup ft_ruby
    au!
    au filetype ruby setlocal shiftwidth=2 tabstop=2 softtabstop=2
augroup end

" }}}
" vim {{{

augroup ft_vim
    au!

    au filetype vim setlocal foldmethod=marker shiftwidth=2 tabstop=2
    au filetype help setlocal textwidth=78
    au bufwinenter *.txt if &ft == 'help' | wincmd l | endif
augroup end

" }}}

"" vundle declarations =========================================================
" we are switching to pathogen for now, but let's keep these for a bit just in
" case

" set runtimepath to work with vundle
"set rtp+=~/.vim/bundle/vundle/
"call vundle#rc()

"bundle 'gmarik/vundle'

"" programming
"bundle 'rails.vim'
"bundle 'rubysinatra'
"bundle 'cucumber.zip'
"bundle 'haml.zip'

"" git integration
"bundle 'git.zip'
"bundle 'fugitive.vim'

"" ide features
"bundle 'scrooloose/nerdtree'
"bundle 'scrooloose/nerdcommenter'

"" syntax highlighting
"bundle 'markdown'
"bundle 'liquid.vim'
"bundle 'css_color.vim'

"" text editing features
"bundle 'surround.vim'

"" comments
"bundle 'commentary.vim'

