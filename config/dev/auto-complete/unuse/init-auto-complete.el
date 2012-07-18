(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode t)
(setq ac-auto-start nil)
(setq ac-dwim nil) ; To get pop-ups with docs even if a word is uniquely completed
(define-key ac-completing-map (kbd "C-n") 'ac-next)
(define-key ac-completing-map (kbd "C-p") 'ac-previous)




(add-to-list 'ac-dictionary-directories (concat my-emacs-lisps-path "autocomp//ac-dict"))
;;(add-to-list 'ac-modes 'lua-mode)

;;----------------------------------------------------------------------------
;; Use Emacs' built-in TAB completion hooks to trigger AC (Emacs >= 23.2)
;;----------------------------------------------------------------------------
(setq tab-always-indent 'complete) ;; use 'complete when auto-complete is disabled
(add-to-list 'completion-styles 'initials t)

;; hook AC into completion-at-point
(defun set-auto-complete-as-completion-at-point-function ()
  (setq completion-at-point-functions '(auto-complete)))
(add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)


;;----------------------------------------------------------------------------
;;对于无法tab触发complete的模式，比如cc-mode，需要定制hook.
;;未解决tab在菜单中触发ac-next.
;;---------------------------------------------------------------------------
;; (defun indent-or-complete ()
;;   "Complete if point is at end of a word, otherwise indent line."
;;   (interactive)
;;   (if (looking-at "\\>")
;; 	  (progn
;; 		(indent-for-tab-command)
;; 		;;(hippie-expand nil)
;; 		(auto-complete))
;; 	(indent-for-tab-command)
;; 	))
;; (local-set-key [(tab)] 'indent-or-complete)



(set-default 'ac-sources
             '(ac-source-dictionary
               ac-source-words-in-buffer
               ac-source-words-in-same-mode-buffers
               ac-source-words-in-all-buffer
			   ac-source-semantic
			   ac-source-yasnippet
			   ac-source-abbrev
			   ac-source-imenu
			   ac-source-files-in-current-dir
			   ac-source-filename))

(dolist (mode '(magit-log-edit-mode log-edit-mode org-mode text-mode haml-mode
                sass-mode yaml-mode csv-mode espresso-mode haskell-mode
                html-mode nxml-mode sh-mode smarty-mode clojure-mode
                lisp-mode textile-mode markdown-mode tuareg-mode
                css-mode less-css-mode lua-mode))
  (add-to-list 'ac-modes mode))


;; Exclude very large buffers from dabbrev
(defun smp-dabbrev-friend-buffer (other-buffer)
  (< (buffer-size other-buffer) (* 1 1024 1024)))

(setq dabbrev-friend-buffer-function 'smp-dabbrev-friend-buffer)

(provide 'init-auto-complete)