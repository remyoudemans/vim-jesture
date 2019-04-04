" Jest :JOnly or <leader>jo toggles whether current line's it is an it.only 
"   and removes other it.only if there's already one in the buffer
function! Onlify()
  let l:initialCursorPos = getcurpos()
  let l:lineno = line(".")

  call cursor(l:lineno, "$") 
  call search('\(it(\|it.only(\)', "b")

  if search('it.only(', "cn", l:lineno) == 0
    let l:relevantLineno = line(".")
    call cursor(0, 0)
    if search('it.only(', "c") != 0
      %s/it.only(/it(/
    endif
    call cursor(l:relevantLineno, "$")
    s/it(/it.only(/
  else
    s/it.only(/it(/
  endif
  execute l:lineno
  call setpos('.', l:initialCursorPos)
endfunction
nnoremap <silent> <leader>joo :call Onlify()<CR>

" Toggles whether block is an it.only but doesn't affect other assertions
function! ToggleOnly()
  let l:initialCursorPos = getcurpos()
  let l:lineno = line(".")

  call cursor(l:lineno, "$") 
  call search('\(it(\|it.only(\)', "b")

  if search('it.only(', "cn", l:lineno) == 0
    s/it(/it.only(/
  else
    s/it.only(/it(/
  endif
  execute l:lineno
  call setpos('.', l:initialCursorPos)
endfunction
nnoremap <silent> <leader>jto :call ToggleOnly()<CR>

function! RemoveOnly()
  let l:initialCursorPos = getcurpos()
  let l:lineno = line(".")
  call cursor(0, 0)
  if search('it.only(', "cn") != 0
    %s/it.only(/it(/
  endif
  execute l:lineno
  call setpos('.', l:initialCursorPos)
endfunction
nnoremap <silent> <leader>jro :call RemoveOnly()<CR>

function! JestIt(...)
  let l:doneOrEmpty = a:0 == 1 && a:1 == 'd' ? 'done' : ''

  execute "normal! iit('should ', (" . l:doneOrEmpty . ") => {\<Esc>o})\<Esc>=kf l"
  execute ":startinsert"
endfunction
nnoremap <leader>jit :call JestIt()<CR>
nnoremap <leader>jid :call JestIt('d')<CR>

function! JestMock()
  execute "normal! 0"
  let l:quoteType = search("'", '', line(".")) == 0 ? '"' : "'"
  execute "normal! 0f" . l:quoteType . "yi" . l:quoteType . "ojest.mock(" . l:quoteType . "\<C-O>p" . l:quoteType . ")\<Esc>"
endfunction
nnoremap <leader>jm :call JestMock()<CR>


function! AlternateMock()
 if expand('%:p:h:t') == '__mocks__'
   execute "e " . expand('%:p:h:h') . '/' . expand('%')
 else
   if !isdirectory("__mocks__")
     call mkdir("__mocks__")
     echom "__mocks__ directory created."
   endif
   execute "e " . expand('%:p:h') . '/__mocks__/' . expand('%')
 endif
endfunction
nmap <silent> <leader>jam :call AlternateMock()<CR>

function! AlternateTest()
  " TODO: check if there's a __tests__ folder!
  let l:targetFileName = expand('%:r:e') == 'test' ? expand('%:r:r') . '.' . expand('%:e') : expand('%:r:t') . '.test.' . expand('%:e')
  execute "e " . l:targetFileName
endfunction
nmap <leader>jat :call AlternateTest()<CR>
