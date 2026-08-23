(require "forest/forest.scm")

(forest-configure! 'left #:ignore (list ".git" "target" "__pycache__"))
(forest-set-style! 'snacks)

(keymap (global)
        (normal (space (e ":forest-open"))))
