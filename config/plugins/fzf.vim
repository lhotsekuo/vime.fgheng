if HasPlug('fzf') && HasPlug('fzf.vim')
    " 让输入上方，搜索列表在下方
    let $FZF_DEFAULT_OPTS = '--layout=reverse'

    " 打开 fzf 的方式选择 floating window
    let g:fzf_layout = { 'window': 'call OpenFloatingWin()' }

    function! OpenFloatingWin()
        if &columns < 140
            let width = 5000
            let col = 0
        else
            " let width = float2nr(&columns - (&columns * 2 / 10))
            let width = float2nr(&columns)
            let col = float2nr((&columns - width) / 2)
        endif
        let height = &lines - 3

        " 设置浮动窗口打开的位置，大小等。
        " 这里的大小配置可能不是那么的 flexible 有继续改进的空间
        let opts = {
                \ 'relative': 'editor',
                \ 'row': height * 0.3,
                \ 'col': col+30,
                \ 'width': width * 2 / 3,
                \ 'height': height / 2
                \ }

        let buf = nvim_create_buf(v:false, v:true)
        let win = nvim_open_win(buf, v:true, opts)

        " 设置浮动窗口高亮
        call setwinvar(win, '&winhl', 'Normal:Pmenu')
        call setwinvar(win, '&relativenumber', 0)

        " let buf = nvim_create_buf(v:false, v:true)
        " call setbufvar(buf, 'number', 'no')

        " let height = float2nr(&lines/2)
        " let width = float2nr(&columns - (&columns * 2 / 10))
        " "let width = &columns
        " let row = float2nr(&lines / 3)
        " let col = float2nr((&columns - width) / 3)

        " let opts = {
        "       \ 'relative': 'editor',
        "       \ 'row': row,
        "       \ 'col': col,
        "       \ 'width': width,
        "       \ 'height':height,
        "       \ }
        " let win =  nvim_open_win(buf, v:true, opts)
        " call setwinvar(win, '&number', 0)
        " call setwinvar(win, '&relativenumber', 0)
        setlocal
                \ buftype=nofile
                \ nobuflisted
                \ bufhidden=hide
                \ nonumber
                \ norelativenumber
                \ signcolumn=no
        nnoremap <buffer> <esc> <esc>:close<cr>
        imap <buffer> <esc> <esc>:close<cr>
        vnoremap <buffer> <esc> <esc>:close<cr>
        nnoremap <buffer> <c-j> <nop>
        nnoremap <buffer> <c-k> <nop>
        tnoremap <c-j> <down>
        tnoremap <c-k> <up>
        tnoremap <c-l> <nop>
        tnoremap <c-h> <nop>

        "highlight NormalFloat cterm=NONE ctermfg=14 ctermbg=0 gui=NONE guifg=#93a1a1 guibg=#002931
    endfunction

    let g:fzf_history_dir = '~/.cache/fzf-history'
    " This is the default extra key bindings
    let g:fzf_action = {
        \ 'ctrl-t': 'tab split',
        \ 'ctrl-x': 'split',
        \ 'ctrl-v': 'vsplit'
        \ }

    command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
        \   <bang>0 ? fzf#vim#with_preview('up:60%')
        \           : fzf#vim#with_preview('right:50%:hidden', '?'),
        \   <bang>0)

    " let g:fzf_colors =
    " \ { 'fg':      ['fg', 'Normal'],
    "   \ 'bg':      ['bg', '#5f5f87'],
    "   \ 'hl':      ['fg', 'Comment'],
    "   \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    "   \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    "   \ 'hl+':     ['fg', 'Statement'],
    "   \ 'info':    ['fg', 'PreProc'],
    "   \ 'border':  ['fg', 'Ignore'],
    "   \ 'prompt':  ['fg', 'Conditional'],
    "   \ 'pointer': ['fg', 'Exception'],
    "   \ 'marker':  ['fg', 'Keyword'],
    "   \ 'spinner': ['fg', 'Label'],
    "   \ 'header':  ['fg', 'Comment'] }

    if executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
    set grepprg=rg\ --vimgrep
    command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
    endif

    let g:fzf_commits_log_options = '--graph --color=always
    \ --format="%C(yellow)%h%C(red)%d%C(reset)
    \ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'
    "--------------------------------------
" Customize fzf colors to match your color scheme
"let g:fzf_colors =
"\ { 'fg':      ['fg', 'Normal'],
"  \ 'bg':      ['bg', '#5f5f87'],
"  \ 'hl':      ['fg', 'Comment'],
"  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
"  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
"  \ 'hl+':     ['fg', 'Statement'],
"  \ 'info':    ['fg', 'PreProc'],
"  \ 'border':  ['fg', 'Ignore'],
"  \ 'prompt':  ['fg', 'Conditional'],
"  \ 'pointer': ['fg', 'Exception'],
"  \ 'marker':  ['fg', 'Keyword'],
"  \ 'spinner': ['fg', 'Label'],
"  \ 'header':  ['fg', 'Comment'] }

"let g:fzf_commits_log_options = '--graph --color=always
"  \ --format="%C(yellow)%h%C(red)%d%C(reset)
"  \ - %C(bold green)(%ar)%C(reset) %s %C(blue)<%an>%C(reset)"'

""let $FZF_DEFAULT_COMMAND = 'ag --hidden -l -g ""'
"" ripgrep
"if executable('rg')
"  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
"  set grepprg=rg\ --vimgrep
"  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
"endif

"let $FZF_DEFAULT_OPTS='--layout=reverse'
"let g:fzf_layout = { 'window': 'call FloatingFZF()' }

"function! FloatingFZF()
"  let buf = nvim_create_buf(v:false, v:true)
"  call setbufvar(buf, 'number', 'no')

"  let height = float2nr(&lines/2)
"  let width = float2nr(&columns - (&columns * 2 / 10))
"  "let width = &columns
"  let row = float2nr(&lines / 3)
"  let col = float2nr((&columns - width) / 3)

"  let opts = {
"        \ 'relative': 'editor',
"        \ 'row': row,
"        \ 'col': col,
"        \ 'width': width,
"        \ 'height':height,
"        \ }
"  let win =  nvim_open_win(buf, v:true, opts)
"  call setwinvar(win, '&number', 0)
"  call setwinvar(win, '&relativenumber', 0)
"endfunction

"" Files + devicons
"function! Fzf_dev()
"  let l:fzf_files_options = ' --preview "rougify {2..-1} | head -'.&lines.'"'

"  function! s:files()
"    let l:files = split(system($FZF_DEFAULT_COMMAND), '\n')
"    return s:prepend_icon(l:files)
"  endfunction

"  function! s:prepend_icon(candidates)
"    let l:result = []
"    for l:candidate in a:candidates
"      let l:filename = fnamemodify(l:candidate, ':p:t')
"      let l:icon = WebDevIconsGetFileTypeSymbol(l:filename, isdirectory(l:filename))
"      call add(l:result, printf('%s %s', l:icon, l:candidate))
"    endfor

"    return l:result
"  endfunction

"  function! s:edit_file(item)
"    let l:pos = stridx(a:item, ' ')
"    let l:file_path = a:item[pos+1:-1]
"    execute 'silent e' l:file_path
"  endfunction

"  call fzf#run({
"        \ 'source': <sid>files(),
"        \ 'sink':   function('s:edit_file'),
"        \ 'options': '-m ' . l:fzf_files_options,
"        \ 'down':    '40%' ,
"        \ 'window': 'call FloatingFZF()'})
"endfunction
endif
