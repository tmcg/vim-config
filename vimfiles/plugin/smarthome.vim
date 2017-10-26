nnoremap <Home> :call SmartHome()<cr>
inoremap <Home> <C-o>:call SmartHome()<cr>
vnoremap <Home> :call SmartHome()<cr>


func! SmartHome()
	" get current column...
	let oldcol = col(".")
	" go to first non-white
	normal ^
	" in what column are we now?
	let newcol = col(".")
	" not moved (so we already where at first-non-white)?
	if (oldcol == newcol)
		normal $
		let lastcol = col(".")
		if (newcol == lastcol)
			" workaround: append one space, when line has only 1 char
			normal a 0
		else
			" go to column '1'
			normal 0
		endif
	" we did move - but forward...
	elseif ((oldcol != 1) && (newcol > oldcol))
		" go to column '1'
		normal 0
	endif
endfunc

