set nocompatible
set viminfo='20,<50,s10,h,rA:,rB:,n$VIM/_viminfo
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set guifont=Lucida_Console:h11:cANSI
set tags=tags;/
let g:load_doxygen_syntax=1
let g:p4EnableActiveStatus=0
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif
set cmdheight=2
set wildmode=longest,list
set expandtab
colors darkblue
set backupdir=C://Temp
set directory=C://Temp

" Buffer switching with alt-left, alt-right
:noremap <M-left> :bprev<CR>
:noremap <M-right> :bnext<CR> 

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 100 characters.
  autocmd FileType text setlocal textwidth=100

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")
source $VIMRUNTIME/mswin.vim

set shiftwidth=3
set tabstop=3
set expandtab
" do not expand tabs in Makefile
autocmd BufNewFile,BufRead *.mk,[Mm]akefile* set noexpandtab
autocmd BufNewFile,BufRead  set noexpandtab
" Use the below highlight group when displaying bad whitespace is desired
highlight BadWhitespace ctermbg=red guibg=red
" Display tabs at the beginning of a line in for as bad
au BufRead,BufNewFile *.c,*.cc,*.cpp,*.hpp,*h,*.inc,*.sh,*tcsh,*.v,*.tcl match BadWhitespace /^\t\+/
au BufNewFile,BufRead *.V,*.mcl,*.pm,*.vm,*.v_save[0-9] set syntax=verilog_systemverilog
set autoindent
set nobackup
set nowritebackup
set makeprg=gmake\ -w
set errorfile=make_errors.txt
"set clipboard=unnamed "use GUI clipboard by default
"set errorformat=%*[^\"]\"%f\"\\,L%l/C%c:\ %m,%DEntering\ directory\ `%f',%XLeaving\ directory\ `%f',
"set errorformat=%*[^\"]\"%f\"

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

" vim -b : edit binary using xxd-format!
augroup Binary
   au!
   au BufReadPre  *.raw let &bin=1
   au BufReadPost *.raw if &bin | %!xxd
   au BufReadPost *.raw set ft=xxd | endif
   au BufWritePre *.raw if &bin | %!xxd -r
   au BufWritePre *.raw endif
   au BufWritePost *.raw if &bin | %!xxd
   au BufWritePost *.raw set nomod | endif
augroup END

" show current function name
fun! ShowFuncName()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun
map f :call ShowFuncName() <CR>
map t :TlistToggle <CR>
let Tlist_Inc_Winwidth = 0

