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
   '(:foreground default :background default :scale 1.3 :html-foreground
				 "Black" :html-background "Transparent" :html-scale
				 1.0 :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(package-selected-packages
   '(auto-dark cape consult-dir corfu eglot-jl eldoc-box embark-consult
			   evil-collection evil-nerd-commenter flash general
			   gnuplot julia-repl julia-ts-mode laas magit marginalia
			   markdown-mode minions mood-line nov orderless org-roam
			   org-superstar pdf-tools toc-org treesit-auto vertico
			   vundo yasnippet-capf yasnippet-snippets zoxide))
 '(preview-scale-function 1.0))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((t (:slant italic)))))
