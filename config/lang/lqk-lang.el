;;注释和反注释区域
(defun qiang-comment-dwim-line (&optional arg)
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key (kbd "C-;") 'qiang-comment-dwim-line)


(setq load-path (cons "~/.emacs.d/config/lang" load-path))

(require 'init-lua-mode)
;;(require 'init-cc-mode)
(require 'c-settings)
(require 'init-cmake-mode)
(require 'sh-mode-settings)
(require 'sgml-mode-settings)
(require 'sql-settings)

(provide 'lqk-lang)