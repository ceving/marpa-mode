;;; marpa-mode.el --- Major mode for editing Marpa grammar files.

;; Time-stamp: <2015-11-20 11:48:55 szi>
;;
;; Copyright (C) 2015  Sascha Ziemann
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This is an Emacs major mode for editing Marpa grammar files.
;;
;; http://search.cpan.org/~jkegl/Marpa-R2-3.000000/pod/Scanless/DSL.pod
;;
;; This is how it looks like.
;;
;; https://ceving.github.io/marpa-mode/example.marpa.html
;;
;; Installation:
;;
;; Place this file somewhere in Emacs `load-path' and add the
;; following line to your Emacs initialization file:
;;
;;     (require 'marpa-mode)
;;
;; This mode adds `*.marpa' files to the `auto-mode-alist'.

;;; Code:

(defvar marpa-mode-syntax-table
  (let ((table (make-syntax-table)))
    ;; single quotes (') delimit strings
    (modify-syntax-entry ?' "\"" table)
    ;; double quotes (") don't delimit strings
    (modify-syntax-entry ?\" "." table)
    ;; stop blinking for brackets delimiting regular expressions
    (modify-syntax-entry ?\[ "." table)
    (modify-syntax-entry ?\] "." table)
    ;; allow unterline, colon and angle brackets in words
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?< "w" table)
    (modify-syntax-entry ?> "w" table)
    (modify-syntax-entry ?: "w" table)
    table)
  "Syntax table used in `marpa-mode'.")

(defvar marpa-mode-font-lock
  `(("\\(\\[[^]]*]\\)"
     (1 font-lock-variable-name-face))
    (,(regexp-opt '(":default" ":discard" ":lexeme" ":start"))
     (0 font-lock-builtin-face))
    ("\\(\\sw+\\)\\s-*::="
     (1 font-lock-function-name-face))
    ("\\(\\sw+\\)\\s-*~"
     (1 font-lock-type-face))
    (,(regexp-opt '(;; string suffix
                    ":i"
                    ;; Adverbs
                    "action" "assoc" "bless" "event" "forgiving" "latm"
                    "name" "null-ranking" "pause" "priority"  "proper"
                    "rank" "separator"
                    ;; Statements
                    "discard" "lexeme" "default" "inaccessible"
                    ))
     (0 font-lock-keyword-face)))
  "Highlighting used in `marpa-mode'.")

(defvar marpa-mode-hook nil)

(defun marpa-mode-indent-line ()
  "Indent current line in `marpa-mode'."
  (interactive)
  (beginning-of-line)
  (cond ((looking-at "^\\s-*\\sw+\\s-*\\(?:::=\\|~\\)\\|lexeme")
         (indent-line-to 0))
        ((looking-at "^\\s-*|\\s-*")
         (indent-line-to 2))
        ((looking-at "^[ \t]*||\\s-*")
         (indent-line-to 1))
        (t (indent-line-to 4))))

(defun marpa-mode ()
  "Major mode for editing Marpa BNF files."
  (interactive)
  (kill-all-local-variables)
  (set-syntax-table marpa-mode-syntax-table)
  (set (make-local-variable 'font-lock-defaults) '(marpa-mode-font-lock))
  (set (make-local-variable 'indent-line-function) 'marpa-mode-indent-line)
  (setq major-mode 'marpa-mode)
  (setq mode-name "Marpa")
  (run-hooks 'marpa-mode-hook))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.marpa\\'" . marpa-mode))

(provide 'marpa-mode)
