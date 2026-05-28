;; Initialize the built-in package manager
(require 'package)

;; Configure package archives
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")))

;; Initialize and optionally refresh archives
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
;; Force use-package to install missing packages via package.el by default
(setq use-package-always-ensure t)

;; Configure built-in Emacs features
(use-package emacs
  :ensure nil
  :config
  (setq ring-bell-function #'ignore))

;; Install and configure mood-line
(use-package mood-line
  :config
  (mood-line-mode 1)
  :custom
  (mood-line-glyph-alist mood-line-glyphs-fira-code))

;;; Evil Package Vim Bindings
(use-package evil
  :ensure t
  :demand t
  :bind (("<escape>" . keyboard-escape-quit))
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-integration t)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-disable-insert-state-bindings t)
  :config
  (evil-mode 1))

(use-package evil-collection
  :ensure t
  :after evil
  :init
  (setq evil-collection-setup-minibuffer t)
  (setq evil-collection-mode-list '(dashboard dired ibuffer info woman help))
  (setq evil-collection-key-blacklist '("SPC"))
  :config
  (evil-collection-init)

  ;; Custom overrides
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-up-directory
    "l" 'dired-find-file)

  (evil-collection-define-key 'normal 'Info-mode-map
    "h" 'Info-history-back
    "l" 'Info-history-forward
    "o" 'Info-menu))

(evil-set-initial-state 'package-menu-mode 'normal)

(use-package auto-dark
  :ensure t
  :demand t
  :custom
  ;; Dark mode → modus-vivendi; Light mode → modus-operandi
  (auto-dark-themes '((modus-vivendi) (modus-operandi)))
  ;; How often to check for system theme change (in seconds)
  (auto-dark-polling-interval-seconds 5)
  ;; Don’t use AppleScript or PowerShell 
  (auto-dark-allow-osascript nil)
  (auto-dark-allow-powershell nil)
  ;; Optional: only if you know what you're doing
  ;; (auto-dark-detection-method nil)
  :hook
  (auto-dark-dark-mode
   . (lambda ()
       (message "Switched to dark theme ☪")))
  (auto-dark-light-mode
   . (lambda ()
       (message "Switched to light theme ☼")))
  :init
  (auto-dark-mode))

(use-package evil-nerd-commenter
  :ensure t
  :after evil
  :config
  (evilnc-default-hotkeys))

;; Completion framework setup

(use-package vertico
  :ensure t
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  :ensure t
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  
  ;; The :init section is always executed.
  :init
  
  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless flex))
  (completion-category-overrides '((file (styles partial-completion)))))


;; Save completion history
(use-package savehist
  :init
  (savehist-mode))

;; Recent files setup
(use-package recentf
  :custom
  (recentf-max-saved-items 200)
  (recentf-exclude '("/tmp/" "/var/folders/" "\\.?cache" "__pycache__"))
  :init
  (recentf-mode))



;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element
  
  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)
  
  ;; The :init configuration is always executed (Not lazy)
  :init
  
  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)
  
  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  
  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config
  
  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))
  
  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"
  
  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
  )


(use-package consult-dir
  :ensure t
  :bind (("C-x C-d" . consult-dir)
         :map vertico-map
         ("C-x C-d" . consult-dir)
             ("C-x C-j" . consult-dir-jump-file)))

; Core LSP: Eglot (built-in, fast)
    (use-package eglot
	  :defer t
      :custom
      ;; Performance optimizations
      (eglot-sync-connect 1)           ; Quick connect then async
      (eglot-autoshutdown t)           ; Kill idle servers
      (eglot-ignored-server-capabilities '(:documentHighlightProvider))  ; Skip unused
      :hook
      ;; Enable in Tree-sitter modes
      (((prog-mode text-mode) . eglot-ensure)
       (python-ts-mode . eglot-ensure)
       (lua-ts-mode . eglot-ensure)
       (js-ts-mode . eglot-ensure)
       (typescript-ts-mode . eglot-ensure)
       (julia-ts-mode . eglot-ensure)
       (rust-ts-mode . eglot-ensure))) 



    ;; Fast completion: Corfu
    (use-package corfu
      :ensure t
      :custom
      (corfu-auto t)                   ; Auto popup
      (corfu-cycle t)                  ; Cycle candidates
      (corfu-auto-prefix 3)            ; No or chars before auto-pop-up shows
      (corfu-quit-no-match t)          ; Quit if no match
      :config
      (setq corfu-auto-delay 0.5) ; Controls delay for popup-info-mode eldoc  
      (setq corfu-popupinfo-delay 0.1) ; Controls delay for popup-info-mode eldoc  
      (global-corfu-mode)
      (corfu-popupinfo-mode)
  	(corfu-history-mode)
  	(evil-collection-corfu-setup))

    (use-package yasnippet
      :ensure t
      :config
      (yas-global-mode 1))  ;; Enable Yasnippet globally

    (use-package yasnippet-snippets  ;; Optional: Provides a collection of snippets
      :ensure t)

    (use-package yasnippet-capf
      :ensure t
      :after (yasnippet cape))


    (use-package cape
      :ensure t
      :init
      ;; Add general Cape completions
      (add-hook 'completion-at-point-functions #'cape-file)
      (add-hook 'completion-at-point-functions #'cape-dabbrev)
      (add-hook 'completion-at-point-functions #'cape-elisp-block)
      (add-hook 'completion-at-point-functions #'cape-history)
    )


  (defun my/eglot-capf ()
  (when (eglot-managed-p)
    (eglot-completion-at-point)))

(defun my/eglot-completion-setup ()
  (setq-local completion-at-point-functions
              (append
               (list
                (cape-capf-super
                 #'yasnippet-capf
                 #'my/eglot-capf))
               completion-at-point-functions)))

(add-hook 'eglot-managed-mode-hook #'my/eglot-completion-setup)

(setq dired-listing-switches "-Al --group-directories-first -v") ;; Set default dired view
(add-hook 'dired-mode-hook #'dired-hide-details-mode)

(use-package eldoc
    :defer t
    :custom
    (eldoc-idle-delay 0.1)  ; delay before popup
    (eldoc-message-function #'ignore)        ; don't print in echo area
    (eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)) ; don't collect info

(use-package eldoc-box
  :ensure t
  :defer t
  :config
  ;; enable markdown rendering for eglot hovers
  (setq eldoc-box-hover-render-function #'eldoc-box-hover-markdown))

  ;; Eldoc backend that shows full docs for any elisp symbol
  (defun my/elisp-docs (callback &rest _)
    "Show full Elisp documentation in Eldoc / Eldoc-box for the symbol at point."
    (when-let ((sym (symbol-at-point))
               (buf (elisp--company-doc-buffer (symbol-name sym))))
      (funcall callback
               (with-current-buffer buf (buffer-string))
               '(:thing ,(format "%s" sym)))))

  ;; Add it to eldoc functions in emacs-lisp-mode and lisp-interaction-mode
  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (add-hook 'eldoc-documentation-functions #'my/elisp-docs nil t)))

  (add-hook 'lisp-interaction-mode-hook
            (lambda ()
              (add-hook 'eldoc-documentation-functions #'my/elisp-docs nil t)))

(use-package embark
  :defer t
  :ensure t
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("M-SPC" . embark-act)
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  ;; Add Embark to the mouse context menu. Also enable `context-menu-mode'.
  ;; (context-menu-mode 1)
  ;; (add-hook 'context-menu-functions #'embark-context-menu 100)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; Enable folding in programming modes
(add-hook 'prog-mode-hook #'hs-minor-mode)
;; Enable outline folding in Org and text modes
(add-hook 'org-mode-hook #'outline-minor-mode)
(add-hook 'text-mode-hook #'outline-minor-mode)

(use-package julia-mode
  :defer t
  :ensure t)
  
  (use-package julia-ts-mode
    :defer t
    :ensure t
    :mode "\\.jl$")

  (use-package eglot-jl
    :ensure t
	:defer t
    :after eglot)

  (use-package julia-repl
    :ensure t
    :after julia-ts-mode
    :commands julia-repl
    :custom
    (julia-repl-executable-records '((default "julia")))
    (julia-repl-switches "--startup-file=no --history-file=yes")
    :bind
    (:map julia-ts-mode-map
          ("C-c C-z" . julia-repl)
          ("C-c C-c" . julia-repl-send-buffer)
          ("C-c C-r" . julia-repl-send-region-or-line)
          ("C-c C-l" . julia-repl-send-line)))

;; FORCE GLOBAL PREVIEW OVERRIDES BEFORE LOADING
;;(setq-default TeX-PDF-mode nil)
(setq preview-image-type 'dvipng) ; Changed from 'dvi* to 'dvipng
(setq preview-scale-function nil)
(setq preview-LaTeX-command-replacements '(preview-LaTeX-disable-pdfoutput))
;;(setq preview-fast-conversion nil)

  (use-package latex
    :defer t
    :ensure auctex
    :mode ("\\.tex\\'" . LaTeX-mode)
    :hook ((LaTeX-mode . prettify-symbols-mode))
    :bind (:map LaTeX-mode-map
                ("C-S-e" . latex-math-from-calc))
    :init
    (setq TeX-auto-save t)
    (setq TeX-parse-self t)
    (setq-default TeX-master nil)
    
    :config
    ;; Format math as a Latex string with Calc
    (defun latex-math-from-calc ()
      "Evaluate `calc' on the contents of line at point."
      (interactive)
      (cond ((region-active-p)
             (let* ((beg (region-beginning))
                    (end (region-end))
                    (string (buffer-substring-no-properties beg end)))
               (kill-region beg end)
               (insert (calc-eval `(,string calc-language latex
                                            calc-prefer-frac t
                                            calc-angle-mode rad)))))
            (t (let ((l (thing-at-point 'line)))
                 (end-of-line 1) (kill-line 0) 
                 (insert (calc-eval `(,l
                                      calc-language latex
                                      calc-prefer-frac t
                                      calc-angle-mode rad))))))))
    

  ;;; Synctex + Zathura Support
  (with-eval-after-load 'tex
    (add-to-list 'TeX-view-program-list
                 '("Zathura"
                   ("zathura %o"
                    (mode-io-correlate
                     " --synctex-forward %n:0:%b -x \"emacsclient +%{line} %{input}\""))
                   "zathura"))
    
    (setq TeX-view-program-selection
          '((output-pdf "Zathura")))
    
    (setq TeX-source-correlate-mode t)
    (setq TeX-source-correlate-start-server t))


    (use-package preview
    	:ensure nil
      :defer t
      :after latex
      :hook ((LaTeX-mode . preview-larger-previews))
      :config
      (defun preview-larger-previews ()
        (setq preview-scale-function
              (lambda () (* 0.8
                            (funcall (preview-scale-from-face)))))))


    (use-package reftex
      :defer t
      :after latex
      :hook (LaTeX-mode . turn-on-reftex)
      :custom
      (reftex-plug-into-AUCTeX t))


    (use-package aas
      :ensure t
      :defer t
      :hook (LaTeX-mode . aas-activate-for-major-mode)
      :hook (org-mode . aas-activate-for-major-mode)
      :config
      ;; (aas-set-snippets 'text-mode
      ;;   ;; expand unconditionally
      ;;   ";o-" "ō"
      ;;   ";i-" "ī"
      ;;   ";a-" "ā"
      ;;   ";u-" "ū"
      ;;   ";e-" "ē")
      ;; (aas-set-snippets 'latex-mode
      ;;   ;; set condition!
      ;;   :cond #'texmathp ; expand only while in math
      ;;   "supp" "\\supp"
      ;;   "On" "O(n)"
      ;;   "O1" "O(1)"
      ;;   "Olog" "O(\\log n)"
      ;;   "Olon" "O(n \\log n)"
      ;;   ;; Use YAS/Tempel snippets with ease!
      ;;   "amin" '(yas "\\argmin_{$1}") ; YASnippet snippet shorthand form
      ;;   "amax" '(tempel "\\argmax_{" p "}") ; Tempel snippet shorthand form
      ;;   ;; bind to functions!
      ;;   ";ig" #'insert-register
      ;;   ";call-sin"
      ;;   (lambda (angle) ; Get as fancy as you like
      ;;     (interactive "sAngle: ")
      ;;     (insert (format "%s" (sin (string-to-number angle))))))
      ;; disable snippets by redefining them with a nil expansion
      (aas-set-snippets 'latex-mode
        "supp" nil))


    (use-package laas
      :ensure t
      :defer t
      :hook (LaTeX-mode . laas-mode)
      :config ; do whatever here
      (aas-set-snippets 'laas-mode
        ;; set condition!
        :cond #'texmathp ; expand only while in math
        "supp" "\\supp"
        "On" "O(n)"
        "O1" "O(1)"
        "Olog" "O(\\log n)"
        "Olon" "O(n \\log n)"
        ;; bind to functions!
        "Sum" (lambda () (interactive)
                (yas-expand-snippet "\\sum_{$1}^{$2} $0"))
        "Span" (lambda () (interactive)
                 (yas-expand-snippet "\\Span($1)$0"))
        ;; add accent snippets
        :cond #'laas-object-on-left-condition
        "qq" (lambda () (interactive) (laas-wrap-previous-object "sqrt"))))



    ;; ORGTBL → LaTeX / AMSMATH integration

    (add-hook 'LaTeX-mode-hook #'orgtbl-mode)

    (defun my-orgtbl-to-latex-rows ()
      "Convert the Org table at point into LaTeX rows (no tabular wrapper)."
      (let* ((table (org-table-to-lisp)))
        (mapconcat
         (lambda (row)
           (concat (mapconcat #'identity row " & ") " \\\\"))
         table
         "\n")))

    (defun my-orgtbl-convert-at-point (_arg)
      "Replace the current Org table with LaTeX rows."
      (interactive "P")
      (unless (org-at-table-p)
        (user-error "Cursor is not inside an Org table"))
      (let ((beg (org-table-begin))
            (end (org-table-end)))
        (let ((latex (my-orgtbl-to-latex-rows)))
          (delete-region beg end)
          (goto-char beg)
          (insert latex "\n"))))

    (with-eval-after-load 'org-table
      ;; Use orgtbl's built-in dispatch key
      ;; (define-key orgtbl-mode-map (kbd "C-c C-t ") #'my-orgtbl-convert-at-point)
      (define-key orgtbl-mode-map (kbd "C-c C-t C-t") #'my-orgtbl-convert-at-point)
      (define-key orgtbl-mode-map (kbd "C-c C-x") #'org-table-align))

(use-package transient :ensure t) ;; TODO investigate confilct with internal transient package 
(use-package magit
  :defer t
  :ensure t)

(use-package markdown-mode
  :defer t
  :ensure t)

;;; My Functions for Emacs  
      ;;;; Mode Line Toggle
  (defvar-local my--saved-mode-line-format mode-line-format
    "Backup of the mode line format for the current buffer.")

  (defun my/toggle-mode-line ()
    "Toggle mode line visibility for the current buffer only."
    (interactive)
    (if mode-line-format
        (progn
          (setq my--saved-mode-line-format mode-line-format)
          (setq mode-line-format nil))
      (setq mode-line-format my--saved-mode-line-format))
    (force-mode-line-update)
    (redraw-display))

    ;;;; Line Number toggle 
  (defvar-local my--saved-display-line-numbers nil
    "Internal storage for previous `display-line-numbers` value.")

  (defun my/toggle-line-numbers ()
    "Toggle line numbers, restoring the previous value when re-enabled."
    (interactive)
    (if display-line-numbers
        ;; Turning OFF
        (progn
          (setq my--saved-display-line-numbers display-line-numbers)
          (setq-local display-line-numbers nil))
      ;; Turning ON
      (setq-local display-line-numbers
                  (or my--saved-display-line-numbers t))))

    ;;;; Reading / Zen Mode
  (defun my/reading-mode ()
    "Enter or exit a distraction-free zen mode."
    (interactive)
    
    ;; Toggle mode-line
    (my/toggle-mode-line)
    
    ;; Toggle line numbers (state-preserving)
    (my/toggle-line-numbers))

    ;;;; Dired Sort Function
  (defun my/dired-sort ()
    "Sort dired listing interactively."
    (interactive)
    (let ((sort-options
           '(("date" . "-Al -t")                    ; newest first
             ("size" . "-Al -S")                    ; biggest first
             ("name" . "-Al --group-directories-first -v")  ; human-readable name sort
             ("dir"  . "-Al --group-directories-first")))  ; dirs first, then natural sort
          choice
          ls-switches)
      (setq choice (completing-read "Sort by (default date): "
                                    sort-options nil t nil nil "date"))
      (setq ls-switches (cdr (assoc choice sort-options)))
      (dired-sort-other ls-switches)))


  ;;;; Get Dired Directory Size 
  (defun my/dired-get-size ()
    "Get total size of all marked files/folders in dired"
    (interactive)
    (let ((files (dired-get-marked-files)))
      (with-temp-buffer
        (apply 'call-process "/usr/bin/du" nil t nil "-sch" files)
        (message "Size of all marked files: %s"
                 (progn 
                   (re-search-backward "\\(^[0-9.,]+[A-Za-z]+\\).*total$")
                   (match-string 1))))))


  (with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "?") #'my/dired-get-size))

  (add-hook 'dired-mode-hook
            (lambda ()
              (evil-define-key 'normal dired-mode-map (kbd "?") #'my/dired-get-size)))


;;; Consult Preview For Any buffer  
(defun my/consult-preview ()
  "Previews candidate in vertico buffer, unless it's a consult command"
  (interactive)
  (unless (bound-and-true-p consult--preview-function)
    (save-selected-window
      (let ((embark-quit-after-action nil))
        (embark-dwim)))))

(define-key minibuffer-local-map (kbd "M-p") #'my/consult-preview)

(add-hook 'after-save-hook
          #'executable-make-buffer-file-executable-if-script-p)

(setq kill-do-not-save-duplicates t)
(setq reb-re-syntax 'string)
(setq help-window-select t) ;; auto shift focus when C-h <v,f,m>

(setq org-src-window-setup 'current-window)  ;; edits in the current window

(require 'org-tempo)

(use-package toc-org
  :defer t
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))

(use-package org
  :defer t
  :hook (org-mode . (lambda ()
                      (org-indent-mode)
                      (setq-local electric-pair-inhibit-predicate
                                  (lambda (c)
                                    (if (char-equal c ?<)
                                        t
                                      (electric-pair-default-inhibit c))))))
  :config
  ;; Load languages
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)
	   (octave . t)))
  ;; Hide leading asterisks in headings
  (setq org-hide-leading-stars t)
  ;; Pretty entities (nicer symbols)
  (setq org-pretty-entities t)
  ;; Skip "Execute?" dialog
  (setq org-confirm-babel-evaluate nil)
  ;; syntax highlighting for LaTex Fragments
  (setq org-highlight-latex-and-related '(latex script entities))
  ;; Hide emphasis markers (*bold* /italic/ =verbatim= etc.)
  (setq org-hide-emphasis-markers t))


(use-package gnuplot
:ensure t
:defer t)

(use-package org-roam
  :defer t
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/org-notes/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol)
  (setq org-link-frame-setup
		'((file . find-file))))

(setq-default cursor-type 'bar)

(setq sentence-end-double-space nil)

(setq make-backup-files nil)

;; Always use vertical split for diffs
(setq ediff-split-window-function #'split-window-horizontally)
;; Never create a new frame for the control panel
(setq ediff-window-setup-function #'ediff-setup-windows-plain)

(global-set-key [remap dabbrev-expand] 'hippie-expand)



(save-place-mode 1)

(desktop-save-mode -1)

(global-auto-revert-mode 1)
;; Helpful to load changed files in dired
(setq global-auto-revert-non-file-buffers t)

(setq use-dialog-box nil)

;; Move customization variables to a separate file and load it
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

;; ;; Disable native clipboard to avoid Wayland/PGTK bugs after Emacs copies
;; (setq select-enable-clipboard nil)
;; (setq select-enable-primary nil)

;; ;; Use wl-clipboard for reliable copy/paste on Wayland
;; (setq wl-copy-process nil)
;; (defun wl-copy (text)
;;   "Copy TEXT to Wayland clipboard using wl-copy."
;;   (setq wl-copy-process (make-process :name "wl-copy"
;;                                        :buffer nil
;;                                        :command '("wl-copy" "-f" "-n")
;;                                        :connection-type 'pipe
;;                                        :noquery t))
;;   (process-send-string wl-copy-process text)
;;   (process-send-eof wl-copy-process))
;; (defun wl-paste ()
;;   "Paste from Wayland clipboard using wl-paste."
;;   (if (and wl-copy-process (process-live-p wl-copy-process))
;;       nil  ; Return nil if we own the clipboard (use kill-ring instead)
;;     (shell-command-to-string "wl-paste -n | tr -d \r")))
;; (setq interprogram-cut-function 'wl-copy)
;; (setq interprogram-paste-function 'wl-paste)

(setq-default tab-width 4)

(electric-pair-mode 1)

(setq-default tab-bar-show 1)

(use-package uniquify
  :ensure nil 
  :config
  (setq uniquify-buffer-name-style 'post-forward)
  (setq uniquify-separator " | ")
  (setq uniquify-after-kill-buffer-p t)
  (setq uniquify-ignore-buffers-re "^\\*"))

;; Define languages to install
(setq treesit-language-source-alist
      '((python "https://github.com/tree-sitter/tree-sitter-python")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript")
        (c       "https://github.com/tree-sitter/tree-sitter-c")
		(lua "https://github.com/tree-sitter-grammars/tree-sitter-lua")
        (cpp     "https://github.com/tree-sitter/tree-sitter-cpp")
        (rust    "https://github.com/tree-sitter/tree-sitter-rust")
        (go      "https://github.com/tree-sitter/tree-sitter-go")
		(julia  "https://github.com/tree-sitter/tree-sitter-julia")
        (java    "https://github.com/tree-sitter/tree-sitter-java")))

(setq treesit-font-lock-level 4)
(use-package treesit-auto
    :ensure t
    :custom
    (treesit-auto-install 'prompt)
    :config
    (treesit-auto-add-to-auto-mode-alist 'all)
    (global-treesit-auto-mode))

(use-package vundo
  :ensure t
  :bind ("C-x u" . vundo)
  :config
  ;; Take less on-screen space.
  (setq vundo-compact-display t)
  ;; Use `HJKL` VIM-like motion, also Home/End to jump around.
  (define-key vundo-mode-map (kbd "l") #'vundo-forward)
  (define-key vundo-mode-map (kbd "<right>") #'vundo-forward)
  (define-key vundo-mode-map (kbd "h") #'vundo-backward)
  (define-key vundo-mode-map (kbd "<left>") #'vundo-backward)
  (define-key vundo-mode-map (kbd "j") #'vundo-next)
  (define-key vundo-mode-map (kbd "<down>") #'vundo-next)
  (define-key vundo-mode-map (kbd "k") #'vundo-previous)
  (define-key vundo-mode-map (kbd "<up>") #'vundo-previous)
  (define-key vundo-mode-map (kbd "<home>") #'vundo-stem-root)
  (define-key vundo-mode-map (kbd "<end>") #'vundo-stem-end)
  (define-key vundo-mode-map (kbd "q") #'vundo-quit)
  (define-key vundo-mode-map (kbd "C-g") #'vundo-quit)
  (define-key vundo-mode-map (kbd "RET") #'vundo-confirm))

(winner-mode +1)

(defun toggle-delete-other-windows ()
  "Delete other windows in frame if any, or restore previous window config."
  (interactive)
  (if (and winner-mode
           (equal (selected-window) (next-window)))
      (winner-undo)
    (delete-other-windows)))

(use-package zoxide
  :ensure t
  :init
  (global-set-key (kbd "C-x C-j") 'zoxide-find-file))

;;; Emacs Specifc Binidngs 
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)
(global-set-key (kbd "<C-tab>") #'mode-line-other-buffer)
(global-set-key (kbd "C-x C-c") #'kill-buffer-and-window)
(global-set-key (kbd "C-c u") #'insert-char)
(global-set-key (kbd "C-<return>") #'eval-print-last-sexp)
(global-set-key (kbd "C-x g") #'magit)
(global-set-key (kbd "C-x C-z") #'my/reading-mode)
(global-set-key (kbd "C-c e") #'evil-mode)
(global-set-key (kbd "C-c w w") #'delete-other-windows)
(global-set-key (kbd "C-c w m") #'maximize-window)
(global-set-key (kbd "C-c w M") #'balance-windows)
(global-set-key (kbd "C-c w u") 'winner-undo)
(global-set-key (kbd "C-c w r") 'winner-redo)
(global-set-key (kbd "C-x 1") #'toggle-delete-other-windows)

(use-package general
  :ensure t
  :config
  (general-evil-setup t)
  
  (general-create-definer my-leader-def
    :states '(normal visual motion emacs)
    :keymaps 'override
    :prefix "SPC")
  
  
  (my-leader-def
    ;; Core
    "SPC" 'execute-extended-command
	"!" 'shell-command
    
    ;; Files
    "ff"  'consult-find
    "fp"  'find-file
    "fg"  'consult-ripgrep
    "fS"  'consult-locate
    "fb"  'consult-buffer
    "fr"  'consult-recent-file
    "fd"  'consult-imenu
    "fD"  'consult-imenu-multi
    "fo"  'consult-outline
    "fl"  'consult-focus-lines
    "fj"  'zoxide-find-file
    "xf"  'find-file
    
    ;; Diagnostics / Dir
    "df"  'consult-flymake
    "de"  'consult-dir
    "dj"  'dired-jump
    "cd"  'zoxide-travel
    
    ;; Buffers
    "bb"  'consult-buffer
    "bk"  'kill-current-buffer
    "bs"  'save-buffer
    "ib"  'ibuffer
    
    ;; Yank
    "yy"  'consult-yank-from-kill-ring
    "yY"  'consult-yank-from-kill-ring
    
    ;; Theme
    "th"  'consult-theme
    
    ;; Windows
    "wq"  'kill-buffer-and-window
    "wd"  'delete-window
    
    ;; Search
    "cl"  'consult-line
    "cL"  'consult-line-multi
    "gg"  'consult-goto-line
    
    ;; Project
    "pp"  'project-switch-project
    "pb"  'consult-project-buffer
    "pd"  'project-find-dir
    "pf"  'project-find-file
    "pg"  'project-find-regexp
    "pD"  'project-dired
    "ps"  'project-shell
    "pk"  'project-kill-buffers
    "pr"  'project-shell-command
    
    ;; Bookmarks
    "mm"  'consult-bookmark
    "mi"  'bookmark-insert
    "ml"  'bookmark-insert-location
    "mj"  'bookmark-bmenu-list
    
    ;; Insert / Spell
    "ic"  'insert-char
    "is"  'ispell
    
    ;; LSP / Code
    "cf"  'eglot-format
    "er"  'eglot-rename
    "sl"  'imenu
    
    ;; Snippets
    "si"  'yas-insert-snippet
    "sn"  'yas-new-snippet
    "se"  'yas-visit-snippet-file
    
    ;; Magit / System
    "mg"  'magit
    "vt"  'vterm
    
    ;; Narrowing
    "xnn" 'narrow-to-region
    "xnp" 'narrow-to-page
    "xnd" 'narrow-to-defun
    "xnw" 'widen
    ;; Org
    "oa" #'org-agenda
    "oc" #'org-capture
	;; Latex'
	"cm" #'latex-math-from-calc
    )
  (general-define-key
   :states '(normal)
   "K" #'eldoc-box-help-at-point
   "C-<left>"  #'shrink-window-horizontally
   "C-<right>" #'enlarge-window-horizontally
   "C-<up>"    #'enlarge-window
   "C-<down>"  #'shrink-window)
  (general-define-key
   :states '(normal insert)
   "C-j"
   (lambda ()
     (interactive)
     (if (and (fboundp 'eldoc-box--frame-visible-p)
              (eldoc-box--frame-visible-p))
         (eldoc-box-scroll-up 4)
       (evil-next-visual-line)))
   
   "C-k"
   (lambda ()
     (interactive)
     (if (and (fboundp 'eldoc-box--frame-visible-p)
              (eldoc-box--frame-visible-p))
         (eldoc-box-scroll-down 4)
       (evil-previous-visual-line))))
  
  
  (my-leader-def
	:keymaps 'org-mode-map
	:states '(normal visual)
	"cb" #'org-toggle-checkbox
	"th" #'org-toggle-heading
	"co" #'org-open-at-point
	"lp" #'org-latex-preview)
  
  (my-leader-def
	:keymaps 'python-ts-mode-map
	:states '(normal)
	"cc" #'python-shell-send-buffer
	"cr" #'python-shell-send-region
	"co" #'run-python
	"ce" #'python-shell-send-statement)
  
  
  (my-leader-def
	:keymaps 'julia-mode-map
	:states '(normal)
	"cc" #'julia-repl-send-buffer
	"cr" #'julia-repl-send-region-or-line
	"co" #'julia-repl
	"ce" #'julia-repl-send-line)
  
  
  (my-leader-def
	:keymaps 'LaTeX-mode-map
	:states '(normal)
	
	;; Compile / View
	"ll"  #'TeX-command-master
	"lb"  #'TeX-command-buffer
	"lv"  #'TeX-view
	
	;; Environments
	"le"  #'LaTeX-environment
	"ls"  #'LaTeX-section
	"lm"  #'TeX-insert-macro
	

	;; calc
	"cm" #'latex-math-from-calc
	;; Preview
	"lpp" #'preview-at-point
	"lps" #'preview-section
	"lpd" #'preview-document
	"lpb" #'preview-buffer
	"lpc" #'preview-clearout-buffer
	
	;; Reftex
	"rr"  #'reftex-reference
	"rl"  #'reftex-label
	"rc"  #'reftex-citation
	"rt"  #'reftex-toc)
  
  (my-leader-def
	:keymaps 'LaTeX-mode-map
	:states '(visual)
	"lpp" #'preview-region
	"lpc" #'preview-clearout
	)
  
  )

;; (load-theme 'modus-vivendi t)

;; Mainstream, highly readable font with excellent metrics
(set-face-attribute 'default nil
                    :family "Adwaita Mono"
                    :height 180)

;; Keeps code blocks and tables perfectly matched to the default prose size
(set-face-attribute 'fixed-pitch nil
                    :family "Adwaita Mono"
                    :height 180)



;; Italics for comments
(custom-set-faces
 '(font-lock-comment-face ((t (:slant italic)))))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode t)

(setq-default display-line-numbers 'visual ;; behaves well with folds
  	    display-line-numbers-current-absolute t)
(setq-default truncate-lines t)

;;; bash timedatectl list-timezones to get list of timezones
(with-eval-after-load 'time
    (setq world-clock-list   
          '(("Asia/Kolkata" "India")
            ("Europe/London" "United Kingdom")
			("America/New_York" "New York")
            ("Asia/Tokyo" "Japan")
            ("Europe/Paris" "France"))))
