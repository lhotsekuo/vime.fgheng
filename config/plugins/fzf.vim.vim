if has('nvim')
	let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.6 } }
	let g:fzf_action = {
	\ 'ctrl-t': 'tab split',
	\ 'ctrl-s': 'split',
	\ 'ctrl-v': 'vsplit' }

	" [Buffers] Jump to the existing window if possible
	let g:fzf_buffers_jump = 1

	" Always enable preview window on the right with 60% width
	" let g:fzf_preview_window = 'right:60%'

	function! RipgrepFzf(query, fullscreen)
		let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
		let initial_command = printf(command_fmt, shellescape(a:query))
		let reload_command = printf(command_fmt, '{q}')
		let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
		call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
	endfunction

	command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

	command! -bang -nargs=? -complete=dir Files
	\ call fzf#vim#files(<q-args>, {'options': ['--info=inline', '--preview', 'cat {}']}, <bang>0)

	nnoremap <M-f> :Files<CR>
	nnoremap <M-F> :Files $HOME<CR>
	nnoremap <M-b> :Buffers<CR>
	nnoremap <M-c> :Commands<CR>
	nnoremap <M-t> :BTags<CR>
	nnoremap <M-T> :Tags<CR>
	nnoremap <M-b> :Buffers<CR>
	" 模糊搜索当前的buffer
	" nnoremap <M-s> :BLines<CR>
	" 使用rg搜索工作目录
	nnoremap <M-s> :RG<CR>
	" 模糊搜索所有buffer
	nnoremap ? :Lines<CR>
	nnoremap <M-r> :History<CR>
	nnoremap <M-g> :GFiles?<CR>
	nnoremap <M-G> :GFiles<CR>
	nnoremap <M-m> :Marks<CR>
	nnoremap <M-M> :Maps<CR>
	nnoremap <M-w> :Windows<CR>

	au FileType fzf tnoremap <buffer> <C-j> <Down>
	au FileType fzf tnoremap <buffer> <C-k> <Up>
	au FileType fzf tunmap <buffer> <Esc>
endif
