" Vim syntax support file
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2001 Sep 12

" This file sets up the default methods for highlighting.
" It is loaded from "synload.vim" and from Vim for ":syntax reset".
" Also used from init_highlight().

if !exists("syntax_cmd") || syntax_cmd == "on"
  " ":syntax on" works like in Vim 5.7: set colors but keep links
  command -nargs=* SynColor hi <args>
  command -nargs=* SynLink hi link <args>
else
  if syntax_cmd == "enable"
    " ":syntax enable" keeps any existing colors
    command -nargs=* SynColor hi def <args>
    command -nargs=* SynLink hi def link <args>
  elseif syntax_cmd == "reset"
    " ":syntax reset" resets all colors to the default
    command -nargs=* SynColor hi <args>
    command -nargs=* SynLink hi! link <args>
  else
    " User defined syncolor file has already set the colors.
    finish
  endif
endif

" Many terminals can only use six different colors (plus black and white).
" Therefore the number of colors used is kept low. It doesn't look nice with
" too many colors anyway.
" Careful with "cterm=bold", it changes the color to bright for some terminals.
" There are two sets of defaults: for a dark and a light background.
if &background == "dark"
	SynColor Comment    gui=NONE      guifg=SeaGreen   guibg=NONE
	SynColor Constant   gui=NONE      guifg=Purple       guibg=NONE
	SynColor Special    gui=NONE      guifg=NONE       guibg=NONE
	SynColor Identifier gui=NONE      guifg=NONE       guibg=NONE
	SynColor Statement  gui=NONE      guifg=Magenta    guibg=NONE
	SynColor PreProc    gui=NONE      guifg=Red    guibg=NONE
	SynColor Type       gui=NONE      guifg=Blue     guibg=NONE
	SynColor Underlined gui=underline guifg=NONE       guibg=NONE
	SynColor Ignore     gui=NONE      guifg=White      guibg=NONE
	SynColor Error      gui=reverse   guifg=Red        guibg=White
	SynColor Todo       gui=NONE  guifg=Black      guibg=Yellow
	SynColor LongLine   gui=NONE  guifg=Black      guibg=Yellow
else
	SynColor Comment    gui=NONE      guifg=SeaGreen   guibg=NONE
	SynColor Constant   gui=NONE      guifg=Purple       guibg=NONE
	SynColor Special    gui=NONE      guifg=NONE       guibg=NONE
	SynColor Identifier gui=NONE      guifg=NONE       guibg=NONE
	SynColor Statement  gui=NONE      guifg=Magenta    guibg=NONE
	SynColor PreProc    gui=NONE      guifg=Red    guibg=NONE
	SynColor Type       gui=NONE      guifg=Blue     guibg=NONE
	SynColor Underlined gui=underline guifg=NONE       guibg=NONE
	SynColor Ignore     gui=NONE      guifg=White      guibg=NONE
	SynColor Error      gui=reverse   guifg=Red        guibg=White
	SynColor Todo       gui=NONE  guifg=Black      guibg=Yellow
	SynColor LongLine   gui=NONE  guifg=Black      guibg=Yellow
endif

"  SynColor Comment		term=bold 		cterm=NONE		ctermfg=DarkBlue	ctermbg=NONE gui=NONE		guifg=Blue		guibg=NONE
"  SynColor Constant	term=underline	cterm=NONE		ctermfg=DarkRed		ctermbg=NONE gui=NONE		guifg=Magenta	guibg=NONE
"  SynColor Special		term=bold		cterm=NONE		ctermfg=DarkMagenta ctermbg=NONE gui=NONE		guifg=SlateBlue	guibg=NONE
"  SynColor Identifier	term=underline	cterm=NONE		ctermfg=DarkCyan	ctermbg=NONE gui=NONE		guifg=DarkCyan	guibg=NONE
"  SynColor Statement	term=bold		cterm=NONE		ctermfg=Brown		ctermbg=NONE gui=bold		guifg=Brown		guibg=NONE
"  SynColor PreProc		term=underline	cterm=NONE		ctermfg=DarkMagenta	ctermbg=NONE gui=NONE		guifg=Purple	guibg=NONE
"  SynColor Type		term=underline	cterm=NONE		ctermfg=DarkGreen	ctermbg=NONE gui=bold		guifg=SeaGreen	guibg=NONE
"  SynColor Underlined	term=underline	cterm=underline	ctermfg=DarkMagenta 			 gui=underline	guifg=SlateBlue
"  SynColor Ignore		term=NONE		cterm=NONE		ctermfg=white		ctermbg=NONE gui=NONE		guifg=bg		guibg=NONE


" Common groups that link to default highlighting.
" You can specify other highlighting easily.
SynLink String		Constant
SynLink Character	Constant
SynLink Number		Constant
SynLink Boolean		Constant
SynLink Float		Number
SynLink Function	Identifier
SynLink Conditional	Statement
SynLink Repeat		Statement
SynLink Label		Statement
SynLink Operator	Statement
SynLink Keyword		Statement
SynLink Exception	Statement
SynLink Include		PreProc
SynLink Define		PreProc
SynLink Macro		PreProc
SynLink PreCondit	PreProc
SynLink StorageClass	Type
SynLink Structure	Type
SynLink Typedef		Type
SynLink Tag		Special
SynLink SpecialChar	Special
SynLink Delimiter	Special
SynLink SpecialComment	Special
SynLink Debug		Special

delcommand SynColor
delcommand SynLink
