; extends

(block_mapping_pair
  key: (flow_node) @_code
  (#any-of? @_code "inlineCode" "inline_code")
  value: (flow_node
    (plain_scalar (string_scalar) @injection.content)
    (#set! injection.language "lua")))

(block_mapping_pair
  key: (flow_node) @_code
  (#any-of? @_code "inlineCode" "inline_code")
  value: (block_node
    (block_scalar) @injection.content
    (#set! injection.language "lua")
    (#offset! @injection.content 0 1 0 0)))

(block_mapping_pair
  key: (flow_node) @_src
  (#any-of? @_src "default_source_code" "defaultSourceCode")
  value: (block_node
    (block_mapping
      (block_mapping_pair
        key: (flow_node) @_inline
        (#any-of? @_inline "inline_string" "inlineString")
        value: (block_node
          (block_scalar) @injection.content
          (#set! injection.language "lua")
          (#offset! @injection.content 0 1 0 0))))))
