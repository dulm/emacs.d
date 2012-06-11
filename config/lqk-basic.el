;; 自动存盘
(setq backup-inhibited t)
(setq auto-save-default nil)
(setq inhibit-splash-screen t);;no default guide page.
;; 设置tab字符显示缩进,按下tab键插入tab还是空格
(setq tab-width 4
      default-tab-width 4
      indent-tabs-mode t)
(global-linum-mode 1);line number
;;设定语言环境为utf-8  
(setq current-language-environment "UTF-8")  
(setq default-input-method "chinese-py")  
(setq locale-coding-system 'utf-8)  
(set-terminal-coding-system 'utf-8) 
(set-keyboard-coding-system 'utf-8)  
(set-selection-coding-system 'utf-8)  
(prefer-coding-system 'utf-8)

;;允许C-z作为命令前缀
(define-prefix-command 'ctl-z-map)  
(global-set-key (kbd "C-z") 'ctl-z-map) 

;;快速打开~/.emacs文件
(defun lqk-open-init-file ( )  
  (interactive)  
  (find-file "~/.emacs")
  (find-file "~/.emacs.d/config/lqk-basic.el"))
(global-set-key "\C-zi" 'lqk-open-init-file)
;;快速重新加载~/.emacs文件
(defun lqk-load-init-file()
  (interactive)
  (load-file "~/.emacs"))
(global-set-key "\C-zl" 'lqk-load-init-file)


(global-set-key (kbd "C-x C-b") 'ibuffer);;buffer 列表

(setq mouse-wheel-scroll-amount '(3 ((shift) . 1)((control)));;滚轮滚屏3行
	  mouse-wheel-progressive-speed nil;;滚轮不加速
	  scroll-step 1;;一次一行
	  scroll-margin 3;;底部3行的时候开始滚
	  scroll-conservatively 10000);;光标到底不会提到中间

(global-set-key (kbd "C-c C-m") 'set-mark-command);设置mark
(global-set-key (kbd "C-x C-m")'pop-global-mark);全局回到mark
(global-set-key (kbd "RET")'newline-and-indent) ;设置按回车后自动对齐 Tab
(setq mouse-drag-copy-region nil);选择不复制
(delete-selection-mode t);替换选中区域
(setq scroll-preserve-screen-position t);滚屏保持光标相对位置

(global-set-key (kbd "<S-return>") (kbd "C-e C-j"));;类似eclips的shift enter

(global-set-key (kbd "C-o") (kbd "C-a C-j C-p C-i"));;在上一行插入空行并编辑

;;移动行
(defun move-text-internal (arg)
  (cond
   ((and mark-active transient-mark-mode)
    (if (> (point) (mark))
        (exchange-point-and-mark))
    (let ((column (current-column))
          (text (delete-and-extract-region (point) (mark))))
      (forward-line arg)
      (move-to-column column t)
      (set-mark (point))
      (insert text)
      (exchange-point-and-mark)
      (setq deactivate-mark nil)))
   (t
    (let ((column (current-column)))
      (beginning-of-line)
      (when (or (> arg 0) (not (bobp)))
        (forward-line)
        (when (or (< arg 0) (not (eobp)))
          (transpose-lines arg))
        (forward-line -1))
      (move-to-column column t)))))

(defun move-text-down (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines down."
  (interactive "*p")
  (move-text-internal arg))

(defun move-text-up (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines up."
  (interactive "*p")
  (move-text-internal (- arg)))

(global-set-key [M-up] 'move-text-up)
(global-set-key [M-down] 'move-text-down)



;;搜索选中
(defun lqk-define-key-in-transient-mode (global-p key cmd-mark-active  cmd-mark-no-active)
  (funcall (if global-p 'global-set-key 'local-set-key)
           key
           `(lambda ()
              (interactive)
              (if mark-active
                  (call-interactively ',cmd-mark-active)
                (call-interactively ',cmd-mark-no-active)))))

(defun lqk-isearch-forward-on-selection (&optional regexp-p no-recursive-edit)
  (interactive "P\np")
  (let ((text (buffer-substring (point) (mark))))
    (goto-char (min (point) (mark)))
    (setq mark-active nil)
    (isearch-mode t (not (null regexp-p)) nil (not no-recursive-edit))
    (isearch-process-search-string text text)))

(lqk-define-key-in-transient-mode t (kbd "C-s")
                                  'lqk-isearch-forward-on-selection
                                  'isearch-forward)


;;最近更改
(require 'goto-chg)
(global-set-key [(control ,)] 'goto-last-change)
(global-set-key [(control .)] 'goto-last-change-reverse)

;;自动括号引号
(require 'autopair)
(setq autopair-autowrap t);;由于开启了替换选中区域，暂时没用

;;其他编辑器修改了的buffer，全部重新载入
(defun revert-all-buffers ()
  "Refreshes all open buffers from their respective files."
  (interactive)
  (dolist (buf (buffer-list))
	(with-current-buffer buf
	  (when (and (buffer-file-name) (not (buffer-modified-p)))
		(revert-buffer t t t) )))
  (message "Refreshed open files.") )

(provide 'lqk-basic)