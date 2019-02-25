" docker.vim - Syntax highlighting for Dockerfiles
" Maintainer:   Honza Pokorny <https://honza.ca>
" Version:      0.6
" Last Change:  2016 Aug 9
" License:      BSD


if exists("b:current_syntax")
    finish
endif

let b:current_syntax = "docker"

syntax case ignore

syntax match dockerKeyword /\v^\s*(ONBUILD\s+)?(ADD|ARG|CMD|COPY|ENTRYPOINT|ENV|EXPOSE|FROM|HEALTHCHECK|LABEL|MAINTAINER|RUN|SHELL|STOPSIGNAL|USER|VOLUME|WORKDIR)\s/

syntax region dockerString start=/\v"/ skip=/\v\\./ end=/\v"/

syntax match dockerComment "\v^\s*#.*$"

hi def link dockerString String
hi def link dockerKeyword Keyword
hi def link dockerComment Comment
