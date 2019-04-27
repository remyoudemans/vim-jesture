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

" Removes only for current assertion (if present)
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
  let l:doneOrEmpty = a:0 > 0 && a:1 == 'd' ? 'done' : ''

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


function! AlternateMock(...)
  let l:openCommand = a:0 > 0 ? a:1 : 'e'

  if expand('%:p:h:t') == '__mocks__'
    execute l:openCommand " " . expand('%:p:h:h') . '/' . expand('%')
  else
    if !isdirectory("__mocks__")
      call inputsave()
      let l:shouldMkdir = input('__mocks__ directory does not exist. Create it? (y/N) ')
      call inputrestore()
      redraw 
      if tolower(l:shouldMkdir) != 'y' && tolower(l:shouldMkdir) != 'yes'
        return
      endif

      call mkdir("__mocks__")
      echom "__mocks__ directory created."
    endif
    execute l:openCommand . " " . expand('%:p:h') . '/__mocks__/' . expand('%')
  endif
endfunction

" Opens the alternate mock (or non-mock if in a mock)
nmap <silent> <leader>jam :call AlternateMock()<CR>

" As previous but in a vertical split
nmap <silent> <leader>jvm :call AlternateMock('vsp')<CR>

" As previous but in a horizontal split
nmap <silent> <leader>jhm :call AlternateMock('sp')<CR>

" Alternate between file.(js|jsx|ts|tsx) and file.test.(js|jsx|ts|tsx). If you
" already have a __tests__ directory at that level, it will go to
" ./__tests__/file.test.(js|jsx|ts|tsx) instead of file.test.(js|jsx|ts|tsx).
function! AlternateTest(...)
  let l:openCommand = a:0 > 0 ? a:1 : 'e'
  let l:isTestFile = expand('%:r:e') == 'test'

  if l:isTestFile
    " if in __tests__ directory
    if expand('%:p:h:t') == '__tests__'
      " go to matching file outside __tests__ directory
      execute l:openCommand . " " . expand('%:p:h:h') . '/' . expand('%:r:r') . '.' . expand('%:e')
    else
      execute l:openCommand . " " . expand('%:r:r') . '.' . expand('%:e')
    endif
  else
    if isdirectory("__tests__")
      execute l:openCommand . " __tests__/" . expand('%:r:t') . '.test.' . expand('%:e')
    else 
      execute l:openCommand . " " . expand('%:p:r:t') . '.test.' . expand('%:e')
    endif
  endif
endfunction

" Opens the alternate test (or non-test if in a test)
nmap <silent> <leader>jat :call AlternateTest()<CR>

" As previous but in a vertical split
nmap <silent> <leader>jvt :call AlternateTest('vsp')<CR>

" As previous but in a horizontal split
nmap <silent> <leader>jht :call AlternateTest('sp')<CR>
