; PHP инъекции для markdown
(
  (fenced_code_block
    (info_string) @_lang
    (code_fence_content) @injection.content)
  (#eq? @_lang "php")
  (#set! injection.language "php")
)

(
  (fenced_code_block
    (info_string) @_lang
    (code_fence_content) @injection.content)
  (#match? @_lang "^php[0-9]*")
  (#set! injection.language "php")
)

; Для inline кода если нужно
((inline) @injection.content
  (#set! injection.language "markdown_inline"))
