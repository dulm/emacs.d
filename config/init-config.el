;; (let ((buffer (url-retrieve-synchronously
;; 	       "http://tromey.com/elpa/package-install.el")))
;; (save-excursion
;;   (set-buffer buffer)
;;   (goto-char (point-min))
;;   (re-search-forward "^$" nil 'move)
;;   (eval-region (point) (point-max))
;;   (kill-buffer (current-buffer))))
(setq elpa-path "~/.emacs.d/elpa/")
(setq plugin-path "~/.emacs.d/plugins/")
(setq config-path "~/.emacs.d/config")
(add-to-list 'load-path plugin-path)
(add-to-list 'load-path config-path)

(load "init-elpa")
(load "lqk-basic")

(load "lqk-lang")
(require 'init-vc)
(require 'lqk-project)
(require 'init-auto-complete)
(require 'init-flymake)
(require 'init-ido)
(load "lqk-other")

(provide 'init-config)