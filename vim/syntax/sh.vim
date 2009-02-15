" Vim syntax file
" Language:				POSIX shell (sh)
" Maintainer:			Watanabe, Yuki <magicant.starmen@nifty.com>
" Last Change:			Jan 18, 2009
" Version:				1
" URL:					http://homepage2.nifty.com/magicant/sapps/vimutils/
" For options and settings, please use:      :help ft-sh-syntax

" For version 5.x: Clear all syntax items and abort {{{1
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
	syntax clear
	echoerr "Sorry, your Vim is too old to execute this script."
	finish
elseif exists("b:current_syntax")
	finish
endif

" Set shell type {{{1
let s:type = getline(1)
if exists("b:is_bourneshell")
	if exists("b:is_posix")
		unlet b:is_posix
	endif
	if exists("b:is_kornshell")
		unlet b:is_kornshell
	endif
	if exists("b:is_bash")
		unlet b:is_bash
	endif
	if exists("b:is_yash")
		unlet b:is_yash
	endif
elseif s:type =~# '^#!.*/yash\>'
	let b:is_yash = 1
	if exists("b:is_kornshell")
		unlet b:is_kornshell
	endif
	if exists("b:is_bash")
		unlet b:is_bash
	endif
elseif !exists("b:is_posix") && !exists("b:is_kornshell") && !exists("b:is_bash")
	if exists("g:is_kornshell")
		let b:is_kornshell = 1
	elseif exists("g:is_bash")
		let b:is_bash = 1
	elseif !exists("g:is_sh")
		let b:is_posix = 1
	endif
endif
if exists("b:is_kornshell") || exists("b:is_bash") || exists("b:is_yash")
	let b:is_posix = 1
endif

" Miscellaneous settings {{{1
syntax case match
syntax spell notoplevel

" Clusters {{{1
sy cluster shWordsList contains=shDollarError,shWordParenError,shLineCont,shBackslash,shSingleQuote,shDoubleQuote,shBackquote,shCmdSub,shParameter,shArith,shSpecialGlob
sy cluster shParamOpsList contains=shParamOp,shParamModifier,shLineCont,shParamError
sy cluster shRedirsList contains=shRedir,shRedirCmd,shRedirHere
sy cluster shCommandsList contains=@shErrorList,shComment,shLineCont,shSimpleCmd,shFunction,shFunctionKW,shBang,shGroup,shSubSh,shIf,shFor,shWhile,shCase
sy cluster shTrailersList contains=shSeparator,shPipe,shTrailerLineCont,shAndOr,shTrailerRedir
sy cluster shErrorList contains=shSepError,shThenError,shElifError,shElseError,shFiError,shDoError,shDoneError,shInError,shCaseError,shEsacError,shCurlyError,shParenError,shDTestError

" Word {{{1
" These are 'contained' in shWordsList so that they are treated as part of
" a simple command
if !exists("b:is_kornshell") && !exists("b:is_bash") && !exists("b:is_yash")
	sy match shDollarError contained /\$/
endif
"if exists("b:is_bash")
"	sy region shSpecialGlob contained start=/(/ end=/)/
"else
	sy match shWordParenError contained /(/
"endif
sy match shParamError contained /[^}[:alnum:]_@*#?$!:=+-]/
sy match shBackslash  contained /\\./
sy region shSingleQuote contained matchgroup=shSingleQuoteMark start=/'/ end=/'/ contains=@Spell
sy region shDoubleQuote contained matchgroup=shDoubleQuoteMark start=/"/ end=/"/ contains=@Spell,shLineCont,shBackslashDQ,shBackquote,shCmdSub,shParameter,shArith
sy match shBackslashDQ contained /\\["`$\\]/
sy region shBackquote contained start=/`/ end=/`/ contains=shBackslashBQ,shCmdSub,shParameter,shArith
sy match shBackslashBQ contained /\\[$`\\]/
if exists("b:is_posix")
	sy region shCmdSub contained matchgroup=shParameter start=/\$(/ end=/)/ contains=@shCommandsList
endif
sy match shParameter contained /\$\h\w*/
sy match shParameter contained /\$\d/
sy match shParameter contained /\$[@*#?$!-]/
sy region shParameter contained matchgroup=shParameter start=/\${/ end=/}/ contains=@shParamOpsList
sy region shParamModifier contained matchgroup=shParamOp start=/:\?[-+?=]/ end=/}\@=/ contains=@shWordsList
if exists("b:is_posix")
	sy match shParamOp contained /{\@<=#/
	sy region shParamModifier contained matchgroup=shParamOp start=/##\?/ start=/%%\?/ end=/}\@=/ contains=@shWordsList
endif
if exists("b:is_kornshell") || exists("b:is_bash")
	sy match shParamOp contained /{\@<=!/
	sy region shParamModifier contained matchgroup=shParamOp start=/:/ end=/}\@=/ contains=@shWordsList,shParamColon
	sy region shParamColon contained matchgroup=shParamOp start=/:/ end=/}\@=/ contains=@shWordsList
endif
if exists("b:is_kornshell")
	sy match shParamOp contained /{\@<=@/
	sy region shParamModifier contained matchgroup=shParamOp start=/:#/ end=/}\@=/ contains=@shWordsList
endif
if exists("b:is_yash")
	sy region shParamNest contained matchgroup=shParamNest start=/{/ end=/}/ contains=@shParamOpsList
	sy region shParamModifier contained matchgroup=shParamOp start=":/" end=/}\@=/ contains=@shWordsList,shParamSlash
	sy cluster shParamOpsList add=shBackquote,shCmdSub,shParameter,shParamNest,shArith
endif
if exists("b:is_kornshell") || exists("b:is_bash") || exists("b:is_yash")
	sy region shParamModifier contained matchgroup=shParamOp start="/[#%/]\?" end=/}\@=/ contains=@shWordsList,shParamSlash
	sy region shParamSlash contained matchgroup=shParamOp start="/" end=/}\@=/ contains=@shWordsList
	sy region shParamModifier contained matchgroup=shParamOp start=/\[/ end=/]/ contains=@shWordsList
endif
if exists("b:is_posix")
	sy region shArith contained matchgroup=shParameter start=/\$((\([^()]*))\@!\)\@!/ end=/))/ contains=@shWordsList,shArithParen
	sy region shArithParen contained transparent start=/(/ end=/)/ contains=shArithParen
endif
sy region shComment start=/[^[:blank:]|&;<>()]\@<!#/ end=/\n\@=/ contains=@Spell,shTodo
" We use end=/\n\@=/ rather than end=/$/. Otherwise some syntax doesn't match
" properly after the comment.
sy keyword shTodo contained FIXME TODO XXX

" Redirection {{{1
if !exists("b:is_kornshell")
	sy match shRedir contained /\([^[:blank:]|&;<>()]\@<!\d\+\)\?>[>&|]\?/
	sy match shRedir contained /\([^[:blank:]|&;<>()]\@<!\d\+\)\?<[>&]\?/
	sy match shRedir contained /\([^[:blank:]|&;<>()]\@<!\d\+\)\?[<>]&\(\d\+\|-\)[^[:blank:]|&;<>()]\@!/
	if exists("b:is_bash")
		sy match shRedir contained /\([^[:blank:]|&;<>()]\@<!\d\+\)\?<<</
	endif
	if exists("b:is_yash")
		sy match shRedir contained /\([^[:blank:]|&;<>()]\@<!\d\+\)\?>>|\(\d\+[^[:blank:]|&;<>()]\@!\)\?/
		sy region shRedirCmd contained matchgroup=shRedir start=/\([^[:blank:]|&;<>()]\@<!\d\+\)\?[<>](/ end=/)/ contains=@shCommandsList
	endif
else
	sy match shRedir contained /\([^[:blank:]|&;<>()]\@<!\d\)\?>[>&|]\?/
	sy match shRedir contained /\([^[:blank:]|&;<>()]\@<!\d\)\?<[>&]\?/
	sy match shRedir contained /\([^[:blank:]|&;<>()]\@<!\d\)\?[<>]&\(\d\+\|-\)[^[:blank:]|&;<>()]\@!/
	sy match shRedir contained /\([^[:blank:]|&;<>()]\@<!\d\)\?<<</
endif
if exists("b:is_kornshell") || exists("b:is_bash")
	sy region shRedirCmd contained matchgroup=shParameter start=/[<>](/ end=/)/ contains=@shCommandsList
endif

" Here-document {{{1
sy region shRedirHere contained fold matchgroup=shRedir start=/[<>]\@<!\d*<<-\@!\s*\z([^[:blank:]|&;<>()"'\\]\+\)$/ end=/^\z1\n\@=/ contains=shBackquote,shCmdSub,shParameter,shArith
sy region shRedirHere contained fold matchgroup=shRedir start=/[<>]\@<!\d*<<-\s*\z([^[:blank:]|&;<>()"'\\]\+\)$/ end=/^\t*\z1\n\@=/ contains=shBackquote,shCmdSub,shParameter,shArith
sy region shRedirHere contained fold matchgroup=shRedir start=/[<>]\@<!\d*<<-\@!\s*\(["']\)\z([^"'\\]\+\)\1$/ end=/^\z1\n\@=/
sy region shRedirHere contained fold matchgroup=shRedir start=/[<>]\@<!\d*<<-\s*\(["']\)\z([^"'\\]\+\)\1$/ end=/^\t*\z1\n\@=/
sy region shRedirHere contained fold matchgroup=shRedir start=/[<>]\@<!\d*<<-\@!\s*\\\z([^[:blank:]|&;<>()"'\\]\+\)$/ end=/^\z1\n\@=/
sy region shRedirHere contained fold matchgroup=shRedir start=/[<>]\@<!\d*<<-\s*\\\z([^[:blank:]|&;<>()"'\\]\+\)$/ end=/^\t*\z1\n\@=/

" Simple command {{{1
sy region shSimpleCmd transparent start=/[^[:blank:]|&;()]/ end=/$/ end=/[;&|)]/me=e-1 contains=@shWordsList,@shRedirsList,shAssign,shComment nextgroup=@shTrailersList
sy match shAssign contained /[^[:blank:]|&;<>()]\@<!\h\w*=\@=/ nextgroup=shAssignArray
if exists("b:is_kornshell") || exists("b:is_bash") || exists("b:is_yash")
	sy region shAssignArray contained transparent matchgroup=shOperator start=/=(/hs=s+1 end=/)/ contains=@shWordsList,shComment
endif
sy match shLineCont /\\\n/
sy match shTrailerLineCont contained /\\\n/ skipwhite nextgroup=@shTrailersList

" Function definition {{{1
sy match shFunctionNoParen contained /\h\w*\s*/ skipwhite skipempty nextgroup=shGroup
sy match shFunction /\h\w*\s*(\s*)/ contains=shFunctionParen
sy match shFunctionParen contained /[()]/
if exists("b:is_kornshell")
	sy match shFunctionKW /[^[:blank:]|&;<>()]\@<!function[^[:blank:]|&;<>()]\@!/ skipwhite nextgroup=shFunctionNoParen
endif
if exists("b:is_bash")
	sy match shFunctionKW /[^[:blank:]|&;<>()]\@<!function[^[:blank:]|&;<>()]\@!/ skipwhite nextgroup=shFunction,shFunctionNoParen
endif

" Errors {{{1
" shDollarError and shParamError are defined above.
" shBangError is defined later.
sy match shSepError   /[;&|]/
sy match shThenError  /[^[:blank:]|&;<>()]\@<!then[^[:blank:]|&;<>()]\@!/
sy match shElifError  /[^[:blank:]|&;<>()]\@<!elif[^[:blank:]|&;<>()]\@!/
sy match shElseError  /[^[:blank:]|&;<>()]\@<!else[^[:blank:]|&;<>()]\@!/
sy match shFiError    /[^[:blank:]|&;<>()]\@<!fi[^[:blank:]|&;<>()]\@!/
sy match shDoError    /[^[:blank:]|&;<>()]\@<!do[^[:blank:]|&;<>()]\@!/
sy match shDoneError  /[^[:blank:]|&;<>()]\@<!done[^[:blank:]|&;<>()]\@!/
sy match shInError    /[^[:blank:]|&;<>()]\@<!in[^[:blank:]|&;<>()]\@!/
sy match shCaseError  /;;/
sy match shEsacError  /[^[:blank:]|&;<>()]\@<!esac[^[:blank:]|&;<>()]\@!/
sy match shCurlyError /[^[:blank:]|&;<>()]\@<!}[^[:blank:]|&;<>()]\@!/
sy match shParenError /)/
if exists("b:is_bash")
	sy match shDTestError /[^[:blank:]|&;<>()]\@<!\]\][^[:blank:]|&;<>()]\@!/
endif

" Bang {{{1
if exists("b:is_posix")
	sy match shBang /[^[:blank:]|&;<>()]\@<!![^[:blank:]|&;<>()]\@!/ skipwhite nextgroup=@shCommandsList,shBangError
	sy match shBangError contained /[^[:blank:]|&;<>()]\@<!![^[:blank:]|&;<>()]\@!/
endif

" Pipe, and-or list and asynchronous list {{{1
sy match shSeparator contained /;;\@!/
sy match shSeparator contained /&/
if exists("b:is_yash")
	sy match shPipe /|/ skipwhite skipempty nextgroup=@shCommandsList,shBangError
	sy cluster shCommandsList add=shPipe
else
	sy match shPipe /|/ skipwhite skipempty nextgroup=@shCommandsList,shBangError contained
endif
sy match shAndOr contained /&&/ skipwhite skipempty nextgroup=@shCommandsList
sy match shAndOr contained /||/ skipwhite skipempty nextgroup=@shCommandsList
sy region shTrailerRedir transparent start=/\d*[<>]/ end=/$/ end=/[;&|)]/me=e-1 contains=@shWordsList,@shRedirsList,shComment nextgroup=@shTrailersList

" Compound commands {{{1
" Parentheses and braces {{{2
sy region shGroup transparent fold matchgroup=shGroupRegion start=/[^[:blank:]|&;<>()]\@<!{[^[:blank:]|&;<>()]\@!/ end=/[^[:blank:]|&;<>()]\@<!}[^[:blank:]|&;<>()]\@!/ contains=@shCommandsList skipwhite nextgroup=@shTrailersList
sy region shSubSh transparent fold matchgroup=shSubShRegion start=/(/ end=/)/ contains=@shCommandsList skipwhite nextgroup=@shTrailersList

" If statement {{{2
sy region shIf transparent fold matchgroup=shConditional start=/[^[:blank:]|&;<>()]\@<!if[^[:blank:]|&;<>()]\@!/ end=/[^[:blank:]|&;<>()]\@<!fi[^[:blank:]|&;<>()]\@!/ contains=@shCommandsList,shThen skipwhite nextgroup=@shTrailersList
sy region shThen transparent contained matchgroup=shConditional start=/[^[:blank:]|&;<>()]\@<!then[^[:blank:]|&;<>()]\@!/ end=/[^[:blank:]|&;<>()]\@<!fi[^[:blank:]|&;<>()]\@!/me=e-2 contains=@shCommandsList,shElif,shElse
sy region shElif transparent contained matchgroup=shConditional start=/[^[:blank:]|&;<>()]\@<!elif[^[:blank:]|&;<>()]\@!/ end=/[^[:blank:]|&;<>()]\@<!fi[^[:blank:]|&;<>()]\@!/me=e-2 contains=@shCommandsList,shThen
sy region shElse transparent contained matchgroup=shConditional start=/[^[:blank:]|&;<>()]\@<!else[^[:blank:]|&;<>()]\@!/ end=/[^[:blank:]|&;<>()]\@<!fi[^[:blank:]|&;<>()]\@!/me=e-2 contains=@shCommandsList

" For statement {{{2
sy match shFor /[^[:blank:]|&;<>()]\@<!for[^[:blank:]|&;<>()]\@!/ skipwhite nextgroup=shForWord,shForDParen
sy match shForWord contained /[^[:blank:]|&;<>()]\@<!\h\w*[^[:blank:]|&;<>()]\@!/ skipwhite skipempty nextgroup=shForIn,shForComment,shForDo,shForSemi
sy region shForIn contained transparent matchgroup=shRepeat start=/[^[:blank:]|&;<>()]\@<!in[^[:blank:]|&;<>()]\@!/ matchgroup=shSeparator end=/$/ end=/;/ contains=@shWordsList,shComment skipwhite skipempty nextgroup=shForDo
sy region shForComment contained start=/[^[:blank:]|&;<>()]\@<!#/ end=/\n\@=/ contains=@Spell,shTodo skipwhite skipempty nextgroup=shForIn,shForDo
sy region shForDo contained transparent fold matchgroup=shRepeat start=/[^[:blank:]|&;<>()]\@<!do[^[:blank:]|&;<>()]\@!/ end=/[^[:blank:]|&;<>()]\@<!done[^[:blank:]|&;<>()]\@!/ contains=@shCommandsList skipwhite nextgroup=@shTrailersList
if exists("b:is_kornshell") || exists("b:is_bash")
	sy region shForDParen contained transparent matchgroup=shFor start=/((/ end=/))/ contains=@shWordsList,shArithParen skipwhite skipempty nextgroup=shForDo
endif
if exists("b:is_kornshell") || exists("b:is_bash") || exists("b:is_yash")
	sy match shForSemi contained /;/ skipwhite skipempty nextgroup=shForDo
endif

" Select statement {{{2
if exists("b:is_kornshell") || exists("b:is_bash")
	sy match shFor /[^[:blank:]|&;<>()]\@<!select[^[:blank:]|&;<>()]\@!/ skipwhite nextgroup=shForWord
endif

" While and until statements {{{2
sy region shWhile transparent fold matchgroup=shRepeat start=/[^[:blank:]|&;<>()]\@<!while[^[:blank:]|&;<>()]\@!/ start=/[^[:blank:]|&;<>()]\@<!until[^[:blank:]|&;<>()]\@!/ end=/[^[:blank:]|&;<>()]\@<!done[^[:blank:]|&;<>()]\@!/ contains=@shCommandsList,shWhileDo contains=@shCommandsList skipwhite nextgroup=@shTrailersList
sy region shWhileDo contained transparent matchgroup=shRepeat start=/[^[:blank:]|&;<>()]\@<!do[^[:blank:]|&;<>()]\@!/ end=/[^[:blank:]|&;<>()]\@<!done[^[:blank:]|&;<>()]\@!/me=e-4
" Case statement {{{2
sy match shCase /[^[:blank:]|&;<>()]\@<!case[^[:blank:]|&;<>()]\@!/ skipwhite nextgroup=shCaseWord
sy region shCaseWord contained transparent start=/[^[:blank:]|&;<>()]/ end=/[^[:blank:]|&;<>()]\@!/ contains=@shWordsList skipwhite skipempty nextgroup=shCaseIn,shCaseComment
sy region shCaseIn contained transparent fold matchgroup=shConditional start=/[^[:blank:]|&;<>()]\@<!in[^[:blank:]|&;<>()]\@!/ end=/[^[:blank:]|&;<>()]\@<!esac[^[:blank:]|&;<>()]\@!/ contains=shCasePattern,shComment,@shErrorList skipwhite nextgroup=@shTrailersList
sy region shCaseComment contained start=/[^[:blank:]|&;<>()]\@<!#/ end=/\n\@=/ contains=@Spell,shTodo skipwhite skipempty nextgroup=shCaseIn
sy region shCasePattern contained transparent matchgroup=NONE start=/[^[:blank:]#|&;<>()]/ matchgroup=shOperator start=/(/ end=/)/ contains=@shWordsList,shSepError,shCasePipe skipwhite skipempty nextgroup=shCaseCommand,shCaseDSemi
sy match shCasePipe contained /|/
sy region shCaseCommand contained transparent matchgroup=NONE start=/\S/ matchgroup=shSeparator end=/;;/ end=/[^[:blank:]|&;<>()]\@<!esac[^[:blank:]|&;<>()]\@!/me=e-4 contains=@shCommandsList
sy match shCaseDSemi contained /;;/

" [[ construct {{{2
if exists("b:is_kornshell") || exists("b:is_bash")
	sy region shDTest transparent matchgroup=shKeyword start=/[^[:blank:]|&;<>()]\@<!\[\[[^[:blank:]|&;<>()]\@!/ end=/[^[:blank:]|&;<>()]\@<!]][^[:blank:]|&;<>()]\@!/ contains=@shWordsList skipwhite nextgroup=@shTrailersList
endif

" Synchronization {{{1
if !exists("sh_minlines")
	let sh_minlines = 100
endif
if !exists("sh_maxlines")
	let sh_maxlines = 500 + sh_minlines
endif
exec "syn sync minlines=" . sh_minlines . " maxlines=" . sh_maxlines
sy sync match shCaseSync  groupthere NONE    /^\s*esac\s*$/
sy sync match shDoSync    grouphere  shForDo /^\s*do\s*$/
sy sync match shDoSync    groupthere NONE    /^\s*done\s*$/
sy sync match shIfSync    grouphere  shIf    /^\s*if\s*$/
sy sync match shIfSync    grouphere  shThen  /^\s*then\s*$/
sy sync match shIfSync    grouphere  shElif  /^\s*elif\s*$/
sy sync match shIfSync    grouphere  shElse  /^\s*else\s*$/
sy sync match shIfSync    groupthere NONE    /^\s*fi\s*$/
sy sync match shWhileSync grouphere  shWhile /^\s*while\s*$/
sy sync match shUntilSync grouphere  shWhile /^\s*until\s*$/

" Highlighting {{{1
hi def link shComment			Comment
hi def link shConditional		Conditional
hi def link shError				Error
hi def link shFunction			Function
hi def link shIdentifier		Identifier
hi def link shKeyword			Keyword
hi def link shLabel				Label
hi def link shOperator			Operator
hi def link shParameter			PreProc
hi def link shRepeat			Repeat
hi def link shSpecialChar		SpecialChar
hi def link shString			String
hi def link shTodo				Todo

hi def link shBangError			shError
hi def link shCaseError			shError
hi def link shCurlyError		shError
hi def link shDoError			shError
hi def link shDollarError		shError
hi def link shDoneError			shError
hi def link shElifError			shError
hi def link shElseError			shError
hi def link shEsacError			shError
hi def link shFiError			shError
hi def link shInError			shError
hi def link shParamError		shError
hi def link shParenError		shError
hi def link shSepError			shError
hi def link shThenError			shError
hi def link shWordParenError	shError
hi def link shDTestError		shError

hi def link shBackslash			shSpecialChar
hi def link shSingleQuote		shString
hi def link shDoubleQuote		shString
hi def link shSingleQuoteMark	shOperator
hi def link shDoubleQuoteMark	shOperator
hi def link shBackslashDQ		shSpecialChar
hi def link shBackquote			shParameter
hi def link shBackslashBQ		shSpecialChar
hi def link shCmdSub			Normal
hi def link shParamOp			shOperator
hi def link shParamModifier		Normal
hi def link shParamNest			shParameter
hi def link shArith				Normal
hi def link shSpecialGlob		shOperator

hi def link shRedir				shOperator
hi def link shRedirCmd			Normal
hi def link shRedirHere			shString
hi def link shLineCont			shOperator
hi def link shTrailerLineCont	shLineCont
hi def link shAssign			shIdentifier
hi def link shFunctionParen		shOperator
hi def link shFunctionKW		shKeyword
hi def link shFunctionNoParen	shFunction
hi def link shBang				shKeyword
hi def link shSeparator			shOperator
hi def link shPipe				shOperator
hi def link shAndOr				shOperator

hi def link shGroupRegion		shKeyword
hi def link shSubShRegion		shOperator
hi def link shFor				shRepeat
hi def link shForWord			shIdentifier
hi def link shForComment		shComment
hi def link shForSemi			shSeparator
hi def link shCase				shConditional
hi def link shCaseComment		shComment
hi def link shCasePipe			shSeparator
hi def link shCaseDSemi			shSeparator
hi def link shDTestWord			shOperator

" set b:current_syntax {{{1
if exists("b:is_yash")
	let b:current_syntax = "yash"
elseif exists("b:is_bash")
	let b:current_syntax = "bash"
elseif exists("b:is_kornshell")
	let b:current_syntax = "ksh"
else
	let b:current_syntax = "sh"
endif

" vim: ts=4 fdm=marker
