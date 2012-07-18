;; (let ((buffer (url-retrieve-synchronously
;; 	       "http://tromey.com/elpa/package-install.el")))
;; (save-excursion
;;   (set-buffer buffer)
;;   (goto-char (point-min))
;;   (re-search-forward "^$" nil 'move)
;;   (eval-region (point) (point-max))
;;   (kill-buffer (current-buffer))))
(defconst my-emacs-path           "~/.emacs.d/" "我的emacs相关配置文件的路径")
(defconst my-emacs-my-lisps-path  (concat my-emacs-path "config/") "我自己写的emacs lisp包的路径")
(defconst my-emacs-lisps-path     (concat my-emacs-path "plugins/") "我下载的emacs lisp包的路径")
(defconst my-emacs-elpa-path     (concat my-emacs-path "elpa/") "我下载的emacs lisp包的路径")
(defconst my-emacs-templates-path (concat my-emacs-path "templates/") "Path for templates")

;; 把`my-emacs-lisps-path'的所有子目录都加到`load-path'里面
(load (concat my-emacs-my-lisps-path "util/my-subdirs"))
(my-add-subdirs-to-load-path my-emacs-lisps-path)
(my-add-subdirs-to-load-path my-emacs-my-lisps-path)

(require 'init-util)
(load "init-elpa")
(load "lqk-basic")

(load "lqk-lang")
;;(require 'init-vc)
(require 'lqk-project)
(require 'init-ido)
(require 'dev-settings)
(load "lqk-other")

(provide 'init-config)