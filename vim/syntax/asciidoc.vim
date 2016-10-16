" Vim syntax file
" Language:     AsciiDoc
" Author:       Stuart Rackham <srackham@gmail.com> (inspired by Felix
"               Obenhuber's original asciidoc.vim script).
" Maintainer:   WATANABE Yuki <magicant@wonderwand.net>,
" Licence:      GPL (http://www.gnu.org)
" Remarks:      Vim 6 or greater
" Limitations:  See 'Appendix E: Vim Syntax Highlighter' in the AsciiDoc 'User
"               Guide'.
" Last Change:  2013-02-24

if exists("b:current_syntax")
    finish
endif
let b:current_syntax = "asciidoc"

syn sync fromstart
syn sync linebreaks=1

" Run :help syn-priority to review syntax matching priority.
syn keyword asciidocToDo TODO FIXME CHECK TEST XXX ZZZ DEPRECATED contained
syn match asciidocBackslash /\\/
syn region asciidocIdMarker start=/^\$Id:\s/ end=/\s\$$/
syn match asciidocCallout /\\\@<!<\d\{1,2}>/
syn match asciidocOpenBlockDelimiter /^--$/
syn match asciidocLineBreak /[ \t]+$/
syn match asciidocRuler /^'\{3,}$/
syn match asciidocPagebreak /^<\{3,}$/
syn match asciidocEntityRef /\\\@<!&[#a-zA-Z]\S\{-};/
syn region asciidocLiteralParagraph start=/\(\%^\|\_^\n\)\@<=\s\+\S\+/ end=/\(^\(+\|--\)\?\s*$\)\@=/ contains=asciidocToDo
syn match asciidocURL /\\\@<!\<\(http\|https\|ftp\|file\|irc\):\/\/[^| \t]*\(\w\|\/\)/
syn match asciidocEmail /[\\.:]\@<!\(\<\|<\)\w\(\w\|[.-]\)*@\(\w\|[.-]\)*\w>\?[0-9A-Za-z_]\@!/
syn match asciidocAttributeRef /\\\@<!{\w\(\w\|[-,+]\)*\([=!@#$%?:].*\)\?}/

" As a damage control measure quoted patterns always terminate at a blank
" line (see 'Limitations' above).
syn match asciidocQuotedAttributeList /\\\@<!\[[a-zA-Z0-9_-][a-zA-Z0-9 _-]*\][+_'`#*]\@=/
syn match asciidocQuotedSubscript /\\\@<!\~\S\_.\{-}\(\~\|\n\s*\n\)/ contains=asciidocEntityRef
syn match asciidocQuotedSuperscript /\\\@<!\^\S\_.\{-}\(\^\|\n\s*\n\)/ contains=asciidocEntityRef

syn match asciidocQuotedMonospaced /\(^\|[| \t([.,=\]]\)\@<=+\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(+\([| \t)[\],.?!;:=]\|$\)\@=\)/ contains=asciidocEntityRef
syn match asciidocQuotedMonospaced2 /\(^\|[| \t([.,=\]]\)\@<=`\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(`\([| \t)[\],.?!;:=]\|$\)\@=\)/
syn match asciidocQuotedUnconstrainedMonospaced /[\\+]\@<!++\S\_.\{-}\(++\|\n\s*\n\)/ contains=asciidocEntityRef

syn match asciidocQuotedEmphasized /\(^\|[| \t([.,=\]]\)\@<=_\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(_\([| \t)[\],.?!;:=]\|$\)\@=\)/ contains=asciidocEntityRef
syn match asciidocQuotedEmphasized2 /\(^\|[| \t([.,=\]]\)\@<='\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\('\([| \t)[\],.?!;:=]\|$\)\@=\)/ contains=asciidocEntityRef
syn match asciidocQuotedUnconstrainedEmphasized /\\\@<!__\S\_.\{-}\(__\|\n\s*\n\)/ contains=asciidocEntityRef

syn match asciidocQuotedBold /\(^\|[| \t([.,=\]]\)\@<=\*\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(\*\([| \t)[\],.?!;:=]\|$\)\@=\)/ contains=asciidocEntityRef
syn match asciidocQuotedUnconstrainedBold /\\\@<!\*\*\S\_.\{-}\(\*\*\|\n\s*\n\)/ contains=asciidocEntityRef

" Don't allow ` in single quoted (a kludge to stop confusion with `monospaced`).
syn match asciidocQuotedSingleQuoted /\(^\|[| \t([.,=\]]\)\@<=`\([ )\n\t]\)\@!\([^`]\|\n\(\s*\n\)\@!\)\{-}[^` \t]\('\([| \t)[\],.?!;:=]\|$\)\@=\)/ contains=asciidocEntityRef

syn match asciidocQuotedDoubleQuoted /\(^\|[| \t([.,=\]]\)\@<=``\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(''\([| \t)[\],.?!;:=]\|$\)\@=\)/ contains=asciidocEntityRef

syn match asciidocDoubleDollarPassthrough /\\\@<!\(^\|[^0-9a-zA-Z$]\)\@<=\$\$..\{-}\(\$\$\([^0-9a-zA-Z$]\|$\)\@=\|^$\)/
syn match asciidocTriplePlusPassthrough /\\\@<!\(^\|[^0-9a-zA-Z$]\)\@<=+++..\{-}\(+++\([^0-9a-zA-Z$]\|$\)\@=\|^$\)/

syn match asciidocAdmonition /^\u\{3,15}:\(\s\+.*\)\@=/

syn region asciidocTable_OLD start=/^\([`.']\d*[-~_]*\)\+[-~_]\+\d*$/ end=/^$/
syn match asciidocBlockTitle /^\.[^. \t].*[^-~_]$/ contains=asciidocQuoted.*,asciidocAttributeRef
syn match asciidocTitleUnderline /[-=~^+]\{2,}$/ transparent contained contains=NONE
syn match asciidocOneLineTitle /^=\{1,5}\s\+\S.*$/ contains=asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash
syn match asciidocTwoLineTitle /^[^. +/].*[^.]\n[-=~^+]\{3,}$/ contains=asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash,asciidocTitleUnderline

syn match asciidocAttributeList /^\[[^[ \t].*\]$/
syn match asciidocQuoteBlockDelimiter /^_\{4,}$/
syn match asciidocExampleBlockDelimiter /^=\{4,}$/
syn match asciidocSidebarDelimiter /^*\{4,}$/

" See http://vimdoc.sourceforge.net/htmldoc/usr_44.html for excluding region
" contents from highlighting.
syn match asciidocTablePrefix /\(\S\@<!\(\([0-9.]\+\)\([*+]\)\)\?\([<\^>.]\{,3}\)\?\([a-z]\)\?\)\?|/ containedin=asciidocTableBlock contained
syn region asciidocTableBlock matchgroup=asciidocTableDelimiter start=/^|=\{3,}$/ end=/^|=\{3,}$/ keepend contains=ALL
syn match asciidocTablePrefix /\(\S\@<!\(\([0-9.]\+\)\([*+]\)\)\?\([<\^>.]\{,3}\)\?\([a-z]\)\?\)\?!/ containedin=asciidocTableBlock contained
syn region asciidocTableBlock2 matchgroup=asciidocTableDelimiter2 start=/^!=\{3,}$/ end=/^!=\{3,}$/ keepend contains=ALL

syn match asciidocListContinuation /^+$/
syn region asciidocLiteralBlock start=/^\.\{4,}$/ end=/^\.\{4,}$/ contains=asciidocCallout,asciidocToDo keepend
syn region asciidocListingBlock start=/^-\{4,}$/ end=/^-\{4,}$/ contains=asciidocCallout,asciidocToDo keepend
syn region asciidocCommentBlock start="^/\{4,}$" end="^/\{4,}$" contains=asciidocToDo
syn region asciidocPassthroughBlock start="^+\{4,}$" end="^+\{4,}$"

" Allowing leading \w characters in the filter delimiter is to accomodate
" the pre version 8.2.7 syntax and may be removed in future releases.
syn region asciidocFilterBlock start=/^\w*\~\{4,}$/ end=/^\w*\~\{4,}$/

syn region asciidocMacroAttributes matchgroup=asciidocRefMacro start=/\\\@<!<<"\{-}\(\w\|-\|_\|:\|\.\)\+"\?,\?/ end=/\(>>\)\|^$/ contains=asciidocQuoted.* keepend
syn region asciidocMacroAttributes matchgroup=asciidocAnchorMacro start=/\\\@<!\[\{2}\(\w\|-\|_\|:\|\.\)\+,\?/ end=/\]\{2}/ keepend
syn region asciidocMacroAttributes matchgroup=asciidocAnchorMacro start=/\\\@<!\[\{3}\(\w\|-\|_\|:\|\.\)\+/ end=/\]\{3}/ keepend
syn region asciidocMacroAttributes matchgroup=asciidocMacro start=/[\\0-9a-zA-Z]\@<!\w\(\w\|-\)*:\S\{-}\[/ skip=/\\\]/ end=/\]\|^$/ contains=asciidocQuoted.*,asciidocAttributeRef,asciidocEntityRef keepend
" Highlight macro that starts with an attribute reference (a common idiom).
syn region asciidocMacroAttributes matchgroup=asciidocMacro start=/\(\\\@<!{\w\(\w\|[-,+]\)*\([=!@#$%?:].*\)\?}\)\@<=\S\{-}\[/ skip=/\\\]/ end=/\]\|^$/ contains=asciidocQuoted.*,asciidocAttributeRef keepend
syn region asciidocMacroAttributes matchgroup=asciidocIndexTerm start=/\\\@<!(\{2,3}/ end=/)\{2,3}/ contains=asciidocQuoted.*,asciidocAttributeRef keepend

syn match asciidocCommentLine "^//\([^/].*\|\)$" contains=asciidocToDo

syn region asciidocAttributeEntry start=/^:\w/ end=/:\(\s\|$\)/ oneline

" Lists.
syn match asciidocListBullet /^\s*\zs\(-\|\*\{1,5}\)\ze\s/
syn match asciidocListNumber /^\s*\zs\(\(\d\+\.\)\|\.\{1,5}\|\(\a\.\)\|\([ivxIVX]\+)\)\)\ze\s\+/
syn region asciidocListLabel start=/^\s*/ end=/\(:\{2,4}\|;;\)$/ oneline contains=asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash,asciidocToDo keepend
" DEPRECATED: Horizontal label.
syn region asciidocHLabel start=/^\s*/ end=/\(::\|;;\)\(\s\+\|\\$\)/ oneline contains=asciidocQuoted.*,asciidocMacroAttributes keepend
" Starts with any of the above.
syn region asciidocList start=/^\s*\(-\|\*\{1,5}\)\s/ start=/^\s*\(\(\d\+\.\)\|\.\{1,5}\|\(\a\.\)\|\([ivxIVX]\+)\)\)\s\+/ start=/.\+\(:\{2,4}\|;;\)$/ end=/\(^[=*]\{4,}$\)\@=/ end=/\(^+\?\s*$\)\@=/ contains=asciidocList.\+,asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash,asciidocCommentLine,asciidocAttributeList,asciidocToDo

highlight def link asciidocAdmonition Special
highlight def link asciidocAnchorMacro Macro
highlight def link asciidocAttributeEntry Special
highlight def link asciidocAttributeList Special
highlight def link asciidocAttributeMacro Macro
highlight def link asciidocAttributeRef Special
highlight def link asciidocBackslash Special
highlight def link asciidocBlockTitle Title
highlight def link asciidocCallout Label
highlight def link asciidocCommentBlock Comment
highlight def link asciidocCommentLine Comment
highlight def link asciidocDoubleDollarPassthrough Special
highlight def link asciidocEmail Macro
highlight def link asciidocEntityRef Special
highlight def link asciidocExampleBlockDelimiter Type
highlight def link asciidocFilterBlock Type
highlight def link asciidocHLabel Label
highlight def link asciidocIdMarker Special
highlight def link asciidocIndexTerm Macro
highlight def link asciidocLineBreak Special
highlight def link asciidocOpenBlockDelimiter Label
highlight def link asciidocListBullet Label
highlight def link asciidocListContinuation Label
highlight def link asciidocListingBlock Identifier
highlight def link asciidocListLabel Label
highlight def link asciidocListNumber Label
highlight def link asciidocLiteralBlock Identifier
highlight def link asciidocLiteralParagraph Identifier
highlight def link asciidocMacroAttributes Label
highlight def link asciidocMacro Macro
highlight def link asciidocOneLineTitle Title
highlight def link asciidocPagebreak Type
highlight def link asciidocPassthroughBlock Identifier
highlight def link asciidocQuoteBlockDelimiter Type
highlight def link asciidocQuotedAttributeList Special
highlight def link asciidocQuotedBold Special
highlight def link asciidocQuotedDoubleQuoted Label
highlight def link asciidocQuotedEmphasized2 Type
highlight def link asciidocQuotedEmphasized Type
highlight def link asciidocQuotedMonospaced2 Identifier
highlight def link asciidocQuotedMonospaced Identifier
highlight def link asciidocQuotedSingleQuoted Label
highlight def link asciidocQuotedSubscript Type
highlight def link asciidocQuotedSuperscript Type
highlight def link asciidocQuotedUnconstrainedBold Special
highlight def link asciidocQuotedUnconstrainedEmphasized Type
highlight def link asciidocQuotedUnconstrainedMonospaced Identifier
highlight def link asciidocRefMacro Macro
highlight def link asciidocRuler Type
highlight def link asciidocSidebarDelimiter Type
highlight def link asciidocTableBlock2 NONE
highlight def link asciidocTableBlock NONE
highlight def link asciidocTableDelimiter2 Label
highlight def link asciidocTableDelimiter Label
highlight def link asciidocTable_OLD Type
highlight def link asciidocTablePrefix2 Label
highlight def link asciidocTablePrefix Label
highlight def link asciidocToDo Todo
highlight def link asciidocTriplePlusPassthrough Special
highlight def link asciidocTwoLineTitle Title
highlight def link asciidocURL Macro

setlocal formatoptions+=tcqn

if version >= 700
    "Prevent simple numbers at the start of lines from being confused with list items:
    setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+
endif

" vim: et sw=4 sts=4
