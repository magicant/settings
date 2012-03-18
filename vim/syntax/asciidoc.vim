" Vim syntax file
" Language: Asciidoc text document
" Maintainer: WATANABE Yuki <magicant.starmen AT nifty.com>,
"             based on Dag Wieers and Stuart Rackham's work.
" License: GPL (http://www.gnu.org)
" Remarks: Vim 6 or greater
" Limitations: See 'Appendix E: Vim Syntax Highlighter' in the AsciiDoc 'User
"               Guide'.
" Last Change: 2012-02-05

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
syn match asciidocListBlockDelimiter /^--$/
syn match asciidocLineBreak /[ \t]+$/
syn match asciidocRuler /^'\{3,}$/
syn match asciidocPagebreak /^<\{3,}$/
syn match asciidocEntityRef /\\\@<!&[#a-zA-Z]\S\{-};/
" FIXME: The tricky part is not triggering on indented list items that are also
" preceded by blank line, handles only bulleted items (see 'Limitations' above
" for workarounds).
"syn region asciidocLiteralParagraph start="^\n[ \t]\+\(\([^-*. \t] \)\|\(\S\S\)\)" end="\(^+\?\s*$\)\@="
syn region asciidocLiteralParagraph start=/^\s\+\S\+/ end=/\(^+\?\s*$\)\@=/
syn match asciidocURL /\\\@<!\<\(http\|https\|ftp\|file\|irc\):\/\/[^| \t]*\(\w\|\/\)/
syn match asciidocEmail /[\\.:]\@<!\(\<\|<\)\w\(\w\|[.-]\)*@\(\w\|[.-]\)*\w>\?[0-9A-Za-z_]\@!/
syn match asciidocAttributeRef /\\\@<!{\w\(\w\|-\)*\([=!@#$%?:].*\)\?}/


" As a damage control measure quoted patterns always terminate at a blank
" line (see 'Limitations' above).
syn match asciidocQuotedSubscript /\\\@<!\~\S\_.\{-}\(\~\|\n\s*\n\)/
syn match asciidocQuotedSuperscript /\\\@<!\^\S\_.\{-}\(\^\|\n\s*\n\)/

syn match asciidocQuotedMonospaced /\(^\|[| \t([.,=\-\]]\)\@<=+\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(+\([| \t)[\],.?!;:=\-]\|$\)\@=\)/
syn match asciidocQuotedMonospaced /\(^\|[| \t([.,=\-\]]\)\@<=`\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(`\([| \t)[\],.?!;:=\-]\|$\)\@=\)/
syn match asciidocQuotedUnconstrainedMonospaced /[\\+]\@<!++\S\_.\{-}\(++\|\n\s*\n\)/

syn match asciidocQuotedEmphasized /\(^\|[| \t([.,=\-\]]\)\@<=_\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(_\([| \t)[\],.?!;:=\-]\|$\)\@=\)/
syn match asciidocQuotedEmphasized /\(^\|[| \t([.,=\-\]]\)\@<='\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\('\([| \t)[\],.?!;:=\-]\|$\)\@=\)/
syn match asciidocQuotedUnconstrainedEmphasized /\\\@<!__\S\_.\{-}\(__\|\n\s*\n\)/

syn match asciidocQuotedBold /\(^\|[| \t([.,=\-\]]\)\@<=\*\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(\*\([| \t)[\],.?!;:=\-]\|$\)\@=\)/
syn match asciidocQuotedUnconstrainedBold /\\\@<!\*\*\S\_.\{-}\(\*\*\|\n\s*\n\)/

" Don't allow ` in single quoted (a kludge to stop confusion with `monospaced`).
syn match asciidocQuotedSingleQuoted /\(^\|[| \t([.,=\-]\)\@<=`\([ )\n\t]\)\@!\([^`]\|\n\(\s*\n\)\@!\)\{-}[^` \t]\('\([| \t)[\],.?!;:=\-]\|$\)\@=\)/

syn match asciidocQuotedDoubleQuoted /\(^\|[| \t([.,=\-]\)\@<=``\([ )\n\t]\)\@!\(.\|\n\(\s*\n\)\@!\)\{-}\S\(''\([| \t)[\],.?!;:=\-]\|$\)\@=\)/

syn match asciidocDoubleDollarPassthrough /\\\@<!\(^\|[^0-9a-zA-Z$]\)\@<=\$\$..\{-}\(\$\$\([^0-9a-zA-Z$]\|$\)\@=\|^$\)/
syn match asciidocTriplePlusPassthrough /\\\@<!\(^\|[^0-9a-zA-Z$]\)\@<=+++..\{-}\(+++\([^0-9a-zA-Z$]\|$\)\@=\|^$\)/

syn region asciidocTable_OLD start=/^\([`.']\d*[-~_]*\)\+[-~_]\+\d*$/ end=/^$/
syn match asciidocBlockTitle /^\.[^. \t].*[^-~_]$/ contains=asciidocQuoted.*,asciidocAttributeRef
syn match asciidocTitleUnderline /[-=~^+]\{2,}$/ transparent contained contains=NONE
syn match asciidocOneLineTitle /^=\{1,5}\s\+\S.*$/ contains=asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash
syn match asciidocTwoLineTitle /^[^. +/].*[^.]\n[-=~^+]\{2,}$/ contains=asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash,asciidocTitleUnderline

syn match asciidocAttributeList /^\[[^[ \t].*\]$/
syn match asciidocQuoteBlockDelimiter /^_\{4,}$/
syn match asciidocExampleBlockDelimiter /^=\{4,}$/
syn match asciidocSidebarDelimiter /^*\{4,}$/

syn match asciidocAdmonitionNote /^\(NOTE\|TIP\):\(\s\+.*\)\@=/
syn match asciidocAdmonitionNote /^\[\(NOTE\|TIP\)\]\s*$/
syn match asciidocAdmonitionWarn /^\(CAUTION\|IMPORTANT\|WARNING\):\(\s\+.*\)\@=/
syn match asciidocAdmonitionWarn /^\[\(CAUTION\|IMPORTANT\|WARNING\)\]\s*$/

" See http://vimdoc.sourceforge.net/htmldoc/usr_44.html for excluding region
" contents from highlighting.
syn match asciidocTablePrefix /\(\S\@<!\(\([0-9.]\+\)\([*+]\)\)\?\([<\^>.]\{,3}\)\?\([a-z]\)\?\)\?|/ containedin=asciidocTableBlock contained
syn region asciidocTableBlock matchgroup=asciidocTableDelimiter start=/^|=\{3,}$/ end=/^|=\{3,}$/ keepend contains=ALL
syn match asciidocTablePrefix /\(\S\@<!\(\([0-9.]\+\)\([*+]\)\)\?\([<\^>.]\{,3}\)\?\([a-z]\)\?\)\?!/ containedin=asciidocTableBlock contained
syn region asciidocTableBlock2 matchgroup=asciidocTableDelimiter2 start=/^!=\{3,}$/ end=/^!=\{3,}$/ keepend contains=ALL

syn match asciidocListContinuation /^+$/
syn region asciidocLiteralBlock start=/^\.\{4,}$/ end=/^\.\{4,}$/ contains=asciidocCallout keepend
syn region asciidocListingBlock start=/^-\{4,}$/ end=/^-\{4,}$/ contains=asciidocCallout keepend
syn region asciidocCommentBlock start="^/\{4,}$" end="^/\{4,}$" contains=asciidocToDo
syn region asciidocPassthroughBlock start="^+\{4,}$" end="^+\{4,}$"

" Allowing leading \w characters in the filter delimiter is to accomodate
" the pre version 8.2.7 syntax and may be removed in future releases.
syn region asciidocFilterBlock start=/^\w*\~\{4,}$/ end=/^\w*\~\{4,}$/

syn region asciidocMacroAttributes matchgroup=asciidocRefMacro start=/\\\@<!<<"\{-}\w\(\w\|-\)*"\?,\?/ end=/\(>>\)\|^$/ contains=asciidocQuoted.* keepend
syn region asciidocMacroAttributes matchgroup=asciidocAnchorMacro start=/\\\@<!\[\{2}\(\w\|-\)\+,\?/ end=/\]\{2}/ keepend
syn region asciidocMacroAttributes matchgroup=asciidocAnchorMacro start=/\\\@<!\[\{3}\(\w\|-\)\+/ end=/\]\{3}/ keepend
syn region asciidocMacroAttributes matchgroup=asciidocMacro start=/[\\0-9a-zA-Z]\@<!\w\(\w\|-\)*:\S\{-}\[/ skip=/\\\]/ end=/\]\|^$/ contains=asciidocQuoted.* keepend
syn region asciidocMacroAttributes matchgroup=asciidocIndexTerm start=/\\\@<!(\{2,3}/ end=/)\{2,3}/ contains=asciidocQuoted.* keepend
syn region asciidocMacroAttributes matchgroup=asciidocAttributeMacro start=/\({\(\w\|-\)\+}\)\@<=\[/ skip=/\\\]/ end=/\]/ keepend

syn match asciidocCommentLine "^//\([^/].*\|\)$" contains=asciidocToDo

syn region asciidocAttributeEntry start=/^:\a/ end=/:\(\s\|$\)/ oneline

" Lists.
syn match asciidocListBullet /^\s*\zs\(-\|\*\{1,5}\)\ze\s/
syn match asciidocListNumber /^\s*\zs\(\(\d\+\.\)\|\.\{1,5}\|\(\a\.\)\|\([ivxIVX]\+)\)\)\ze\s\+/
syn region asciidocListLabel start=/^\s*/ end=/\(:\{2,4}\|;;\)$/ oneline contains=asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash keepend
" DEPRECATED: Horizontal label.
syn region asciidocHLabel start=/^\s*/ end=/\(::\|;;\)\(\s\+\|\\$\)/ oneline contains=asciidocQuoted.*,asciidocMacroAttributes keepend
" Starts with any of the above.
syn region asciidocList start=/^\s*\(-\|\*\{1,5}\)\s/ start=/^\s*\(\(\d\+\.\)\|\.\{1,5}\|\(\a\.\)\|\([ivxIVX]\+)\)\)\s\+/ start=/.\+\(:\{2,4}\|;;\)$/ end=/\(^[=*]\{4,}$\)\@=/ end=/\(^+\?\s*$\)\@=/ contains=asciidocList.\+,asciidocQuoted.*,asciidocMacroAttributes,asciidocAttributeRef,asciidocEntityRef,asciidocEmail,asciidocURL,asciidocBackslash,asciidocCommentLine,asciidocAttributeList

"====================== OLD STUFF ============================

"Sections
syn region asciidocSect0 start=/^=\s\+\S/ end=/$/ oneline contains=asciidocQuoted.*,asciidocAttributeRef
syn region asciidocSect1 start=/^==\s\+\S/ end=/$/ oneline contains=asciidocQuoted.*,asciidocAttributeRef
syn region asciidocSect2 start=/^===\s\+\S/ end=/$/ oneline contains=asciidocQuoted.*,asciidocAttributeRef
syn region asciidocSect3 start=/^====\s\+\S/ end=/$/ oneline contains=asciidocQuoted.*,asciidocAttributeRef
syn region asciidocSect4 start=/^=====\s\+\S/ end=/$/ oneline contains=asciidocQuoted.*,asciidocAttributeRef

"FIXME: It is impossible to distinguish underlined titles from block delimiters
"       because we cannot calculate length in VIM syntax
syn match asciidocSect0Old /^[^. +/[].*[^.:]\n==\+$/ contains=asciidocQuoted.*,asciidocAttributeRef
syn match asciidocSect1Old /^[^. +/[].*[^.:]\n--\+$/ contains=asciidocQuoted.*,asciidocAttributeRef
syn match asciidocSect2Old /^[^. +/[].*[^.:]\n\~\~\+$/ contains=asciidocQuoted.*,asciidocAttributeRef
syn match asciidocSect3Old /^[^. +/[].*[^.:]\n^^\+$/ contains=asciidocQuoted.*,asciidocAttributeRef
syn match asciidocSect4Old /^[^. +/[].*[^.:]\n++\+$/ contains=asciidocQuoted.*,asciidocAttributeRef

"Others
syn match asciidocReplacements "[\s^]\(\(C\)\|\(TM\)\|\(R\)\|--\|\.\.\.\)[\s$]"
syn match asciidocRevisionInfo "\$\w\+\(:\s.\+\s\)\?\$"
syn match asciidocBiblio "^\s*+\s\+"
syn match asciidocSource "^\s\s*\$\s\+.\+$"
"syn match asciidocSpecialChar "{amp}\w+;"
syn region asciidocQuestion start="\S" end="??\s*$" oneline
syn region asciidocGlossary start="\S" end=":-\s*$" oneline
"syn match asciidocFootnote "footnote:\[.*\]"
"syn match asciidocLink "link:.*\[.*\]"
"syn match asciidocURI "\(callto\|file\|ftp\|gopher\|http\|https\|mailto\|news\|xref\):.*\[\]"
"syn match asciidocURITitle "\(callto\|file\|ftp\|gopher\|http\|https\|mailto\|news\|xref\):.*\[.*\]"
"syn match asciidocInclude "include::.*\[.*\]"
"syn match asciidocInclude "include1::.*\[.*\]"
"syn match asciidocInclude "image:.*\[.*\]"
"syn match asciidocInclude "image::.*\[.*\]"
"syn match asciidocInclude "footnote:\[.*\]"
"syn match asciidocInclude "indexterm:\[.*\]"
"syn match asciidocInclude "ifdef::.*\[\]"
"syn match asciidocInclude "ifndef::.*\[\]"
"syn match asciidocInclude "endif::.*\[\]"
"syn match asciidocInclude "eval::\[\]"
"syn match asciidocInclude "sys::\[\]"
"syn match asciidocInclude "sys2::\[\]"

"Styles
hi def asciidocBold term=bold cterm=bold gui=bold
hi def asciidocItalic term=italic cterm=italic gui=italic
hi def asciidocUnderlined term=underline cterm=underline gui=underline

hi def link asciidocAdmonitionNote Todo
hi def link asciidocAdmonitionWarn Todo
hi def link asciidocBackslash SpecialChar
hi def link asciidocBiblio Operator
hi def link asciidocDoubleDollarPassthrough Identifier
hi def link asciidocFootnote PreProc
hi def link asciidocGlossary Keyword
hi def link asciidocHLabel Keyword
hi def link asciidocInclude Include
hi def link asciidocQuestion Keyword
hi def link asciidocQuotedBold asciidocBold
hi def link asciidocQuotedDoubleQuoted String
hi def link asciidocQuotedEmphasized asciidocItalic
hi def link asciidocQuotedMonospaced String
hi def link asciidocQuotedUnconstrainedBold asciidocBold
hi def link asciidocQuotedUnconstrainedEmphasized asciidocItalic
hi def link asciidocQuotedUnconstrainedMonospaced String
hi def link asciidocQuotedSingleQuoted String
hi def link asciidocQuotedSubscript Operator
hi def link asciidocQuotedSuperscript Operator
hi def link asciidocReference Operator
hi def link asciidocReplacements SpecialChar
hi def link asciidocRevisionInfo PreProc
hi def link asciidocSource PreProc
hi def link asciidocToDo Todo
hi def link asciidocTripplePlusPassthrough Identifier

"Attributes
hi def link asciidocAttributeEntry Type
hi def link asciidocAttributeList Operator
hi def link asciidocAttributeMacro Identifier
"hi def asciidocAttributeRef term=standout ctermfg=darkgreen cterm=bold guifg=darkgreen gui=bold
hi def link asciidocAttributeRef Underlined

"Lists
hi def link asciidocListBlockDelimiter Operator
hi def link asciidocListBullet Operator
hi def link asciidocListContinuation Operator
hi def link asciidocListLabel Label
hi def link asciidocListNumber Label

"Sections
hi def link asciidocSect0 Statement
hi def link asciidocSect1 Statement
hi def link asciidocSect2 Statement
hi def link asciidocSect3 Statement
hi def link asciidocSect4 Statement
hi def link asciidocSect0Old Statement
hi def link asciidocSect1Old Statement
hi def link asciidocSect2Old Statement
hi def link asciidocSect3Old Statement
hi def link asciidocSect4Old Statement

"Links
hi def link asciidocEmail Underlined
hi def link asciidocLink Underlined
hi def link asciidocOneLineTitle Underlined
hi def link asciidocTwoLineTitle Underlined
hi def link asciidocURL Underlined

"Blocks
hi def link asciidocBlockTitle Operator
hi def link asciidocExampleBlockDelimiter Operator
hi def link asciidocFilterBlock Operator
hi def link asciidocListingBlock Operator
hi def link asciidocLiteralBlock Operator
hi def link asciidocLiteralParagraph Operator
hi def link asciidocQuoteBlockDelimiter Operator
hi def link asciidocSidebarDelimiter Operator

"Tables
hi def link asciidocTableBlock2 NONE
hi def link asciidocTableBlock NONE
hi def link asciidocTableDelimiter2 Operator
hi def link asciidocTableDelimiter Operator
hi def link asciidocTable_OLD Operator
hi def link asciidocTablePrefix2 Operator
hi def link asciidocTablePrefix Operator

"Comments
hi def link asciidocCommentBlock Comment
hi def link asciidocCommentLine Comment

"Macros
hi def link asciidocAnchorMacro Identifier
hi def link asciidocIndexTerm Identifier
hi def link asciidocMacro Identifier
hi def link asciidocMacroAttributes Macro
hi def link asciidocRefMacro Identifier

"Other
hi def link asciidocCallout Label
hi def link asciidocEntityRef Special
hi def link asciidocIdMarker Special
hi def link asciidocLineBreak Special
hi def link asciidocPagebreak Operator
hi def link asciidocPassthroughBlock Identifier
hi def link asciidocRuler Operator

setlocal formatoptions+=tcqn

if version >= 700
    "Prevent simple numbers at the start of lines to be confused with list items:
    setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+
endif

setlocal comments=s1:/*,ex:*/,://,b:#,:%,fb:-,fb:*,fb:.,fb:+,fb:>
