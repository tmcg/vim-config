
set nocompatible

" Configuration Functions {{{
function! SyncSyntax() " {{{
    " Syntax Highlighting Sync Helper
    syntax sync fromstart
    echo
endfunction

" }}}
function! EnhCommentifyCallback(ft) " {{{
if a:ft == 'ps1' || a:ft == 'psm1'
	let b:ECcommentOpen = '#'
	let b:ECcommentClose = ''
endif
endfunction
let g:EnhCommentifyCallbackExists = 'Yes'
" }}}
function! EnhCommentifyAdd() " {{{
    call EnhancedCommentify('','comment')
endfunction
" }}}
function! EnhCommentifyRemove() " {{{
    call EnhancedCommentify('','decomment')
endfunction
" }}}
function! CurrentBufferDir() " {{{
    " Sets the current directory of the buffer to the directory 
    " containing the file opened in that buffer
	let _dir = expand("%:p:h") 
	exec "cd " . _dir 
    echo _dir
	unlet _dir 
endfunction

" }}}
function! ToggleFoldColumn() " {{{
    " Toggles the folding column indicating open/closed folds
	if(&foldcolumn == 0)
		let &foldcolumn=5
	else
		let &foldcolumn=0
	endif
endfunction 

" }}}
function! RunCommandPrompt() " {{{
    let _cmdstr = input( getcwd() . "> " )
    if (_cmdstr != "")
        execute "! " . _cmdstr
    endif
endfunction

" }}}
function! RunCommandPromptWithCapture() " {{{
    let _cmdstr = input( getcwd() . "> " )
    if (_cmdstr != "")
        execute "r ! " . _cmdstr
    endif
endfunction

" }}}
function! RunCommandPromptWithStart() " {{{
    let _cmdstr = input( getcwd() . "> " )
    if (_cmdstr != "")
        execute "!start " . _cmdstr
    endif
endfunction 

" }}}
function! GuiTabLabel() " {{{
    let lblattribs = ''
    let bufnrlist = tabpagebuflist(v:lnum)

    " Show the number of windows in the tab page if more than one
    let wincount = tabpagewinnr(v:lnum, '$')
    if wincount > 1
        let lblattribs .= '['.wincount.']'
    endif

    " Show '+' if one of the buffers in the tab page is modified
    for bufnr in bufnrlist
        if getbufvar(bufnr, "&modified")
            let lblattribs .= '[+]' 
            break
        endif
    endfor

    if lblattribs != ''
        let lblattribs = ' ' . lblattribs
    endif

    let lblname = expand('%:p:t') "bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
    if lblname == ''
        let lblname = '[No Name]'
    endif

    " Append the buffer name
    return lblname . lblattribs
endfunction

" }}}
function! CopyMatchingLines() " {{{
  let posinit = getpos(".")
  call cursor(1, 1)
  let cnt = 0
  let hits = []
  let snum = search(@/, 'cW')
  while snum > 0
    let enum = search(@/, 'ceW')
    call extend(hits, getline(snum, enum))
    let cnt += 1
    normal! $
    let snum = search(@/, 'W')
  endwhile
  if cnt > 0
    let @+ = join(hits, "\n") . "\n"
  endif
  call cursor(posinit[1], posinit[2])
  echomsg cnt 'lines (or blocks) were appended to the clipboard.'
endfunction

" }}}
function! CopyMatches(line1, line2, reg) " {{{
  let reg = empty(a:reg) ? '+' : a:reg
  if reg =~# '[A-Z]'
    let reg = tolower(reg)
  else
    execute 'let @'.reg.' = ""'
  endif
  for line in range(a:line1, a:line2)
    let txt = getline(line)
    let idx = match(txt, @/)
    while idx >= 0
      execute 'let @'.reg.' .= matchstr(txt, @/, idx) . "\n"'
      let end = matchend(txt, @/, idx)
      let idx = match(txt, @/, end)
    endwhile
  endfor
endfunction
command! -range=% -register CopyMatches call CopyMatches(<line1>, <line2>, '<reg>')

" }}}

function! ConfigureAll(settings) " {{{
    call ConfigureWindowSize(a:settings)
    call ConfigureEncodings(a:settings)
    call ConfigureAutoCommands(a:settings)
    call ConfigureFonts(a:settings)
    call ConfigureShell(a:settings)
    call ConfigureSyntaxScheme(a:settings)
    call ConfigureOptions(a:settings)
    call ConfigureKeyMappings(a:settings)
endfunction 

" }}}
function! ConfigureWindowSize(settings) " {{{
    " Sets gVim Window Size 
    if !exists("g:WindowSizeCmd") && has("gui")
      let g:WindowSizeCmd = ":set lines=".a:settings.WindowLines
      execute g:WindowSizeCmd
      let g:WindowSizeCmd = ":set columns=".a:settings.WindowColumns
      execute g:WindowSizeCmd
    endif
endfunction 

" }}}
function! ConfigureEncodings(settings) " {{{
    " Sets Text and File Encodings
    if has("multi_byte")
      set encoding=utf-8
      set fileencodings=ucs-bom,utf-8,latin1
      setg fileencoding=utf-8
      setg bomb
      if &termencoding == ""
        let &termencoding = &encoding
      endif
    else
      echomsg 'Warning: Multibyte support is not available.'
    endif
endfunction 

" }}}
function! ConfigureAutoCommands(settings) " {{{
    " Sets Commands Executed On Entering Buffers
    " Powershell File Type detection
    autocmd BufNewFile,BufRead *.ps1 setf ps1
    " WPF XAML File Type detection
    autocmd BufNewFile,BufRead *.xaml setf xml

    " Sync syntax highlighting from the start of file when entering a buffer
    " autocmd BufEnter * call SyncSyntax()

    " Special tabstop settings for file types
    autocmd FileType cs set ts=3|set sts=3
    autocmd FileType xml set ts=3|set sts=3
    autocmd FileType css set ts=3|set sts=3
    autocmd FileType jade set ts=3|set sts=3
    autocmd FileType javascript set ts=3|set sts=3
    autocmd FileType html set ts=3|set sts=3

    autocmd FileType python set omnifunc=pythoncomplete#Complete
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS
    autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
    autocmd FileType c set omnifunc=ccomplete#Complete
endfunction 

" }}}
function! ConfigureFonts(settings) " {{{
    " Sets GUI and Print Fonts
    if a:settings.Platform == 'windows'
        let l:fc1 = ':set guifont='.substitute(a:settings.FontFace,' ','_','g').':h'.a:settings.FontSize.':cDEFAULT'
        let l:fc2 = ':set printfont='.substitute(a:settings.FontFacePrint,' ','_','g').':h'.a:settings.FontSizePrint.':cDEFAULT'
    else
        let l:fc1 = ':set guifont='.substitute(a:settings.FontFace,' ','\ ',g).'\ '.a:settings.FontSize
        let l:fc2 = ':set printfont='.substitute(a:settings.FontFacePrint,' ','\ ',g).'\ '.a:settings.FontSizePrint
    endif

    execute l:fc1
    execute l:fc2
    echo
endfunction 

" }}}
function! ConfigureShell(settings) " {{{
    " Sets Specified Command Shell
    if tolower(a:settings.Shell) == "powershell"
        " Use Windows PowerShell as the VIM shell
        set shell=powershell.exe
        set shellcmdflag=-STA\ -NoLogo\ -NoProfile\ -NonInteractive\ -ExecutionPolicy\ Bypass\ -Command
        set shellpipe=|
        set shellredir=>
    endif
endfunction 

" }}}
function! ConfigureSyntaxScheme(settings) " {{{
    " Configure Syntax Highlighting
    syntax enable
    let l:bg = ':set background='.tolower(split(a:settings.ColorScheme,'/')[1])
    execute l:bg
    let l:cs = ':colorscheme '.tolower(split(a:settings.ColorScheme,'/')[0])
    execute l:cs
    echo
endfunction 

" }}}
function! ConfigureOptions(settings) " {{{
    "=== General Options ===
    set ignorecase              " Ignore case in searches - use \C to match on case
    set autoindent              " Automatic indenting 
    set showcmd                 " Show partial command in the status line
    set incsearch               " Turn on incremental search
    set ruler                   " Show column and line number in status line
    set number                  " Show line numbers
    set mousehide               " Hide the mouse when typing
    set visualbell              " Visual Bell
    set nohidden                " Modified buffers don't become hidden when removed from a window 
    set wildmenu                " Enhanced command and filename completion
    set noswapfile              " Remove the 'swap file exists!' error message at the risk of data loss 
    set mouse=ar                " Enable the mouse in all editing modes, including 'Hit Enter' prompts
    set history=100             " Last NN commands in the history
    set ch=1                    " Command Line Height
    set backspace=2             " Conveniently backspace over previous characters
    set nowrap                  " No line wrapping because it screws up code listings
    set expandtab
    set softtabstop=2           " Soft Tab width
    set tabstop=2               " Tab width
    set shiftwidth=2            " Shift width the same as tab width for autoindenting
    set laststatus=2            " Always display the status bar
    set listchars=tab:>-,eol:@  " List mode characters
    set whichwrap=b,s,h,l       " Allow the 'h' and 'l' normal mode commands to wrap lines
    set foldmethod=marker       " Use fold markers as code folding aids
    set statusline=\ \ %F\ %m%r%=\[%l/%L,%2c/%v\]\ \[0x%B,0x%O\]\ [%{&fileencoding}]\ %w%h
    set showtabline=1           " Show tab line if there is more than one tab
    set confirm                 " Confirm all actions (global setting for :confirm)
    set hlsearch                " Highlight of matching search items
    nohlsearch                  " Turn off highlight of matching search items by default
    set winaltkeys=no
    set guitablabel=%!GuiTabLabel()
    set guioptions-=t                       " Disable tear-off menus
    set guioptions-=m                       " Disable menus
    set guioptions-=T                       " Disable toolbar
    set printoptions=syntax:n,number:y      " Disable syntax highlighting when printing
    set cpoptions+=$                        " Prevent line redisplay on single line change
    set formatoptions+=r                    " Automatically insert a comment leader when adding a new line inside a comment
    let c_space_errors=1                    " Highlight spaces in C files
    let c_no_trail_space_error=1            " But don't highlight trailing spaces as errors
    let foldcolumn=0                        " Default to a hidden fold column

    " Create backup & swap files in the temp dir
    if a:settings.Platform == 'windows'
        set backupdir=$TEMP
        set directory=$TEMP
    else
        set backupdir='~/tmp,~/'
        set directory='~/tmp,/var/tmp,/tmp'
    endif

    "=== Buffer Explorer Options ===
    let g:bufExplorerOpenMode = 1           " Window to open new buffers in (0 = use new, 1 = use current)
    let g:bufExplorerSplitType = "v"        " Split the explorer window horizontally or vertically ('' = horizontal, 'v' = vertical)
    let g:bufExplorerSortBy = "number"      " Column to sort by ('number','name','mru')
    let g:bufExplorerSplitOutPathName = 0   " Split the path into filename & path (0 = don't split, 1 = split)

    "=== ShowMarks Options ===
    let g:showmarks_enable = 0              " Disable ShowMarks by default, use <Leader>mt to enable it at any time

    "=== Netrw Options ===
    let g:netrw_liststyle = 3               " Default to heirarchical file listing
endfunction

" }}}
function! ConfigureKeyMappings(settings) " {{{
    call ConfigureKeyMappingsVimKeys()
    call ConfigureKeyMappingsLeaderKey()
    call ConfigureKeyMappingsWindowsKeys()
    call ConfigureKeyMappingsFunctionKeys()
endfunction

" }}}
function! ConfigureKeyMappingsVimKeys() " {{{
    " Buffer navigation Next/Prev
    nnoremap <M-k> :bprevious<CR>
    nnoremap <M-j> :bnext<CR>
    nnoremap <M-PageUp> :bprevious<CR>
    nnoremap <M-PageDown> :bnext<CR>
    
    " Select the first part/last part of a line
    nnoremap <S-Home> m`v<Home>
    inoremap <S-Home> <C-o>m`<C-o>h<C-o>v<Home>
    nnoremap <S-End>  m`v<End>
    inoremap <S-End>  <C-o>m`<C-o>v<End>
    
    " Indent/unindent the visual selection
    nnoremap <Tab> :s/^/  /<CR>``:nohl<CR>''
    nnoremap <S-Tab> :s/^\(\t\\|  \)//<CR>``:nohl<CR>''
    vnoremap <Tab> om'o:s/^/  /<CR>:nohl<CR>gv
    vnoremap <S-Tab> om'o:s/^\(\t\\|  \)//<CR>:nohl<CR>gv
    
    " Navigate through open windows
    nnoremap <C-S-Left>  <C-W>h
    nnoremap <C-S-Down>  <C-W>j
    nnoremap <C-S-Up>    <C-W>k
    nnoremap <C-S-Right> <C-W>l
    
    " Move the current window to the edge of the screen 
    nnoremap <C-W><C-Left>  <C-W>H
    nnoremap <C-W><C-Down>  <C-W>J
    nnoremap <C-W><C-Up>    <C-W>K
    nnoremap <C-W><C-Right> <C-W>L
    
    " Resize the current window
    nnoremap <C-kDivide>   <C-W><
    nnoremap <C-kMinus>    <C-W>-
    nnoremap <C-kPlus>     <C-W>+
    nnoremap <C-kMultiply> <C-W>>
    
    " Open the current window in a new tab
    nnoremap <C-W><C-T> <C-W>T
    
    " Yank to the end of the line (like 'D' except text is preserved)
    map Y y$

    " Delete into black hole register
    map R "_d
    
    " Insert a line above/below while staying in Normal mode
    nnoremap = m`O<Esc>``
    nnoremap - m`o<Esc>``
    
    " Toggling of Normal/Insert mode
    nnoremap <C-CR> o
    inoremap <C-CR> <Esc>o
    nnoremap <S-CR> O
    inoremap <S-CR> <Esc>O
    
    " Centre window on current line 
    nnoremap <Space> zz
    " Insert a single character
    nnoremap <C-Space> i<Space><Esc>r

    " Go to the next physical line (next screen line, regardless of wrapping)
    " Use j & k to go to the next logical line
    nnoremap <Up> gk
    inoremap <Up> <C-o>gk
    vnoremap <Up> gk
    nnoremap <Down> gj
    inoremap <Down> <C-o>gj
    vnoremap <Down> gj
    
    " Shift-Arrow selection method
    " The default VIM shift-arrow keys can mess up the current cursor position
    nnoremap <S-Up> V<Up>
    vnoremap <S-Up> <Up>
    inoremap <S-Up> <C-O>V<Up>
    nnoremap <S-Down> V<Down>
    vnoremap <S-Down> <Down>
    inoremap <S-Down> <C-O>V<Down>
    
    " Use Ctrl-Arrow keys to get the default Shift-Arrow key behaviour
    noremap <C-Up> <S-Up>
    noremap <C-Down> <S-Down>
    
    " Scroll the window up/down one line
    nnoremap <M-Up> <C-Y>
    nnoremap <M-Down> <C-E>
    " Go back in the tag history
    nnoremap <M-Left> <C-T>
    " Follow the tag currently under the cursor
    nnoremap <M-Right> <C-]>
    nnoremap <C-M-Right> :sp<CR><C-]>

    " Automatically insert a brace pair in normal or insert mode
    nnoremap <M-{> a{<CR>}<ESC>ko<TAB>
    inoremap <M-{> {<CR>}<ESC>ko<TAB>
    " Automatically insert a begin/end pair in normal or insert mode
    nnoremap <M-S-B> oBEGIN<CR><Tab><CR><BS>END<Esc>kA
    inoremap <M-S-B> <C-o>oBEGIN<CR><Tab><CR><BS>END<Esc>kA
    " Automatically insert a bracket pair in normal or insert mode
    nnoremap <M-(> a(  )<ESC>hi
    inoremap <M-(> (  )<ESC>hi
    
    " Search for the next/previous occurrence of the visual selection
    vnoremap * y/\V<C-R>=substitute(escape(@@,"/\\"),"\n","\\\\n","ge")<CR><CR>
    vnoremap # y?\V<C-R>=substitute(escape(@@,"?\\"),"\n","\\\\n","ge")<CR><CR> 
endfunction

" }}}
function! ConfigureKeyMappingsLeaderKey() " {{{
    " Quickly reload or source this _vimrc file
    nnoremap <Leader>vs :source $VIM/_vimrc<Enter>:echo "Reloaded config file"<Enter>
    nnoremap <Leader>ve :tabnew $VIM/_vimrc<Enter>
    
    " Run a PowerShell script file from within VIM
    nnoremap <Leader>rf :map \rf :!&{.'%:p'}<Enter>
    
    " Join a series of lines with a comma (Visual Mode)
    vnoremap <Leader>j, J:.s/\s\+/, /g<CR>:nohls<CR>

    " Quote a visual selection
    vnoremap <Leader>q" <Esc>`>a"<Esc>`<i"<Esc>
    vnoremap <Leader>q' <Esc>`>a'<Esc>`<i'<Esc>
    vnoremap <Leader>q( <Esc>`>a)<Esc>`<i(<Esc>
    vnoremap <Leader>q[ <Esc>`>a]<Esc>`<i[<Esc>
        
    " Resynchronise syntax highlighting
    nnoremap <Leader>ss :call SyncSyntax()<CR>

    " Repeat last search and center on the line
    nnoremap <Leader>n nzz
    nnoremap <Leader>N Nzz
    
    " Automatically insert begin/end in normal or insert mode
    nnoremap <Leader>kk A<CR>begin<CR>end<CR><ESC>kO<TAB>
    " Automatically insert a closing bracket in normal or insert mode
    nnoremap <Leader>kl i(  )<ESC>hi

    " EnhancedCommentify Mappings
    let g:EnhCommentifyUserBindings = 'yes'
    " Comments line(s)
    nnoremap <Leader>] :call EnhCommentifyAdd()<CR>
    vnoremap <Leader>] :call EnhCommentifyAdd()<CR>
    " Uncomments line(s)
    nnoremap <Leader>[ :call EnhCommentifyRemove()<CR>
    vnoremap <Leader>[ :call EnhCommentifyRemove()<CR>

    " Insert/Remove a C/C++ preprocessor definition "#ifdef 0" on the visual selection
    nnoremap <Leader>} V:<esc>'<O<esc>i#ifdef 0<esc>mz'>o<esc>i#endif<esc>`z\mh
    vnoremap <Leader>} :<esc>'<O<esc>i#ifdef 0<esc>mz'>o<esc>i#endif<esc>`z\mh

    " Automatic insertion of common templates
    nnoremap <Leader>dsp :r $VIM/vimfiles/templates/tsql_procedure.sql<CR>
    "nnoremap <Leader>dsp :r $VIM/vimfiles/templates/tsql_function.sql<CR>
    
    " Toggle show invisible characters
    nnoremap <Leader>l :set list!<CR>

    " Open all buffers in windows
    nnoremap <Leader>bt :tab ba<CR>

    " Launch ConqueTerm Shell
    nnoremap <Leader>ct :execute 'ConqueTermTab '.&shell<CR>
    
    " Toggle a code fold
    nnoremap <Leader>ff :exe 'silent! normal! za'.(foldlevel('.')?'':'i')<CR>
    
    " Insert a code fold
    nnoremap <Leader>fv V:<esc>'<O// {{{<esc>mz'>o// }}}<esc>`zhhh\mh
    vnoremap <Leader>fv :<esc>'<O// {{{<esc>mz'>o// }}}<esc>`zhhh\mh

    " Execute SQL Command
    nnoremap <Leader>x ggVG"qy``:call ExecuteSQL()<CR>
    vnoremap <Leader>x "qy:call ExecuteSQL()<CR>

    " Kill the entire buffer
    nnoremap <Leader><BS> ggVGx<CR>
endfunction

" }}}
function! ConfigureKeyMappingsWindowsKeys() " {{{
    " Windows Undo/Redo
    nnoremap <C-Z> u
    inoremap <C-Z> <C-o>u
    vnoremap <C-Z> <Esc>u
    nnoremap <C-Y> <C-R>
    inoremap <C-Y> <C-o><C-R>
    vnoremap <C-Y> <Esc><C-R>
    
    " Windows clipboard Cut
    vnoremap <C-X>   "*x
    vnoremap <S-Del> "*x
    
    " Windows clipboard Copy
    vnoremap <C-C>      "*y
    vnoremap <C-Insert> "*y
    
    " Windows clipboard Paste
    nnoremap <C-V>		 "*gP
    inoremap <C-V>       <C-O>"*gP
    vnoremap <C-V>       "*gp
    cnoremap <C-V>		 <C-R>*
    nnoremap <S-Insert>	 "*gP
    inoremap <S-Insert>  <C-O>"*gP
    vnoremap <S-Insert>  d"*gP
    cnoremap <S-Insert>	 <C-R>*

    " Visual blockwise mode (what CTRL-V used to do)
    noremap <C-Q> <C-V>
    
    " Backspace deletes selection in visual mode
    nnoremap <BS> cl<Esc>a
    vnoremap <BS> d
    nnoremap <C-H> cl<Esc>a
    vnoremap <C-H> d
    
    " Windows System Menu
    if has("gui")
      noremap  <M-Space> :simalt ~<CR>
      inoremap <M-Space> <C-O>:simalt ~<CR>
      cnoremap <M-Space> <C-C>:simalt ~<CR>
    
      noremap  <M-f> :simalt f<CR>
      inoremap <M-f> <C-O>:simalt f<CR>
      cnoremap <M-f> <C-C>:simalt f<CR>
    endif
    
    " Windows Select all text
    nnoremap <C-A> ggVG
    inoremap <C-A> <Esc>ggVG
    vnoremap <C-A> <Esc>ggVG
    cnoremap <C-A> <Esc>ggVG
    
    " Addition/Subtraction on numbers (what CTRL-A/CTRL-X used to do)
    nnoremap <kPlus> <C-A>
    nnoremap <kMinus> <C-X>
    
    " Windows Save current buffer
    nnoremap <C-S> :update<CR>:echo<CR>
    inoremap <C-S> <Esc>:update<CR>:echo<CR>
    vnoremap <C-S> <Esc>:update<CR>:echo<CR>gv
    
    " New Buffer in a Tab
    nnoremap <C-T> :tabnew<CR>:echo<CR>
    inoremap <C-T> <C-o>:tabnew<CR><C-o>:echo<CR>
    vnoremap <C-T> <Esc>:tabnew<CR>:echo<CR>
    
    " Tab navigation Next/Prev
    nnoremap <C-Tab> :tabnext<CR>
    nnoremap <C-S-Tab> :tabprev<CR>
endfunction

" }}}
function! ConfigureKeyMappingsFunctionKeys() " {{{
    "===========================================================================
    "=== F1 ====================================================================
    " Search help for the current word
    nnoremap <silent> <S-F1> viw"zy:help <C-R>z<CR>
    inoremap <silent> <S-F1> <Esc>viw"zy:help <C-R>z<CR>
    vnoremap <silent> <S-F1> <Esc>viw"zy:help <C-R>z<CR>
    
    "===========================================================================
    "=== F2 ====================================================================
    " Browse to edit a file in a new tab
    nnoremap <silent> <F2> :Texplore<CR>
    inoremap <silent> <F2> <C-o>:Texplore<CR>
    vnoremap <silent> <F2> <Esc>:Texplore<CR>
    
    " Turn on highlight of text after column 79
    nnoremap <silent> <C-F2> :match LongLine '\%>79v.\+'<CR>
    inoremap <silent> <C-F2> <C-o>:match LongLine '\%>79v.\+'<CR>
    vnoremap <silent> <C-F2> :match LongLine '\%>79v.\+'<CR>
    
    " Toggle search highlighting
    nnoremap <silent> <S-F2> :set invhlsearch<Enter>:set hlsearch?<Enter>
    inoremap <silent> <S-F2> <C-o>:set invhlsearch<Enter><C-o>:set hlsearch?<Enter>
    vnoremap <silent> <S-F2> <Esc>:set invhlsearch<Enter>:set hlsearch?<Enter>
    
    " Turn off highlight on matching text
    nnoremap <silent> <C-S-F2> :match none<CR>
    inoremap <silent> <C-S-F2> <C-o>:match none<CR>
    vnoremap <silent> <C-S-F2> :match none<CR>

    " Browse to edit a file in a new tab
    nnoremap <silent> <M-F2> :browse tabedit<CR>
    inoremap <silent> <M-F2> <C-o>:browse tabedit<CR>
    vnoremap <silent> <M-F2> <Esc>:browse tabedit<CR>
     
    "===========================================================================
    "=== F3 ====================================================================
    " Set the current directory to the directory of the file in the current buffer
    nnoremap <silent> <F3> :call CurrentBufferDir()<CR>
    inoremap <silent> <F3> <C-o>:call CurrentBufferDir()<CR>
    vnoremap <silent> <F3> :call CurrentBufferDir()<CR>
    
    " Toggle the folding column
    nnoremap <silent> <C-F3> :call ToggleFoldColumn()<CR>
    inoremap <silent> <C-F3> <C-o>:call ToggleFoldColumn()<CR>
    vnoremap <silent> <C-F3> :call ToggleFoldColumn()<CR>

    " Split the window and opens the file currently under the cursor
    nnoremap <silent> <S-F3> :sp<CR>gf
    
    "===========================================================================
    "=== F4 ====================================================================
    " Complete HTML tag
    nnoremap <F4> viw"zxi<<Esc>"zpa></<Esc>"zpa><Esc>bba
    inoremap <F4> <Esc>viw"zxi<<Esc>"zpa></<Esc>"zpa><Esc>bba

    " Close current tab
    nnoremap <silent> <C-F4> :confirm tabclose<CR>
    inoremap <silent> <C-F4> <C-o>:confirm tabclose<CR>
    vnoremap <silent> <C-F4> :<BS><BS><BS><BS><BS>confirm tabclose<CR>
    
    " Close other tabs
    nnoremap <silent> <C-S-F4> :confirm tabo<CR>
    inoremap <silent> <C-S-F4> <C-o>:confirm tabo<CR>
    vnoremap <silent> <C-S-F4> :<BS><BS><BS><BS><BS>confirm tabo<CR>
    
    "===========================================================================
    "=== F5 ====================================================================
    " Launch the command under the visual selection or typed at the prompt (with the shell)
    nnoremap <silent> <F5> :call RunCommandPrompt()<CR>
    inoremap <silent> <F5> <C-O>:call RunCommandPrompt()<CR>
    vnoremap <silent> <F5> :<C-U>let old_reg=@"<CR>gv""y:! <C-R><C-R>"<CR>:let @"=old_reg<CR>
    
    " Launches the command under the visual selection or typed at the prompt (with 'start.exe')
    nnoremap <silent> <C-F5> :call RunCommandPromptWithStart()<CR>
    inoremap <silent> <C-F5> <C-O>:call RunCommandPromptWithStart()<CR>
    vnoremap <silent> <C-F5> :<C-U>let old_reg=@"<CR>gv""y:!start <C-R><C-R>"<CR>:let @"=old_reg<CR>
    
    " Captures the output of a command under the visual selection or typed at the prompt
    nnoremap <silent> <S-F5> :call RunCommandPromptWithCapture()<CR>
    inoremap <silent> <S-F5> <C-O>:call RunCommandPromptWithCapture()<CR>
    vnoremap <silent> <S-F5> :<C-U>let old_reg=@"<CR>gv""y:r ! <C-R><C-R>"<CR>:let @"=old_reg<CR>
    
    " Launches an explorer window for the current working directory
    nnoremap <silent> <C-S-F5> :if expand("%:p:h") != ""<CR>:!start explorer.exe %:p:h,/e<CR>:endif<CR><CR>
    inoremap <silent> <C-S-F5> <C-O>:if expand("%:p:h") != ""<CR>!start explorer.exe %:p:h,/e<CR>endif<CR><CR>
    vnoremap <silent> <C-S-F5> :<C-U>if expand("%:p:h") != ""<CR>!start explorer.exe %:p:h,/e<CR>endif<CR><CR>
    
    "===========================================================================
    "=== F6 ====================================================================
    " Browse for a file to write the current buffer to
    nnoremap <silent> <F6> :browse confirm w<CR>
    inoremap <silent> <F6> <C-o>:browse confirm w<CR>
    vnoremap <silent> <F6> :<BS><BS><BS><BS><BS>browse confirm w<CR>
    
    " Write the current buffer always
    nnoremap <silent> <S-F6> :w<CR>
    inoremap <silent> <S-F6> <C-o>:w<CR>
    vnoremap <silent> <S-F6> :<BS><BS><BS><BS><BS>confirm w<CR>
    
    " Write all buffers
    nnoremap <silent> <C-S-F6> :wa<CR>
    inoremap <silent> <C-S-F6> <C-o>:wa<CR>
    vnoremap <silent> <C-S-F6> :<BS><BS><BS><BS><BS>wa<CR>
    
    "===========================================================================
    "=== F7 ====================================================================
    " No Mappings

    "===========================================================================
    "=== F8 ====================================================================
    " No Mappings

    "===========================================================================
    "=== F9 ====================================================================
    " Invoke the Buffer Explorer in the current tab
    nnoremap <silent> <F9> :BufExplorer<Enter>
    inoremap <silent> <F9> <Esc>:BufExplorer<Enter>
    vnoremap <silent> <F9> <Esc>:BufExplorer<Enter>
    
    " Split the window and invoke the Buffer Explorer
    nnoremap <silent> <S-F9> :SBufExplorer<Enter>
    inoremap <silent> <S-F9> <Esc>:SBufExplorer<Enter>
    vnoremap <silent> <S-F9> <Esc>:SBufExplorer<Enter>

    " Invoke the Buffer Explorer in a new tab
    nnoremap <silent> <C-F9> :tabnew<Enter>:BufExplorer<Enter>
    inoremap <silent> <C-F9> <Esc>:tabnew<Enter>:BufExplorer<Enter>
    vnoremap <silent> <C-F9> <Esc>:tabnew<Enter>:BufExplorer<Enter>

    " List all buffers
    nnoremap <silent> <M-F9> :ls<Enter>
    inoremap <silent> <M-F9> <Esc>:ls<Enter>
    vnoremap <silent> <M-F9> <Esc>:ls<Enter>

    "===========================================================================
    "=== F10 ===================================================================
    " Invoke the File Explorer in the current tab
    nnoremap <silent> <F10> :Ex<Enter>
    inoremap <silent> <F10> <Esc>:Ex<Enter>
    vnoremap <silent> <F10> <Esc>:Ex<Enter>
    
    " Split the window and invoke the File Explorer
    nnoremap <silent> <S-F10> :Sex<Enter>
    inoremap <silent> <S-F10> <Esc>:Sex<Enter>
    vnoremap <silent> <S-F10> <Esc>:Sex<Enter>

    " Invoke the File Explorer in a new tab
    nnoremap <silent> <C-F10> :tabnew<Enter>:Ex<Enter>
    inoremap <silent> <C-F10> <Esc>:tabnew<Enter>:Ex<Enter>
    vnoremap <silent> <C-F10> <Esc>:tabnew<Enter>:Ex<Enter>

    nnoremap <silent> <M-F10> :simalt ~<CR>
    inoremap <silent> <M-F10> <Esc>:simalt ~<CR>a
    vnoremap <silent> <M-F10> <Esc>:simalt ~<CR>gv
    
    "===========================================================================
    "=== F11 ===================================================================
    " Close the current buffer with confirmation
    nnoremap <silent> <F11> :confirm bd<Enter>
    inoremap <silent> <F11> <Esc>:confirm bd<Enter>
    vnoremap <silent> <F11> <Esc>:confirm bd<Enter>
    
    " Close all buffers with confirmation
    nnoremap <silent> <C-F11> :bufdo bd<Enter>
    inoremap <silent> <C-F11> <Esc>:bufdo bd<Enter>
    vnoremap <silent> <C-F11> <Esc>:bufdo bd<Enter>
    
    " Close the current buffer without confirmation
    nnoremap <silent> <S-F11> :bd!<Enter>
    inoremap <silent> <S-F11> <Esc>:bd!<Enter>
    vnoremap <silent> <S-F11> <Esc>:bd!<Enter>
    
    " Close all buffers without confirmation
    nnoremap <silent> <C-S-F11> :bufdo bd!<Enter>
    inoremap <silent> <C-S-F11> <Esc>:bufdo bd!<Enter>
    vnoremap <silent> <C-S-F11> <Esc>:bufdo bd!<Enter>

    "===========================================================================
    "=== F12 ===================================================================
    " Close the current window with confirmation
    nnoremap <silent> <F12> :confirm q<Enter>
    inoremap <silent> <F12> <C-o>:confirm q<Enter>
    vnoremap <silent> <F12> <C-o>:confirm q<Enter>
    
    " Close all windows with confirmation
    nnoremap <silent> <C-F12> :confirm qa<Enter>
    inoremap <silent> <C-F12> <C-o>:confirm qa<Enter>
    vnoremap <silent> <C-F12> <C-o>:confirm qa<Enter>
    
    " Close the current window without confirmation
    nnoremap <silent> <S-F12> :q!<Enter>
    inoremap <silent> <S-F12> <C-o>:q!<Enter>
    vnoremap <silent> <S-F12> <C-o>:q!<Enter>
    
    " Close all windows without confirmation
    nnoremap <silent> <C-S-F12> :qa!<Enter>
    inoremap <silent> <C-S-F12> <C-o>:qa!<Enter>
    vnoremap <silent> <C-S-F12> <C-o>:qa!<Enter>
endfunction

" }}}
" }}}

let cfgSettings = {}
"let cfgSettings.FontFace = "Droid Sans Mono Dotted"
let cfgSettings.FontFace = "Cousine"
let cfgSettings.FontSize = 12
let cfgSettings.FontFacePrint = cfgSettings.FontFace
let cfgSettings.FontSizePrint = cfgSettings.FontSize-1
let cfgSettings.ColorScheme = "moria/dark"
let cfgSettings.WindowLines = 50
let cfgSettings.WindowColumns = 130

if has('win32')||has('win64')
    let cfgSettings.Platform = 'windows'
    let cfgSettings.Shell = 'powershell'
else
    let cfgSettings.Platform = 'unix'
    let cfgSettings.Shell = 'n/a'
endif

call ConfigureAll(cfgSettings)
