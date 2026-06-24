(let ((file-name-handler-alist nil))
; load config.org file as config 
(org-babel-load-file
 (expand-file-name
  "config.org"
  user-emacs-directory))
)
