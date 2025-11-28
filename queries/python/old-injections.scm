; Inject markdown into comments within markdown cells
((comment) @injection.content
 (#in-markdown-cell? @injection.content)
 (#set! injection.language "markdown")
 (#offset! @injection.content 0 1 0 0))

; ((comment) @injection.content
;   (#match? @injection.content "!\\[image\\]")
;   (#set! injection.language "markdown"))
;
; ((comment) @markdown_block
;   (#match? @markdown_block "\\[markdown\\]"))
;
; Inject Markdown into triple-quoted strings that start with """ markdown
; ((string
;    (string_content) @injection.content) @string
;   (#match? @string "^\"\"\" ?[mM]arkdown")
;   (#set! injection.language "markdown"))

; ((string (string_content) @injection.content)
;   (#set! injection.language "markdown"))
