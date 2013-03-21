;; -*- Emacs-Lisp -*-

;; Time-stamp: <2012-01-01 13:12:37 Sunday by taoshanwen>
(require 'auto-complete-config)
(require 'auto-complete+)
(require 'util)
(require 'ahei-misc)

;; After do this, isearch any string, M-: (match-data) always
;; return the list whose elements is integer
(global-auto-complete-mode 1)

;; 不让回车的时候执行`ac-complete', 因为当你输入完一个
;; 单词的时候, 很有可能补全菜单还在, 这时候你要回车的话,
;; 必须要干掉补全菜单, 很麻烦, 用M-j来执行`ac-complete'
(eal-define-keys
 'ac-complete-mode-map
 `(("<return>"   nil)
   ("RET"        nil)
   ("M-j"        ac-complete)))






(defun auto-complete-settings ()
  "Settings for `auto-complete'."
  (setq help-xref-following nil)
  
  (add-to-list 'ac-dictionary-directories (concat my-emacs-lisps-path "autocomp//ac-dict"))

  (setq ac-auto-show-menu t
        ac-auto-start t
        ac-dwim nil; To get pop-ups with docs even if a word is uniquely completed
        ac-candidate-limit ac-menu-height
        ac-quick-help-delay .5
        ac-disable-faces nil
		)

  (set-default 'ac-sources
               '(;;ac-source-semantic-raw
				 ;;ac-source-gtags
                 ac-source-yasnippet
                 ac-source-dictionary
                 ac-source-abbrev
                 ac-source-words-in-buffer
                 ac-source-words-in-same-mode-buffers
                 ac-source-imenu
                 ac-source-files-in-current-dir
                 ac-source-filename))
  (setq ac-modes ac+-modes)

  (defun ac-start-use-sources (sources)
    (interactive)
    (let ((ac-sources sources))
      (call-interactively 'ac-start)))

  ;;----------------------------------------------------------------------------
  ;; Use Emacs' built-in TAB completion hooks to trigger AC (Emacs >= 23.2)
  ;;----------------------------------------------------------------------------
  (setq tab-always-indent 'complete) ;; use 'complete when auto-complete is disabled
  (add-to-list 'completion-styles 'initials t)
  ;; hook AC into completion-at-point
  (setq completion-at-point-functions '(ac-start))

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
  ;; 		(auto-complete)
  ;; 		)
  ;; 	(indent-for-tab-command)
  ;; 	))

  (defun indent-or-complete ()
    "Complete if point is at end of a word, otherwise indent line."
    (interactive)
    (if (looking-at "\\>")
		(progn
		  (if ac-menu
			  (ac-next)
			(progn
			  ;;(hippie-expand nil)
			  ;; (message-box "auto indent")
			  (auto-complete)
			  (indent-for-tab-command)))
		  
		  )
	  (indent-for-tab-command)
	  ))
  
  (eal-define-keys
   'c-mode-base-map
   `(("<tab>"   indent-or-complete)))
  ;; ;;估计是配合tab-always-indent，只需要indent-for-tab-command就能触发complete了
  ;; (eal-define-keys
  ;;  'c-mode-base-map
  ;;  `(("<tab>"   indent-for-tab-command)))
  )

(eval-after-load "auto-complete"
  '(auto-complete-settings))



(defun ac-settings-4-cc ()
  "`auto-complete' settings for `cc-mode'."
     (dolist (command `(c-electric-backspace
                        c-electric-backspace-kill))
       (add-to-list 'ac-trigger-commands-on-completing command)))

(eval-after-load "cc-mode"
  '(ac-settings-4-cc))

(defun ac-settings-4-autopair ()
  "`auto-complete' settings for `autopair'."
  (defun ac-trigger-command-p (command)
    "Return non-nil if `this-command' is a trigger command."
    (or
     (and
      (symbolp command)
      (or (memq command ac-trigger-commands)
          (string-match "self-insert-command" (symbol-name command))
          (string-match "electric" (symbol-name command))
          (let* ((autopair-emulation-alist nil)
                 (key (this-single-command-keys))
                 (beyond-autopair (or (key-binding key)
                                      (and (setq key (lookup-key local-function-key-map key))
                                           (key-binding key)))))
            (or
             (memq beyond-autopair ac-trigger-commands)
             (and ac-completing
                  (memq beyond-autopair ac-trigger-commands-on-completing)))))))))
      
(eval-after-load "autopair"
  '(ac-settings-4-autopair))

(defun ac-settings-4-lisp ()
  "Auto complete settings for lisp mode."
  (setq ac-omni-completion-sources '(("\\<featurep\s+'" ac+-source-elisp-features)
                                     ("\\<require\s+'"  ac+-source-elisp-features)
                                     ("\\<load\s+\""    ac-source-emacs-lisp-features)))
  (ac+-apply-source-elisp-faces)
  (setq ac-sources
        '(ac-source-features
          ac-source-functions
          ac-source-yasnippet
          ac-source-variables
          ac-source-symbols
          ac-source-dictionary
          ac-source-abbrev
          ac-source-words-in-buffer
          ac-source-files-in-current-dir
          ac-source-filename
          ac-source-words-in-same-mode-buffers)))

(defun ac-settings-4-java ()
  (setq ac-omni-completion-sources (list (cons "\\." '(ac-source-semantic))
                                         (cons "->" '(ac-source-semantic))))
  (setq ac-sources
        '(;;ac-source-semantic
          ac-source-yasnippet
          ac-source-abbrev
          ac-source-words-in-buffer
          ac-source-words-in-same-mode-buffers
          ac-source-files-in-current-dir
          ac-source-filename)))

(defun ac-settings-4-c ()
  (setq ac-omni-completion-sources (list (cons "\\." '(ac-source-semantic))
                                         (cons "->" '(ac-source-semantic))))
  (setq ac-sources
        '(ac-source-yasnippet
          ac-source-dictionary
          ac-source-semantic
          ac-source-abbrev
          ac-source-words-in-buffer
          ac-source-words-in-same-mode-buffers
          ac-source-files-in-current-dir
          ac-source-filename)))

(defun ac-settings-4-cpp ()
  (setq ac-omni-completion-sources (list (cons "\\." '(ac-source-semantic))
  										 (cons "->" '(ac-source-semantic))))
  (setq ac-sources
        '(ac-source-yasnippet
          ac-source-dictionary
          ac-source-semantic
          ac-source-abbrev
          ac-source-words-in-buffer
          ac-source-words-in-same-mode-buffers
          ac-source-files-in-current-dir
          ac-source-filename)))

(defun ac-settings-4-text ()
  (setq ac-sources
        '(ac-source-yasnippet
          ac-source-abbrev
          ac-source-words-in-buffer
          ac-source-words-in-same-mode-buffers
          ac-source-imenu)))

(defun ac-settings-4-eshell ()
  (setq ac-sources
        '(ac-source-yasnippet
          ac-source-abbrev
          ac-source-words-in-buffer
          ac-source-words-in-same-mode-buffers
          ac-source-files-in-current-dir
          ac-source-filename
          ac-source-symbols
          ac-source-imenu)))

(defun ac-settings-4-ruby ()
  (require 'rcodetools-settings)
  (setq ac-omni-completion-sources
        (list (cons "\\." '(ac-source-rcodetools))
              (cons "::" '(ac-source-rcodetools)))))

(defun ac-settings-4-html ()
  (setq ac-sources
        '(ac-source-yasnippet
          ac-source-abbrev
          ac-source-words-in-buffer
          ac-source-words-in-same-mode-buffers
          ac-source-files-in-current-dir
          ac-source-filename)))

(defun ac-settings-4-tcl ()
  (setq ac-sources
        '(ac-source-yasnippet
          ac-source-abbrev
          ac-source-words-in-buffer
          ac-source-words-in-same-mode-buffers
          ac-source-files-in-current-dir
          ac-source-filename)))

(defun ac-settings-4-awk ()
  (setq ac-sources
        '(ac-source-yasnippet
          ac-source-abbrev
          ac-source-words-in-buffer
          ac-source-words-in-same-mode-buffers
          ac-source-files-in-current-dir
          ac-source-filename)))

(am-add-hooks
 `(lisp-mode-hook emacs-lisp-mode-hook lisp-interaction-mode-hook
                  svn-log-edit-mode-hook change-log-mode-hook)
 'ac-settings-4-lisp)

(apply-args-list-to-fun
 (lambda (hook fun)
   (am-add-hooks hook fun))
 `(('java-mode-hook   'ac-settings-4-java)
   ('c-mode-hook      'ac-settings-4-c)
   ('c++-mode-hook    'ac-settings-4-cpp)
   ('text-mode-hook   'ac-settings-4-text)
   ('eshell-mode-hook 'ac-settings-4-eshell)
   ('ruby-mode-hook   'ac-settings-4-ruby)
   ('html-mode-hook   'ac-settings-4-html)
   ('awk-mode-hook    'ac-settings-4-awk)
   ('tcl-mode-hook    'ac-settings-4-tcl)))

(eal-eval-by-modes
 ac-modes
 (lambda (mode)
   (let ((mode-name (symbol-name mode)))
     (when (and (intern-soft mode-name) (intern-soft (concat mode-name "-map")))
       (define-key (symbol-value (am-intern mode-name "-map")) (kbd "C-c a") 'ac-start)))))

(provide 'auto-complete-settings)
