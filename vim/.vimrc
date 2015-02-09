" vim:fdm=marker
" Clear all autocommands
au!

call pathogen#infect()
Helptags

" Basic Options {{{
set nocompatible
" Allow backspacing over everything in insert mode
set backspace=indent,eol,start
" Backups
set backup
set undofile
set backupdir=~/.vim/backup//
set undodir=~/.vim/undo//
set directory=~/.vim/swap//
set title
set history=100
set ruler
set showcmd
set incsearch
set ignorecase smartcase
set omnifunc=syntaxcomplete#Complete 
set foldmethod=syntax
set scrolloff=5
" Show line number of current line but relative for all others
set number
set relativenumber
" Tabs/indents
set expandtab
set smarttab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set switchbuf=useopen
set showtabline=2
set modeline
set modelines=1
set winwidth=79
set splitbelow
set wrap
set formatoptions=crnj1
" Smarter command completion
set wildmenu
set wildmode=list:longest,full
" Rolodex mode
set winheight=5 " has to be set first for some reason
:set noequalalways winminheight=5 winheight=9999 helpheight=9999
" Fix slow escape in insert mode
:set timeout timeoutlen=1000 ttimeoutlen=100

let mapleader=" "
" }}}

" Fix fish shell incompatability
if &shell =~# 'bin/fish$'
  set shell=/bin/sh
endif

filetype plugin indent on

" Cursor {{{
if has('mouse')
  set mouse=a
endif

" Highlight current line number
hi CursorLineNR ctermbg=15 ctermfg=0

" Cursorline in active window only
augroup CursorLine
  au!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END
" }}}

" Colors {{{
syntax on

if !has('gui_running')
  set t_Co=256
endif

set background=dark

colorscheme solarized
" }}}

" Plugins {{{
" Indent Guides {{{
let g:indent_guides_guide_size=2
" }}}

" YouCompleteMe {{{
let g:ycm_global_ycm_extra_conf='~/.vim/YCM/conf/global_ycm_extra_conf.py' 
let g:ycm_add_preview_to_completeopt=1
let g:ycm_autoclose_preview_window_after_insertion=1
" }}}

" Lightline {{{
set laststatus=2
set noshowmode

let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LLFugitive',
      \   'readonly': 'LLReadonly',
      \   'modified': 'LLModified',
      \   'filename': 'LLFilename'
      \ },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }  

function! LLFugitive()
  if exists('*fugitive#head')
    let _ = fugitive#head()
    return strlen(_) ? ' '._ : ''
  endif
  return ''
endfunction

function! LLModified()
  if &filetype == 'help'
    return ''
  elseif &modified
    return '+'
  elseif &modifiable
    return ''
  else
    return '-'
  endif
endfunction

function! LLReadonly()
  if &filetype == 'help'
    return ''
  elseif &readonly
    return ''
  else
    return '' 
  endif
endfunction

function! LLFilename()
  return ('' != LLReadonly() ? LLReadonly() . ' ' : '') .
        \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LLModified() ? ' ' . LLModified() : '')
endfunction
" }}}

" Closetag {{{
augroup CloseTag
  au!
  autocmd FileType html,htmldjango,jinjahtml,eruby,mako let b:closetag_html_style=1
  autocmd FileType html,xhtml,xml,htmldjango,jinjahtml,eruby,mako source ~/.vim/bundle/closetag.vim/plugin/closetag.vim
augroup END
" }}}

" Tagbar {{{
let g:tagbar_usearrows=1
nnoremap <leader>t :TagbarToggle<CR> 
" }}}

" Livedown {{{
nnoremap <leader>md :call LivedownPreview()<cr>
" }}}

" Ctrl-P {{{
nnoremap <leader>p <c-p>
" }}}

" }}}

" etc {{{
" Commands {{{
augroup vimrcEx
  au!
  " When editing a file, jump to the last known cursor position.
  au BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

  " Set cmake file type properly
  au BufRead,BufNewFile *.cmake,CMakeLists.txt set filetype=cmake
  " And markdown
  au BufNewFile,BufReadPost *.md set filetype=markdown

  " Set absolute numbers in insert mode or when out of focus
  au InsertEnter,WinLeave,FocusLost * setlocal norelativenumber number
  au InsertLeave,WinEnter * setlocal relativenumber
augroup END

" Diff original file with edits
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif
" }}}

" Mappings {{{
" Normal {{{
" Fancy window stacks
" Quit and save session as current
nnoremap <leader>qs :mksession! ~/.vim/sessions/current.vim<cr>:qa<cr>
" Just save session as current
nnoremap <leader>ss :mksession! ~/.vim/sessions/current.vim<cr>
" Save session as
nnoremap <leader>as :mksession! ~/.vim/sessions/
" Remap window functions to <leader>w
nnoremap <leader>w <C-w>
" Re-source .vimrc
nnoremap <leader>rc :source ~/.vimrc<cr>
" }}}
" Insert {{{
" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <c-u> <c-g>u<c-u>

" Sublime-style brace indenting code blocks
inoremap {<cr> {<cr>}<c-o>O
inoremap [<cr> [<cr>]<c-o>O
inoremap (<cr> (<cr>)<c-o>O

" Ctrl-c is just Esc
imap <c-c> <esc>
" }}}
" Command {{{
" Directory of current buffer
cnoremap %% <C-R>=expand('%:h').'/'<cr>
" Save as root
cnoremap sudow w !sudo tee % > /dev/null
" }}}
" }}}
" }}}
