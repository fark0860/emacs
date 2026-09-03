;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-includegraphics-read-file 'LaTeX-includegraphics-read-file-relative)
 '(highlight-indent-guides-method 'character)
 '(ignored-local-variable-values '((reftex-default-bibliography "references.bib")))
 '(inhibit-startup-screen t)
 '(nov-text-width nil)
 '(org-format-latex-options
   '(:foreground nil :background nil :scale 1.0 :html-foreground "Black"
				 :html-background "Transparent" :html-scale 1.0
				 :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(package-selected-packages
   '(auto-dark cape consult-dir corfu eglot-jl eldoc-box embark-consult
			   evil-collection evil-escape evil-nerd-commenter flash
			   general ghostel gnuplot julia-repl julia-ts-mode laas
			   magit marginalia markdown-mode minions nov orderless
			   org-habit-stats org-roam org-superstar pdf-tools
			   toc-org transient treesit-auto vertico vundo
			   with-editor yasnippet-capf yasnippet-snippets zoxide))
 '(preview-scale-function 1.0 t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((t (:slant italic))))
 '(mode-line ((t (:height 0.7))))
 '(mode-line-active ((t (:height 0.7))))
 '(mode-line-inactive ((t (:height 0.7))))
 '(org-level-1 ((t (:height 1.5 :weight bold))))
 '(org-level-2 ((t (:height 1.4 :weight bold))))
 '(org-level-3 ((t (:height 1.3 :weight semi-bold))))
 '(org-level-4 ((t (:height 1.2 :weight bold))))
 '(org-level-5 ((t (:height 1.1 :weight bold))))
 '(org-tag ((t (:foreground unspecified :background unspecified :box nil :weight normal)))))
