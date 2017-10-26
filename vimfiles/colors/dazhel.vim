" Vim color file
"  Maintainer: Dazhel
"     version: 1.2
" This color scheme uses a dark background.

set background=dark
hi clear
if exists("syntax_on")
   syntax reset
endif

let colors_name = "dazhel"

hi Normal       guifg=#f0f0f0 guibg=#202020

" Search
hi IncSearch    gui=UNDERLINE guifg=#80ffff guibg=#0060c0
hi Search       gui=NONE guifg=#ffffa8 guibg=#808000

" Messages
hi ErrorMsg     gui=BOLD guibg=#ee2c2c guifg=#ffffff
hi WarningMsg   gui=BOLD guibg=#ee2c2c guifg=#ffffff 
hi ModeMsg      gui=BOLD guifg=#a0d0ff guibg=NONE
hi MoreMsg      gui=BOLD guifg=#70ffc0 guibg=#8040ff
hi Question     gui=BOLD guifg=#e8e800 guibg=NONE

" Split area
hi StatusLine   gui=BOLD guibg=#3f4572 guifg=fg
hi StatusLineNC gui=NONE guibg=#2e3252 guifg=fg
hi VertSplit    gui=NONE guibg=#3f4572 guifg=fg
hi WildMenu     gui=NONE guifg=#000000 guibg=#ff80c0
hi SignColumn   gui=NONE guibg=bg guifg=#a0a0a0

" Diff
hi DiffText     gui=NONE guifg=#ff78f0 guibg=#a02860
hi DiffChange   gui=NONE guifg=#e03870 guibg=#601830
hi DiffDelete   gui=NONE guifg=#a0d0ff guibg=#0020a0
hi DiffAdd      gui=NONE guifg=#a0d0ff guibg=#0020a0

" Cursor
hi Cursor       gui=NONE guibg=#ffa500 guifg=bg
hi lCursor      gui=NONE guifg=#ffffff guibg=#8800ff
hi CursorIM     gui=NONE guifg=#ffffff guibg=#8800ff

" Fold
hi Folded       gui=NONE guifg=#40f0f0 guibg=#006090
hi FoldColumn   gui=NONE guifg=#40c0ff guibg=#404040

" Other
hi Directory    gui=NONE guifg=#c8c8ff guibg=NONE
hi LineNr       gui=NONE guifg=#707070 guibg=NONE
hi NonText      gui=NONE guifg=#707070 guibg=NONE
hi SpecialKey   gui=BOLD guifg=#8888ff guibg=NONE
hi Title        gui=BOLD guifg=fg      guibg=NONE
hi Visual       gui=NONE guibg=#505050 
hi VisualNOS    gui=NONE guibg=#a0a0a0

" Syntax group
hi Comment      gui=NONE guifg=#a0a0a0 guibg=NONE
hi Constant     gui=NONE guifg=#92d4ff guibg=NONE
hi Error        gui=BOLD guifg=#ffffff guibg=#8000ff
hi Identifier   gui=NONE guifg=#40f8f8 guibg=NONE
hi Ignore       gui=NONE guifg=bg      guibg=NONE
hi PreProc      gui=NONE guifg=#ffcc99 guibg=NONE
hi Special      gui=NONE guifg=#ffaacc guibg=NONE
hi Statement    gui=NONE guifg=#dcdc78 guibg=NONE
hi Todo         gui=BOLD,UNDERLINE guifg=#ff80d0 guibg=NONE
hi Type         gui=NONE guifg=#60f0a8 guibg=NONE
hi Underlined   gui=UNDERLINE guifg=fg guibg=NONE
hi MatchParen   gui=NONE guibg=#008b8b
