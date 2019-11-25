" GitHub Actions Workflow (.workflow) syntax file
" Language:     GitHub Actions Workflow
" Last change:  2019-11-25 by Fionn

" Usage:
"   1. Copy this file to ~/.vim/syntax/workflow.vim
"   2. Detect workflow filetypes in ~/.vim/syntax/ftdetect/workflow.vim:
" >
" au BufNewFile,BufRead *.workflow setfiletype workflow
" <
"   3. Enable syntax in your vimrc:
" >
" syntax enable
" <


if exists("b:current_syntax")
  finish
endif

syn case match

syn keyword  gfTask        action
syn keyword  gfAttribute   workflow on resolves
syn keyword  gfAttribute   runs args needs secrets env uses
syn keyword  gfRepeat      run with uses steps jobs
syn keyword  gfRepeat      name nextgroup=gfName skipnl
syn keyword  gfOS          windows ubuntu macOS latest
syn keyword  gfEvent       check_run check_suite commit_comment create delete deployment deployment_status fork gollum issue_comment issues label member milestone page_build project project_card project_column public pull_request pull_request_review_comment pull_request_review push repository_dispatch release scheduled status watch

syn region  gfCommentL     start="//" end="$" keepend
syn region  gfCommentL     start="#" end="$" keepend
syn region  gfComment      start="/\*" end="\*/"
syn region  gfString       start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=gfInterp
syn region  gfRegex        start="m/" skip=+\\/+ end="/"
syn region  gfInterp       start=/\${/ end=/}/
syn region  gfInterp       start=/\${{/ end=/}}/

syn match   gfNumbers      display transparent "\<\d\|\.\d" contains=gfNumber
syn match   gfNumber       display contained "\d\+[a-z]*"
syn match   gfBraces       "[{}\[\]]"
syn match   gfOperator     "[:|]"
syn match   gfName         ': \p\+' contained

hi def link gfText Normal
hi def link gfTask Keyword
hi def link gfAttribute Define
hi link gfString String
hi link gfRegex String
hi link gfNumber Number
hi def link gfCommentL pipComment
hi def link gfCommentL Comment
hi def link gfInterp Constant
hi def link gfBraces Constant
hi def link gfOperator Delimiter
hi def link gfOS Constant
hi def link gfEvent Constant
hi def link gfRepeat Define
hi def link gfName Label

let b:current_syntax = "workflow"
