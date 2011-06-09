let s:goshrlx_channel = $HOME . '/.gosh-rlx/to'

fun! s:GoshRLXSendExpr(expr)
    if !filewritable(s:goshrlx_channel)
        echohl WarningMsg
        echo '"' . s:goshrlx_channel . '" is not writable'
        echohl None
        return
    endif
    let ret = writefile([a:expr], s:goshrlx_channel)
    if ret < 0
      echohl WarningMsg
      echo "write error"
      echohl None
    endif
endfun

fun! s:GoshRLXEvalRange() range
    let i = a:firstline
    let s = ''
    while (i <= a:lastline)
        let s = s . getline(i)
        let i = i + 1
    endwhile
    call <SID>GoshRLXSendExpr(s)
endfun

fun! s:GoshRLXEvalExp()
    let save_reg = @x
    normal! "xyab
    let expr = substitute(@x, "\n", "", "g")
    call <SID>GoshRLXSendExpr(expr)
    let @x = save_reg
endfun

fun! s:GoshRLXLoadFile()
    let path = expand("%:p")
    let expr = '(load "' . path . '")'
    call <SID>GoshRLXSendExpr(expr)
endfun

nnoremap <buffer> <CR> mx:call <SID>GoshRLXEvalExp()<CR>`x
inoremap <buffer> <C-c><C-e> <Esc>mx:call <SID>GoshRLXEvalExp()<CR>`xa
nnoremap <buffer> <C-j> :call <SID>GoshRLXLoadFile()<CR>
vnoremap <buffer> <CR> :call <SID>GoshRLXEvalRange()<CR>
