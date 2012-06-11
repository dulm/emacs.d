;;mk-project
(require 'mk-project)
(global-set-key [(f1)] 'project-grep)
(global-set-key [(f2)] 'project-find-file)
(global-set-key [(f6)] 'project-multi-occur)

(global-set-key [(f11)] 'pop-tag-mark)
(global-set-key [(f12)] 'project-find-tag)  ;如果存在唯一tag，直接跳转，多个tag，列出所有匹配tag供选择

(global-set-key (kbd "C-c p l") 'project-load)
(global-set-key (kbd "C-c p u") 'project-unload)
(global-set-key (kbd "C-c p i") 'project-index)
(global-set-key (kbd "C-c p s") 'project-status)
(global-set-key (kbd "C-c p d") 'project-dired)
(global-set-key (kbd "C-c p t") 'project-tags)
;;prj-def
(add-to-list 'load-path "~/.emacs.d/project")
(require 'server-trunk)

(provide 'lqk-project)