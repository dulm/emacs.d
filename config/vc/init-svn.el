(require 'psvn)

;; cf. http://svn.haxx.se/dev/archive-2011-01/0369.shtml
(require 'vc-svn)
(defun vc-svn-registered (file)
  "Check if FILE is SVN registered."
  ;;  (when (file-readable-p (expand-file-name (concat vc-svn-admin-directory
  ;;                                                 "/entries")
  ;;                                         (file-name-directory file)))
  (when (my-file-directory-p (expand-file-name vc-svn-admin-directory
                                               (file-name-directory file)))
    (with-temp-buffer
      (cd (file-name-directory file))
      (let* (process-file-side-effects
             (status
			  (condition-case nil
				  ;; Ignore all errors.
				  (vc-svn-command t t file "status" "-v")
				;; Some problem happened.  E.g. We can't find an `svn'
				;; executable.  We used to only catch `file-error' but when
				;; the process is run on a remote host via Tramp, the error
				;; is only reported via the exit status which is turned into
				;; an `error' by vc-do-command.
				(error nil))))
        (when (eq 0 status)
          (let ((parsed (vc-svn-parse-status file)))
            (and parsed (not (memq parsed '(ignored unregistered))))))))))


(provide 'init-svn)