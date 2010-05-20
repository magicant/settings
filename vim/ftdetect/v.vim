" determine type of *.v file

if exists(":for")

autocmd! BufRead,BufNewFile *.v	call s:DetectTypeV()

function! s:DetectTypeV()
	if did_filetype()
		return
	endif

	let b:verilog_wc = 0
	let b:coq_wc = 0

	for line in getline(1, "$")
		if line =~# '\<end\(config\|function\|generate\|module\|primitive\|specify\|table\|task\|case\)\>\|`ifdef\>\|`define\>\|/[/*]\|\*/'
			let b:verilog_wc = b:verilog_wc + 1
		endif
		if line =~# '\<\(Axiom\|Conjecture\|Hypothes[ei]s\|Parameters\?\|Variables\?\|Theorem\|Lemma\|Proof\|Qed\|\(Co\)\?\(Fixpoint\|Inductive\)\|Ltac\)\>\|(\*\|\*)'
			let b:coq_wc = b:coq_wc + 1
		endif
	endfor

	if b:verilog_wc > b:coq_wc
		set filetype=verilog
	elseif b:verilog_wc < b:coq_wc
		set filetype=coq
	elseif exists("g:v_default_filetype")
		let &filetype = g:v_default_filetype
	else
		set filetype=verilog
	endif
endfunction

endif
