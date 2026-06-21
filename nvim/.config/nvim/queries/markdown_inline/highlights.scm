;; extends

; Can be removed once:
; * https://github.com/neovim/neovim/pull/39993 is merged and released, or
; * https://github.com/redhat-developer/yaml-language-server/issues/837 is
;   addressed.

((backslash_escape) @conceal
  (#offset! @conceal 0 0 0 -1)
  (#set! conceal ""))

((hard_line_break
  "\\" @conceal)
  (#set! conceal ""))
