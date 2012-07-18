(defun c-wx-lineup-topmost-intro-cont (langelem)
  (save-excursion
    (beginning-of-line)
    (if (re-search-forward "EVT_" (line-end-position) t)
      'c-basic-offset
      (c-lineup-topmost-intro-cont langelem))))

;C/C++ SECTION
(defun my-c-mode-hook ()
  (local-set-key "\M-f" 'c-forward-into-nomenclature)
  (local-set-key "\M-b" 'c-backward-into-nomenclature)
  (setq c-basic-offset 4)
  (setq c-style-variables-are-local-p nil)
  ;give me NO newline automatically after electric expressions are entered
  (setq c-auto-newline nil)



  ;;--------------------------------------------------------------------------
  ;;对于无法tab触发complete的模式，比如cc-mode，需要定制hook.
  ;;未解决tab在菜单中触发ac-next.
  ;;-------------------------------------------------------------------------

  ;;tab-always-indent 设为complete对cc-mode没用.
  
  ;;ac-set-trigger-key 会无法indent行
  ;;(ac-set-trigger-key "<tab>")
  
  ;;没法改成tab触发，只好改成自动触发了
  (setq ac-auto-start t)
  
  
  ;always reindent the line, insert a tab if within a comment or a string. 
  (setq c-tab-always-indent 'other)
  
  ;; ac-omni-completion-sources is made buffer local so
  ;; you need to add it to a mode hook to activate on 
  ;; whatever buffer you want to use it with.  This
  ;; example uses C mode (as you probably surmised).

  ;; auto-complete.el expects ac-omni-completion-sources to be
  ;; a list of cons cells where each cell's car is a regex
  ;; that describes the syntactical bits you want AutoComplete
  ;; to be aware of. The cdr of each cell is the source that will
  ;; supply the completion data.  The following tells autocomplete
  ;; to begin completion when you type in a . or a ->
  
  (add-to-list 'ac-omni-completion-sources
  			   (cons "\\." '(ac-source-semantic)))
  (add-to-list 'ac-omni-completion-sources
  			   (cons "->" '(ac-source-semantic)))

  ;; ac-sources was also made buffer local in new versions of
  ;; autocomplete.  In my case, I want AutoComplete to use 
  ;; semantic and yasnippet (order matters, if reversed snippets
  ;; will appear before semantic tag completions).
  (setq ac-sources '(ac-source-semantic ac-source-yasnippet))



  
  ;if (0) becomes if (0)
  ; { {
  ; ; ;
  ; } }
  (c-set-offset 'substatement-open 0)

  ;first arg of arglist to functions: tabbed in once
  ;(default was c-lineup-arglist-intro-after-paren)
  (c-set-offset 'arglist-intro '+)

  ;second line of arglist to functions: tabbed in once
  ;(default was c-lineup-arglist)
  (c-set-offset 'arglist-cont-nonempty '+)

  ;switch/case: make each case line indent from switch
  (c-set-offset 'case-label '+)

  ;make the ENTER key indent next line properly
  (local-set-key "\C-m" 'newline-and-indent)

  ;syntax-highlight aggressively
  ;(setq font-lock-support-mode 'lazy-lock-mode)
  (setq lazy-lock-defer-contextually t)
  (setq lazy-lock-defer-time 0)

  ;make DEL take all previous whitespace with it
  (c-toggle-hungry-state 1)

  ;make open-braces after a case: statement indent to 0 (default was '+)
  (c-set-offset 'statement-case-open 0)

  ;make a #define be left-aligned
  (setq c-electric-pound-behavior (quote (alignleft)))

  ;wxwdigets stuff
  (c-set-offset 'topmost-intro-cont 'c-wx-lineup-topmost-intro-cont)

  ;do not impose restriction that all lines not top-level be indented at least
  ;1 (was imposed by gnu style by default)
  (setq c-label-minimum-indentation 0)

  ; @see https://github.com/seanfisk/cmake-flymake
  ; make sure you project use cmake
  ;;(flymake-mode)

  )
(add-hook 'c-mode-common-hook 'my-c-mode-hook)

(provide 'init-cc-mode)