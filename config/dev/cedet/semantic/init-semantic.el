;; ;; (semantic-load-enable-minimum-features)
;; (semantic-load-enable-code-helpers)
;; ;; (semantic-load-enable-guady-code-helpers)
;; ;; (semantic-load-enable-excessive-code-helpers)
;; (semantic-load-enable-semantic-debugging-helpers)

(setq semantic-default-submodes '(global-semantic-idle-scheduler-mode
                                  global-semanticdb-minor-mode
                                  global-semantic-idle-summary-mode
                                  global-semantic-mru-bookmark-mode))
(semantic-mode 1)
(global-semantic-highlight-edits-mode (if window-system 1 -1))
(global-semantic-show-unmatched-syntax-mode 1)
(global-semantic-show-parser-state-mode 1)



;;;;;;;;;;;;;;;;;;;;;;;;;;;设置include目录;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq semanticdb-project-roots (list (expand-file-name "/")))
(defconst cedet-user-include-dirs
  (list "." ".." "../include" "../inc" "../common" "../public"
        "../.." "../../include" "../../inc" "../../common" "../../public"))
;; (defconst cedet-win32-include-dirs
;;   (list "C:/MinGW/include"
;;         "C:/MinGW/include/c++/3.4.5"
;;         "C:/MinGW/include/c++/3.4.5/mingw32"
;;         "C:/MinGW/include/c++/3.4.5/backward"
;;         "C:/MinGW/lib/gcc/mingw32/3.4.5/include"
;;         "C:/Program Files/Microsoft Visual Studio/VC98/MFC/Include"))
(defconst cedet-mingw-include-dirs
  (list "D:/Program Files/Dev/MinGW/include"
		"D:/Program Files/Dev/MinGW/lib/gcc/mingw32/4.6.2/include"
		"D:/Program Files/Dev/MinGW/lib/gcc/mingw32/4.6.2/include/c++"
		"D:/Program Files/Dev/MinGW/lib/gcc/mingw32/4.6.2/include/c++/backward"
		"D:/Program Files/Dev/MinGW/lib/gcc/mingw32/4.6.2/include/c++/mingw32"
		"D:/Program Files/Dev/MinGW/lib/gcc/mingw32/4.6.2/include/c++/bits"))
;; (defconst shark-inc
;;   (list "E:/Project/Tale/shark-server/shark-server/product/include"
;; 		"E:/Project/Tale/shark-server/shark-server/SS_Single/src"))

;; (defconst my-third-inc
;;   (list "E:/Project/Tale/shark-server/third-party/log4cplus-1.0.4.1/include"
;; 		"E:/Project/Tale/shark-server/third-party/lua-5.2.0/src"
;; 		"E:/Project/Tale/shark-server/third-party/mhash-0.9.9.9/include"
;; 		"E:/Project/Tale/shark-server/third-party/libev-4.11"
;; 		"E:/Project/Tale/shark-server/third-party/boost_1_48_0"))


(require 'semantic-c nil 'noerror)
(let ((include-dirs cedet-user-include-dirs))
  (when (eq system-type 'windows-nt)
    (setq include-dirs (append include-dirs
							   ;; cedet-win32-include-dirs
							   cedet-mingw-include-dirs)))
  (mapc (lambda (dir)
          (semantic-add-system-include dir 'c++-mode)
          (semantic-add-system-include dir 'c-mode))
        include-dirs))



(ede-cpp-root-project "SSingle"
 					  :file "E:/Project/Tale/shark-server/shark-server/readme.txt"
 					  :system-include-path '( "E:/Project/Tale/shark-server/shark-server/product/include"
											  "E:/Project/Tale/shark-server/third-party/log4cplus-1.0.4.1/include"
											  "E:/Project/Tale/shark-server/third-party/lua-5.2.0/src"
											  "E:/Project/Tale/shark-server/third-party/mhash-0.9.9.9/include"
											  "E:/Project/Tale/shark-server/third-party/libev-4.11"
											  "E:/Project/Tale/shark-server/third-party/boost_1_48_0")
 					  :include-path '( "./src/"
									   "../product/include/")
 					  :spp-table '( ("MOOSE" . "")
 					  				("CONST" . "const") )
 					  )



;;跳到代码定义
(global-set-key [f3] 'semantic-ia-fast-jump)

;;回跳
(defadvice push-mark (around semantic-mru-bookmark activate)
  "Push a mark at LOCATION with NOMSG and ACTIVATE passed to `push-mark'.
If `semantic-mru-bookmark-mode' is active, also push a tag onto
the mru bookmark stack."
  (semantic-mrub-push semantic-mru-bookmark-ring
                      (point)
                      'mark)
  ad-do-it)
(global-set-key [S-f3]
                (lambda ()
                  (interactive)
                  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
                      (error "Semantic Bookmark ring is currently empty"))
                  (let* ((ring (oref semantic-mru-bookmark-ring ring))
                         (alist (semantic-mrub-ring-to-assoc-list ring))
                         (first (cdr (car alist))))
                    (if (semantic-equivalent-tag-p (oref first tag)
                                                   (semantic-current-tag))
                        (setq first (cdr (car (cdr alist)))))
                    (semantic-mrub-switch-tags first))))

;; 定义和声明之间转换
;; 光标所在的函数定义内，aa(){bb()}，光标在bb上，打开的是aa()的声明。
;; 使用sourcepair-load作为当前c和h文件的跳转。
;; (define-key c-mode-base-map [M-S-f3] 'semantic-analyze-proto-impl-toggle)
(define-key semantic-mode-map [M-S-f3] 'semantic-analyze-proto-impl-toggle)




(provide 'init-semantic)
