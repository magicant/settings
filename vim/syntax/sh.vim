" Vim syntax file
" Language:             sh, POSIX shell, ksh, bash, yash
" Maintainer:           Watanabe, Yuki <magicant.starmen AT nifty.com>
" Last Change:          Nov 23, 2024

" The following variables affect syntax highlighting:
"   b:is_bourneshell  If set, only the original Bourne shell's syntax is
"                     allowed. This variable overrides any other variables.
"   b:is_posix        If set, the syntax highlighting is based on the syntax
"                     defined by POSIX.
"   b:is_kornshell    If set, ksh-specific features are allowed.
"   b:is_bash         If set, bash-specific features are allowed.
"   b:is_yash         If set, yash-specific features are allowed.

if !has("patch-7.4.1142")
    runtime syntax/old/vim.sh
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
elseif !exists("b:is_posix") && !exists("b:is_kornshell") && !exists("b:is_bash") && !exists("b:is_yash")
    if exists("g:is_kornshell")
        let b:is_kornshell = 1
    elseif exists("g:is_bash")
        let b:is_bash = 1
    elseif exists("g:is_yash")
        let b:is_yash = 1
    elseif !exists("g:is_sh")
        let b:is_posix = 1
    endif
endif
if exists("b:is_kornshell") || exists("b:is_bash") || exists("b:is_yash")
    let b:is_posix = 1
endif

" Miscellaneous settings {{{1
syntax case match
if has("spell")
    syntax spell notoplevel
endif
if !exists("g:sh_syntax_isk") || g:sh_syntax_isk
    syntax iskeyword @,!-%,',*-:,=,?-{,}-~
endif

" Clusters {{{1
sy cluster shWordsList contains=@shInnerWordsList,shWordParenError
sy cluster shInnerWordsList contains=shDollarError,shLineCont,shBackslash,shSingleQuote,shDollarSingleQuote,shDoubleQuote,shBackquote,shCmdSub,shParameter,shParameterBrace,shArith,shExtGlob
sy cluster shParamOpsList contains=shParamOp,shParamModifier,shLineCont,shParamError
sy cluster shRedirsList contains=shRedir,shRedirCmd,shRedirLocation,shRedirHere
sy cluster shCommandsList contains=@shErrorList,shComment,shLineCont,shSimpleCmd,shFunction,shFunctionKW,shBang,shGroup,shSubSh,shIf,shFor,shSelect,shWhile,shCase,shDTest
sy cluster shTrailersList contains=shSeparator,shPipe,shAndOr,shTrailerRedir
sy cluster shErrorList contains=shSepError,shRedirError,shThenError,shElifError,shElseError,shFiError,shDoError,shDoneError,shInError,shCaseError,shEsacError,shCurlyError,shParenError,shDTestError

" Word {{{1
" These are 'contained' in shInnerWordsList so that they are treated as part of
" a simple command
if !exists("b:is_kornshell") && !exists("b:is_bash") && !exists("b:is_yash")
    sy match shDollarError contained /\$/
endif
if exists("b:is_kornshell")
    sy region shExtGlob contained start=/[?*+@!]-\?(/ end=/)/ contains=shExtGlobExt
    sy region shExtGlob contained start=/{[[:digit:],]*}-\?(/ end=/)/ contains=shExtGlobExt
    sy region shExtGlobExt contained transparent start=/[%~](/ end=/)/
elseif exists("b:is_bash")
    sy region shExtGlob contained start=/[?*+@!](/ end=/)/
endif
sy match shSepError /[;&|]/
sy match shWordParenError contained /(/
sy match shParamError contained /[^}[:alnum:]_@*#?$!:=+-]/
sy match shBackslash  contained /\\./
sy region shSingleQuote contained matchgroup=shSingleQuoteMark start=/'/ end=/'/ contains=@Spell
if exists("b:is_posix")
    sy region shDollarSingleQuote contained matchgroup=shDollarQuoteMark start=/\$'/ end=/'/ contains=@Spell,shBackslashDSQError,shBackslashDSQ
    if exists("b:is_kornshell")
        sy match shBackslashDSQ contained /\\./
        sy match shBackslashDSQ contained /\\c[@A-Za-z[\]^_?]/
        sy match shBackslashDSQ contained /\\c\\./
        sy match shBackslashDSQ contained /\\\o\{1,3}/
        sy match shBackslashDSQ contained /\\x\x\{,2}/
        sy match shBackslashDSQ contained /\\u\x\{,4}/
        sy match shBackslashDSQ contained /\\U\x\{,8}/
    else
        sy match shBackslashDSQError contained /\\/
        sy match shBackslashDSQ contained /\\[abefnrtv"'\\]/
        sy match shBackslashDSQ contained /\\c[A-Za-z[\]^_?]/
        sy match shBackslashDSQ contained /\\c\\\\/
        sy match shBackslashDSQ contained /\\\o\{1,3}/
        sy match shBackslashDSQ contained /\\x\x\{1,2}/
        if exists("b:is_bash") || exists("b:is_yash")
            sy match shBackslashDSQ contained /\\[E?]/
            sy match shBackslashDSQ contained /\\c@/
            sy match shBackslashDSQ contained /\\u\x\{1,4}/
            sy match shBackslashDSQ contained /\\U\x\{1,8}/
        else
            sy match shBackslashDSQError contained /\\x\x\{3,}/
        endif
    endif
endif
sy region shDoubleQuote contained matchgroup=shDoubleQuoteMark start=/"/ end=/"/ contains=@Spell,shDollarError,shLineCont,shBackslashDQ,shBackquote,shCmdSub,shParameter,shParameterBrace,shArith,shLiteralDSQ
sy match shBackslashDQ contained /\\["`$\\]/
sy region shBackquote contained start=/`/ end=/`/ contains=shBackslashBQ,shCmdSub,shParameter,shParameterBrace,shArith
sy match shBackslashBQ contained /\\[$`\\]/
if exists("b:is_posix")
    sy region shCmdSub contained matchgroup=shParameter start=/\$(/ end=/)/ contains=@shCommandsList nextgroup=shLiteralHash
endif
sy match shParameter contained /\$\h\w*/
sy match shParameter contained /\$\d/
sy match shParameter contained /\$[@*#?$!-]/
sy region shParameterBrace contained matchgroup=shParameter start=/\${/ end=/}/ contains=@shParamOpsList
sy region shParamModifier contained matchgroup=shParamOp start=/:\?[-+?=]/ end=/}\@=/ contains=@shInnerWordsList
if exists("b:is_posix")
    sy match shParamOp contained /{\@1<=#/
    sy region shParamModifier contained matchgroup=shParamOp start=/##\?/ start=/%%\?/ end=/}\@=/ contains=@shInnerWordsList
endif
if exists("b:is_kornshell") || exists("b:is_bash")
    sy match shParamOp contained /{\@1<=!/
    sy region shParamModifier contained matchgroup=shParamOp start=/:[-+?=]\@!/ end=/}\@=/ contains=@shInnerWordsList,shParamColon
    sy region shParamColon contained matchgroup=shParamOp start=/:/ end=/}\@=/ contains=@shInnerWordsList
endif
if exists("b:is_kornshell")
    sy match shParamOp contained /{\@1<=@/
    sy region shParamModifier contained matchgroup=shParamOp start=/:#/ end=/}\@=/ contains=@shInnerWordsList
endif
if exists("b:is_yash")
    sy region shParamNest contained matchgroup=shParamNest start=/{/ end=/}/ contains=@shParamOpsList
    sy region shParamModifier contained matchgroup=shParamOp start=":/" end=/}\@=/ contains=@shInnerWordsList,shParamSlash
    sy cluster shParamOpsList add=shBackquote,shCmdSub,shParameterBrace,shParamNest,shArith
endif
if exists("b:is_kornshell") || exists("b:is_bash") || exists("b:is_yash")
    sy region shParamModifier contained matchgroup=shParamOp start="/[#%/]\?" end=/}\@=/ contains=@shInnerWordsList,shParamSlash
    sy region shParamSlash contained matchgroup=shParamOp start="/" end=/}\@=/ contains=@shInnerWordsList
    sy region shParamModifier contained matchgroup=shParamOp start=/\[/ end=/]/ contains=@shInnerWordsList,shArithParen
endif
if exists("b:is_posix")
    sy region shArith contained matchgroup=shParameter start=/\$((\([^()]*))\@!\)\@!/ end=/))/ contains=@shInnerWordsList,shArithParen nextgroup=shLiteralHash
    sy region shArithParen contained transparent start=/(/ end=/)/ contains=@shInnerWordsList,shArithParen
endif
sy match shLiteralDSQ contained transparent /\$'/ contains=NONE
sy region shComment start=/\<#/ end=/\n\@=/ contains=@Spell,shTodo
" We use end=/\n\@=/ rather than end=/$/. Otherwise some syntax doesn't match
" properly after the comment.
sy match shTodo contained /\w\@1<!\(FIXME\|TODO\|XXX\)\w\@!/
" We use \w\@1< and \w\@! instead of \< and \> to find these keywords adjacent
" to a punctuation like a colon and dot.
sy match shLiteralHash contained transparent /#/ contains=NONE
" Since we define shComment as start=/\<#/, a comment basically does not start
" in the middle of a word. Exceptionally, the \< cannot prevent a #
" immediately following a $(...) from begin regarded as a comment. To work
" around this, shLiteralHash is specified as the nextgroup of shCmdSub and
" shArith so that such a # is not matched by shComment.

" Redirection {{{1
if !exists("b:is_kornshell")
    sy match shRedir contained /\<\d\+[<>]\@=/
    sy match shRedir contained />[>&|]\?/ skipwhite nextgroup=shRedirOperandError
    sy match shRedir contained /<[>&]\?/ skipwhite nextgroup=shRedirOperandError
    sy match shRedir contained /[<>]&\(\d\+\|-\)\>/
    if exists("b:is_bash") || exists("b:is_yash")
        sy match shRedir contained /<<</ skipwhite nextgroup=shRedirOperandError
    endif
    if exists("b:is_bash")
        sy match shRedir contained /&>>\?/ skipwhite nextgroup=shRedirOperandError
    endif
    if exists("b:is_yash")
        sy match shRedir contained />>|\(\d\+\>\)\?/
        sy region shRedirCmd contained matchgroup=shRedir start=/[<>](/ end=/)/ contains=@shCommandsList
    endif
else
    sy match shRedir contained /\<\d[<>]\@=/
    sy match shRedir contained />[>&|]\?/ skipwhite nextgroup=shRedirOperandError
    sy match shRedir contained /<[>&]\?/ skipwhite nextgroup=shRedirOperandError
    sy match shRedir contained /[<>]&\(\d\+\|-\)\>/
    sy match shRedir contained /<<</ skipwhite nextgroup=shRedirOperandError
endif
if exists("b:is_kornshell") || exists("b:is_bash")
    sy region shRedirCmd contained matchgroup=shParameter start=/[<>](/ end=/)/ contains=@shCommandsList
    sy region shRedirLocation contained matchgroup=shRedir start=/\<{\(\k\+}[<>]\)\@=/ end=/}[<>]\@=/
elseif exists("b:is_posix") && !exists("b:is_yash")
    sy region shRedirLocation contained matchgroup=shRedirError start=/\<{\(\k\+}[<>]\)\@=/ end=/}[<>]\@=/
endif
sy match shRedirOperandError contained /[^[:blank:][:keyword:]]\+/

" Here-document {{{1
sy region shRedirHere contained fold matchgroup=shRedir start=/[<>]\@<!\d*<<-\@!\s*\z(\k\+\)$/ end=/^\z1\n\@=/ contains=shBackquote,shCmdSub,shParameter,shParameterBrace,shArith,shBackslashHD,shLineCont
sy region shRedirHere contained fold matchgroup=shRedir start=/[<>]\@<!\d*<<-\s*\z(\k\+\)$/ end=/^\t*\z1\n\@=/ contains=shBackquote,shCmdSub,shParameter,shParameterBrace,shArith,shBackslashHD,shLineCont
sy region shRedirHere contained fold matchgroup=shRedir start=/[<>]\@<!\d*<<-\@!\s*\(["']\)\z([^"'\\]\+\)\1$/ end=/^\z1\n\@=/
sy region shRedirHere contained fold matchgroup=shRedir start=/[<>]\@<!\d*<<-\s*\(["']\)\z([^"'\\]\+\)\1$/ end=/^\t*\z1\n\@=/
sy region shRedirHere contained fold matchgroup=shRedir start=/[<>]\@<!\d*<<-\@!\s*\\\z(\k\+\)$/ end=/^\z1\n\@=/
sy region shRedirHere contained fold matchgroup=shRedir start=/[<>]\@<!\d*<<-\s*\\\z(\k\+\)$/ end=/^\t*\z1\n\@=/
sy match shBackslashHD contained /\\[$`\\]/

" Simple command {{{1
sy region shSimpleCmd transparent start=/[^[:blank:]|&;()]/ end=/$/ end=/[;&|)]/me=e-1 contains=@shWordsList,@shRedirsList,shAssign,shComment nextgroup=@shTrailersList
if exists("b:is_bash")
    sy region shSimpleCmd transparent start=/&>/ end=/$/ end=/[;&|)]/me=e-1 contains=@shWordsList,@shRedirsList,shAssign,shComment nextgroup=@shTrailersList
endif
sy match shAssign contained /\<\h\w*=\@=/ nextgroup=shAssignArray
if exists("b:is_kornshell") || exists("b:is_bash") || exists("b:is_yash")
    sy region shAssignArray contained transparent matchgroup=shOperator start=/=(/hs=s+1 end=/)/ contains=@shWordsList,shComment
endif
sy match shLineCont /\\$/

" Function definition {{{1
sy match shFunction /\h\w*\s*(\s*)/ contains=shFunctionParen
sy match shFunctionParen contained /[()]/
sy match shFunctionNoParen contained /\h\w*/
if exists("b:is_kornshell")
    sy keyword shFunctionKW function skipwhite nextgroup=shFunctionNoParen
endif
if exists("b:is_bash")
    sy keyword shFunctionKW function skipwhite nextgroup=shFunction,shFunctionNoParen
endif
if exists("b:is_yash")
    sy keyword shFunctionKW function skipwhite nextgroup=shFunctionName
    sy region shFunctionName contained start=/\k/ end=/\k\@!/ contains=@shWordsList skipwhite skipempty nextgroup=shFunctionParenPair
    " For unknown reasons start=/\</ does not work. The end cannot be /\>/
    " because the word $(cat) must end after the ) but iskeyword does not
    " contain ) so /\>/ would not match after the ).
    sy match shFunctionParenPair contained /(\s*)/
endif

" Errors {{{1
" shDollarError, shSeparator, shWordParenError and shParamError are defined
" above. shBangError and shCaseCommentError are defined later.
" We use match instead of keyword so other matches and regions can override
" these error cases for highlighting correct occurrences of these keywords.
sy match shThenError  /\<then\>/
sy match shElifError  /\<elif\>/
sy match shElseError  /\<else\>/
sy match shFiError    /\<fi\>/
sy match shDoError    /\<do\>/
sy match shDoneError  /\<done\>/
sy match shInError    /\<in\>/
sy match shCaseError  /;;/
sy match shEsacError  /\<esac\>/
sy match shCurlyError /\<}\>/
sy match shParenError /)/
if exists("b:is_bash")
    sy match shDTestError /\<\]\]\>/
endif

" Bang {{{1
if exists("b:is_posix")
    sy keyword shBang ! skipwhite nextgroup=@shCommandsList,shBangError
    sy keyword shBangError ! contained
endif

" Pipe, and-or list and asynchronous list {{{1
sy match shSeparator contained /;;\@!/
sy match shSeparator contained /&/
sy match shPipe /|/ skipwhite skipempty nextgroup=@shCommandsList,shBangError contained
if exists("b:is_bash")
    sy match shPipe /|&/ skipwhite skipempty nextgroup=@shCommandsList,shBangError contained
endif
sy match shAndOr contained /&&/ skipwhite skipempty nextgroup=@shCommandsList
sy match shAndOr contained /||/ skipwhite skipempty nextgroup=@shCommandsList
sy region shTrailerRedir transparent start=/\d*[<>]/ start=/\\/ end=/$/ end=/[;&|)]/me=e-1 contains=@shWordsList,@shRedirsList,shComment nextgroup=@shTrailersList

" Compound commands {{{1
" Parentheses and braces {{{2
sy region shGroup transparent fold matchgroup=shGroupRegion start=/\<{\>/ end=/\<}\>/ contains=@shCommandsList skipwhite nextgroup=@shTrailersList
sy region shSubSh transparent fold matchgroup=shSubShRegion start=/(/ end=/)/ contains=@shCommandsList skipwhite nextgroup=@shTrailersList

" If statement {{{2
sy region shIf transparent fold matchgroup=shConditional start=/\<if\>/ end=/\<fi\>/ contains=@shCommandsList,shThen skipwhite nextgroup=@shTrailersList
sy region shThen transparent contained matchgroup=shConditional start=/\<then\>/ end=/\<fi\>/me=e-2 contains=@shCommandsList,shElif,shElse
sy region shElif transparent contained matchgroup=shConditional start=/\<elif\>/ end=/\<fi\>/me=e-2 contains=@shCommandsList,shThen
sy region shElse transparent contained matchgroup=shConditional start=/\<else\>/ end=/\<fi\>/me=e-2 contains=@shCommandsList

" For statement {{{2
sy keyword shFor for skipwhite nextgroup=shForWord,shForDParen
sy match shForWord contained /\<\h\w*\>/ skipwhite skipempty nextgroup=shForCommentIn,shForIn,shForDo,shForSemi
sy region shForCommentIn contained start=/\<#/ end=/\n\@=/ contains=@Spell,shTodo skipwhite skipempty nextgroup=shForIn,shForDo,shForCommentIn
sy region shForIn contained transparent matchgroup=shRepeat start=/\<in\>/ matchgroup=shSeparator end=/$/ end=/;/ contains=@shWordsList,shComment skipwhite skipempty nextgroup=shForCommentDo,shForDo
sy region shForCommentDo contained start=/\<#/ end=/\n\@=/ contains=@Spell,shTodo skipwhite skipempty nextgroup=shForDo,shForCommentDo
sy region shForDo contained transparent fold matchgroup=shRepeat start=/\<do\>/ end=/\<done\>/ contains=@shCommandsList skipwhite nextgroup=@shTrailersList
sy match shForSemi contained /;/ skipwhite skipempty nextgroup=shForDo
if exists("b:is_kornshell") || exists("b:is_bash")
    sy region shForDParen contained transparent matchgroup=shFor start=/((/ end=/))/ contains=@shWordsList,shArithParen skipwhite skipempty nextgroup=shForDo,shForSemi
endif

" Select statement {{{2
if exists("b:is_kornshell") || exists("b:is_bash")
    sy keyword shSelect select skipwhite nextgroup=shForWord
endif

" While and until statements {{{2
sy region shWhile transparent fold matchgroup=shRepeat start=/\<while\>/ start=/\<until\>/ end=/\<done\>/ contains=@shCommandsList,shWhileDo skipwhite nextgroup=@shTrailersList
sy region shWhileDo contained transparent matchgroup=shRepeat start=/\<do\>/ end=/\<done\>/me=e-4 contains=@shCommandsList

" Case statement {{{2
sy keyword shCase case skipwhite nextgroup=shCaseWord
sy region shCaseWord contained transparent start=/\k/ end=/\k\@!/ contains=@shWordsList skipwhite skipempty nextgroup=shCaseIn,shCaseComment
" See the comment for shFunctionName above
sy region shCaseIn contained transparent fold matchgroup=shConditional start=/\<in\>/ end=/\<esac\>/ contains=shCasePattern,shComment,@shErrorList skipwhite nextgroup=@shTrailersList
sy region shCaseComment contained start=/\<#/ end=/\n\@=/ contains=@Spell,shTodo skipwhite skipempty nextgroup=shCaseIn
sy region shCasePattern contained transparent matchgroup=NONE start=/#\@!\k/ matchgroup=shOperator start=/(/ end=/)/ contains=@shWordsList,shSepError,shCaseCommentError,shCasePipe skipwhite skipempty nextgroup=shCaseCommand,shCaseDSemi
sy match shCaseCommentError contained /\<#/
sy match shCasePipe contained /|/
if exists("b:is_yash")
    sy region shCaseCommand contained transparent matchgroup=NONE start=/\S/ matchgroup=shSeparator end=/;\(;&\=\|&\||\)/ end=/\<esac\>/me=e-4 contains=@shCommandsList
    sy match shCaseDSemi contained /;\(;&\=\|&\||\)/
elseif exists("b:is_bash")
    sy region shCaseCommand contained transparent matchgroup=NONE start=/\S/ matchgroup=shSeparator end=/;\(;&\=\|&\)/ end=/\<esac\>/me=e-4 contains=@shCommandsList
    sy match shCaseDSemi contained /;\(;&\=\|&\)/
elseif exists("b:is_posix")
    sy region shCaseCommand contained transparent matchgroup=NONE start=/\S/ matchgroup=shSeparator end=/;[;&]/ end=/\<esac\>/me=e-4 contains=@shCommandsList
    sy match shCaseDSemi contained /;[;&]/
else
    sy region shCaseCommand contained transparent matchgroup=NONE start=/\S/ matchgroup=shSeparator end=/;;/ end=/\<esac\>/me=e-4 contains=@shCommandsList
    sy match shCaseDSemi contained /;;/
endif

" [[ construct {{{2
if exists("b:is_kornshell") || exists("b:is_bash") || exists("b:is_yash")
    sy region shDTest transparent matchgroup=shDTestBracket start=/\<\[\[\>/ end=/\<]]\>/ end=/$/ contains=@shInnerWordsList,shDTestOperator skipwhite nextgroup=@shTrailersList
    sy match shDTestOperator contained /[()]/
    sy match shDTestOperator contained /&&/
    sy match shDTestOperator contained /||/
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
hi def link shComment           Comment
hi def link shConditional       Conditional
hi def link shError             Error
hi def link shFunction          Function
hi def link shFunctionName      Function
hi def link shIdentifier        Identifier
hi def link shKeyword           Keyword
hi def link shLabel             Label
hi def link shOperator          Operator
hi def link shParameter         PreProc
hi def link shRepeat            Repeat
hi def link shSpecialChar       SpecialChar
hi def link shString            String
hi def link shTodo              Todo

hi def link shBackslashDSQError shError
hi def link shBangError         shError
hi def link shCaseError         shError
hi def link shCaseCommentError  shError
hi def link shCurlyError        shError
hi def link shDoError           shError
hi def link shDollarError       shError
hi def link shDoneError         shError
hi def link shElifError         shError
hi def link shElseError         shError
hi def link shEsacError         shError
hi def link shFiError           shError
hi def link shInError           shError
hi def link shParamError        shError
hi def link shParenError        shError
hi def link shRedirError        shError
hi def link shRedirOperandError shError
hi def link shSepError          shError
hi def link shThenError         shError
hi def link shWordParenError    shError
hi def link shDTestError        shError

hi def link shBackslash         shSpecialChar
hi def link shSingleQuote       shString
hi def link shDollarSingleQuote shString
hi def link shDoubleQuote       shString
hi def link shSingleQuoteMark   shOperator
hi def link shDollarQuoteMark   shOperator
hi def link shDoubleQuoteMark   shOperator
hi def link shBackslashDQ       shSpecialChar
hi def link shBackquote         shParameter
hi def link shBackslashBQ       shSpecialChar
hi def link shCmdSub            Normal
hi def link shParameterBrace    shParameter
hi def link shParamOp           shOperator
hi def link shParamModifier     Normal
hi def link shParamNest         shParameter
hi def link shArith             Normal
hi def link shExtGlob           shSpecialChar

hi def link shRedir             shOperator
hi def link shRedirCmd          Normal
hi def link shRedirLocation     shIdentifier
hi def link shRedirHere         shString
hi def link shBackslashHD       shSpecialChar
hi def link shLineCont          shSpecialChar
hi def link shAssign            shIdentifier
hi def link shFunctionParen     shOperator
hi def link shFunctionParenPair shOperator
hi def link shFunctionKW        shKeyword
hi def link shFunctionNoParen   shFunction
hi def link shBang              shKeyword
hi def link shSeparator         shOperator
hi def link shPipe              shOperator
hi def link shAndOr             shOperator

hi def link shGroupRegion       shKeyword
hi def link shSubShRegion       shOperator
hi def link shFor               shRepeat
hi def link shForWord           shIdentifier
hi def link shForCommentIn      shComment
hi def link shForCommentDo      shComment
hi def link shForSemi           shSeparator
hi def link shSelect            shRepeat
hi def link shCase              shConditional
hi def link shCaseComment       shComment
hi def link shCasePipe          shSeparator
hi def link shCaseDSemi         shSeparator
hi def link shDTestBracket      shOperator
hi def link shDTestOperator     shOperator

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

" vim: et sw=4 sts=4 fdm=marker
