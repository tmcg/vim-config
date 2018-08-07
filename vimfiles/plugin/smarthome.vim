nnoremap <Home> :call SmartHome()<cr>
inoremap <Home> <C-o>:call SmartHome()<cr>
vnoremap <Home> :call SmartHome()<cr>


func! SmartHome()
	" if the line is empty, just go to the first column
	if (getline(line(".")) =~ '^\s*$')
		normal 0
	else
		" get current column...
		let oldcol = col(".")
		" go to first non-white
		normal ^
		" in what column are we now?
		let newcol = col(".")
		" not moved, or moved forward
		if ((oldcol != 1) && (newcol >= oldcol))
			normal 0
		endif
	endif
endfunc

