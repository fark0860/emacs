(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq package-enable-at-startup nil)
;; Set the theme before the GUI loads to avoid flash
(load-theme 'modus-vivendi t)
(setq custom-safe-themes t)
;; (load-theme 'modus-vivendi t)
(global-set-key (kbd "C-h C-t") #'modus-themes-toggle)
;; How much memory emacs can allocate before running garbage collecter
(setq gc-cons-threshold 100000000)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 800000)))  ;; sane default
;; Better LSP performance 
(setq read-process-output-max (* 1024 1024))  ;; 1 MB

;; Increase Treesitter Performance
(setenv "LSP_USE_PLISTS" "true")
(setq lsp-use-plists t)
(setq native-comp-speed 3)

;;;Some optimizations for emacs
;;;;from https://emacsredux.com/blog/2026/04/07/stealing-from-the-best-emacs-configs/
(setq bidi-inhibit-bpa t) ;; Inhibits by directional paranthesis algorithm for left-right languages 
(setq redisplay-skip-fontification-on-input t)
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)
(setq kill-do-not-save-duplicates t)
;;;; from https://tony-zorman.com/posts/emacs-potpourri.html


;; Dosent Recognize julia path set manually 
(setenv "PATH" (concat (getenv "HOME") "/.juliaup/bin:" (getenv "PATH")))
(setq exec-path (append '("~/.juliaup/bin") exec-path))
(add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))
;; ________________________________________________________________________

(setq initial-major-mode 'fundamental-mode
      initial-scratch-message nil)
(setq native-comp-async-query-on-exit t)
