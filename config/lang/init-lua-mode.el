;;lua
(require 'lua-mode)
(setq auto-mode-alist (cons '("\\.lua$" . lua-mode) auto-mode-alist))
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

;;--------------------------------------------------------------------
;; Lua-mode 
;;--------------------------------------------------------------------
(defun lua-send-buffer-with-emacs-enviroment()
  "thisandthat."
  (interactive)
  (or (and lua-process
		   (comint-check-proc lua-process-buffer))
	  (lua-start-process lua-default-application))
  ;; kill lua process without query
  (if (fboundp 'process-kill-without-query) 
	  (process-kill-without-query lua-process)) 
  (with-current-buffer lua-process-buffer 
	(comint-simple-send (get-buffer-process (current-buffer))
						"EMACS = 1;EMACS_LUA = 1;EMACS_LUA_ENVIROMENT = 1;")
	(comint-simple-send (get-buffer-process (current-buffer))
						"print(); print \'Emacs Lua-Mode Enviroment set complete!\\n\\n\';")
	)
  
  (lua-send-buffer)
)

(add-hook 'lua-mode-hook
          (lambda ()
			(setq lua-indent-level 4)
			(turn-on-font-lock)
			(local-set-key [f5] 'lua-send-buffer-with-emacs-enviroment)
		    ;; 在行末尾添加";"号并换行缩进
			(local-set-key (kbd "M-q") 'line-end-with-sem-and-newline-indent-ex)
			(local-set-key (kbd "M-SPC") 'insert-newline-and-indent)

			;;使-字符属于单词一部分 etag
			(modify-syntax-entry ?_ "w")
			)
		  )

;;lua2
;;(require `lua2-mode)
;;(add-to-list 'auto-mode-alist '("\\.lua$" . lua2-mode))
;;(setq auto-mode-alist (cons '("\\.lua$" . lua2-mode) auto-mode-alist))


(provide 'init-lua-mode)