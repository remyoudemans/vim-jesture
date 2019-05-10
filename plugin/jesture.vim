function! s:goToItAssertionInCurrentLineOrPrevious()
  let l:lineNumber = line(".") + 1
  execute l:lineNumber
  execute "normal! $"
  call search('\(it(\|it.only(\)', "zb")
endfunction

function! s:assertionBlockIsNotItOnly()
  let l:lineNumber = line(".")
  return search('it.only(', "cn", l:lineNumber) == 0
endfunction

function! JestureOnlify(shouldRemoveAllOtherOnlies)
  let l:initialCursorPos = getcurpos()

  call s:goToItAssertionInCurrentLineOrPrevious()

  if s:assertionBlockIsNotItOnly()
    if a:shouldRemoveAllOtherOnlies
      call JestureRemoveOnlies()
    endif
    s/it(/it.only(/
  else
    s/it.only(/it(/
  endif

  call setpos('.', l:initialCursorPos)
endfunction
nnoremap <silent> <leader>joo :call JestureOnlify(1)<CR>
nnoremap <silent> <leader>jto :call JestureOnlify(0)<CR>

function! JestureRemoveOnlies()
  let l:initialCursorPos = getcurpos()

  call cursor(0, 0)
  if search('it.only(', "cn") != 0
    %s/it.only(/it(/
  endif

  call setpos('.', l:initialCursorPos)
endfunction
nnoremap <silent> <leader>jro :call JestureRemoveOnlies()<CR>

function! JestureMockImport()
  execute "normal! 0"
  let l:quoteType = search("'", '', line(".")) == 0 ? '"' : "'"
  execute "normal! 0f" . l:quoteType . "yi" . l:quoteType . "ojest.mock(" . l:quoteType . "\<C-O>p" . l:quoteType . ")\<Esc>"
endfunction
nnoremap <leader>jmi :call JestureMockImport()<CR>


function! JestureAlternateMock(openCommand)
  if expand('%:p:h:t') == '__mocks__'
    execute a:openCommand " " . expand('%:p:h:h') . '/' . expand('%')
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
    execute a:openCommand . " " . expand('%:p:h') . '/__mocks__/' . expand('%')
  endif
endfunction

" Opens the alternate mock (or non-mock if in a mock)
nmap <silent> <leader>jam :call JestureAlternateMock('e')<CR>

" As previous but in a vertical split
nmap <silent> <leader>jvm :call JestureAlternateMock('vsp')<CR>

" As previous but in a horizontal split
nmap <silent> <leader>jhm :call JestureAlternateMock('sp')<CR>

" Alternate between file.(js|jsx|ts|tsx) and file.test.(js|jsx|ts|tsx). If you
" already have a __tests__ directory at that level, it will go to
" ./__tests__/file.test.(js|jsx|ts|tsx) instead of file.test.(js|jsx|ts|tsx).
function! JestureAlternateTest(openCommand)
  let l:isTestFile = expand('%:r:e') == 'test'
  let l:extension = '.' . expand('%:e')

  if l:isTestFile
    " if in __tests__ directory
    if expand('%:p:h:t') == '__tests__'
      " go to matching file outside __tests__ directory
      execute a:openCommand . " " . expand('%:p:h:h') . '/' . expand('%:r:r') . l:extension
    else
      execute a:openCommand . " " . expand('%:r:r') . l:extension
    endif
  else
    if isdirectory("__tests__")
      execute a:openCommand . " __tests__/" . expand('%:r:t') . '.test' . l:extension
    else 
      execute a:openCommand . " " . expand('%:p:r:t') . '.test' . l:extension
    endif
  endif
endfunction

" Opens the alternate test (or non-test if in a test)
nmap <silent> <leader>jat :call JestureAlternateTest('e')<CR>

" As previous but in a vertical split
nmap <silent> <leader>jvt :call JestureAlternateTest('vsp')<CR>

" As previous but in a horizontal split
nmap <silent> <leader>jht :call JestureAlternateTest('sp')<CR>

