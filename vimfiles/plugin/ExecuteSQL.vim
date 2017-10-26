
" ExecuteSQL() adapted from a script by Shiju Samuel
" http://www.youtube.com/watch?v=NMMCtY0TmQ8
"
" Usage:
"   :call ConnectSQL('{instance}','{database')
"  Yank query into register q, then:
"   :call ExecuteSQL()


function! ConnectSQL(server,database)
    let g:sql_server = a:server
    let g:sql_database = a:database
endfunction

function! ExecuteSQL()
    let g:sql_query = @q
    let g:sql_file = $TEMP . '/vim_query.sql'
    if !exists("g:sql_database") || !exists("g:sql_database")
        echo "Use ConnectSQL(server,database) first!"
        return 0
    endif

    if g:sql_query == ""
        echo "Register q does not contain a query."
        return 0
    endif
    call writefile(split(g:sql_query,"\n"), g:sql_file)

    if exists("g:sql_buffer")
        " Go to buffer
        set swb=usetab
        exec ":rightbelow sbuf" . g:sql_buffer
    else
        bo new
        set buftype=nofile
        let g:sql_buffer = bufnr("%")
    endif

    let sql_cmd = 'r !sqlcmd -S' . g:sql_server . ' -d' . g:sql_database . ' -i "' . g:sql_file . '" -e -p'
    exec sql_cmd
endfunction

