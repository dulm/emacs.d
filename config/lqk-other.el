;;filecache
;; (require 'filecache)
;; (add-to-list 'file-cache-filter-regexps "\\.git\\>")
;; (file-cache-add-directory-recursively "E:/Project/Tale/Server/trunk/script/")
(require 'filecache)
(defun file-cache-ido-find-file (file)
  "Using ido, interactively open file from file cache'.
First select a file, matched using ido-switch-buffer against the contents
in `file-cache-alist'. If the file exist in more than one
directory, select directory. Lastly the file is opened."
  (interactive (list (file-cache-ido-read "File: "
                                          (mapcar
                                           (lambda (x)
                                             (car x))
                                           file-cache-alist))))
  (let* ((record (assoc file file-cache-alist)))
    (find-file
     (expand-file-name
      file
      (if (= (length record) 2)
          (car (cdr record))
        (file-cache-ido-read
         (format "Find %s in dir: " file) (cdr record)))))))

(defun file-cache-ido-read (prompt choices)
  (let ((ido-make-buffer-list-hook
		 (lambda ()
		   (setq ido-temp-list choices))))
    (ido-read-buffer prompt)))

;; Change this to filter out your version control files
(add-to-list 'file-cache-filter-regexps "\\.svn-base$")
;; (if mk-proj-basedir
;;     (file-cache-add-directory-using-find mk-proj-basedir))
(file-cache-add-directory-recursively "E:/Project/Tale/Server/trunk/script/");;写死了TODO，改为根据mk-project的设置动态改
(global-set-key (kbd "C-z C-f") 'file-cache-ido-find-file)




;;yasnippet
;; (require 'yasnippet)
;; (setq yas/snippet-dirs '("~/.emacs.d/plugins/yasnippet/snippets" "~/.emacs.d/plugins/yasnippet/extras/imported"))
;; (yas/global-mode 1)


;;ecb
(require 'ecb)
(require 'ecb-autoloads)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40")
 '(ecb-source-path (quote ((#("e:/Project/Tale/Server/trunk/script" 0 35 (help-echo "Mouse-2 toggles maximizing, mouse-3 displays a popup-menu")) "servertrunk")))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
(setq ecb-tip-of-the-day nil)
(setq imenu-auto-rescan t);;luamod没有语义解析支持的函数列表，文件保存时methods不自动更新,不支持语义解析的函数列表是调用imenu的




;;tabbar
(require 'tabbar)
(tabbar-mode t)
(global-set-key [(control shift tab)] 'tabbar-backward)
(global-set-key [(control tab)]  'tabbar-forward)


;; ;;speedbar
;; (add-hook 'speedbar-mode-hook
;;   (function
;;    (lambda ()
;;      (speedbar-add-supported-extension '(".lua"))
;;      ;; Generate tags for the OCaml mode through imenu (see below) or
;;      ;; etags interface
;;      )))

;;openresource
;;(require 'open-resource)
;;(global-set-key "\C-\M-r" 'open-resource)

;;icicle
;(require 'icicles)

(provide 'lqk-other)