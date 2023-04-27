;; extends

[
  "new"
  "delete"
] @keyword

((identifier) @constant
 (#lua-match? @constant "^_*[A-Z][A-Z%d_]*$")
 (#set! "priority" 200))
