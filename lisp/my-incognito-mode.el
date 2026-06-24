;;; my-incognito.el --- Intermittent privacy control for Emacs -*- lexical-binding: t; -*-

;;; Commentary:
;; This package provides a command to quickly toggle off all history, 
;; backups, and session tracking features.

;;; Code:
(defvar my/incognito-mode-active nil
  "Tracks the state of Emacs incognito mode.")

;;;###autoload
(defun my/incognito-mode ()
  "Toggle a leak-proof incognito mode that blocks all history and file states."
  (interactive)
  (if my/incognito-mode-active
      (progn
        (setq history-length 100)
        (setq write-region-inhibit-fsync nil)
        (when (fboundp 'recentf-mode) (recentf-mode 1))
        (when (fboundp 'save-place-mode) (save-place-mode 1))
        (when (fboundp 'savehist-mode) (savehist-mode 1))
        (setq my/incognito-mode-active nil)
        (message "Incognito Mode: DISABLED (History logging resumed)"))
    (progn
      ;; 1. Freeze Mini-buffer & Command History
      (setq history-length 0)
      (setq minibuffer-history-variable nil)
      (when (fboundp 'savehist-mode) (savehist-mode -1))
      
      ;; 2. Disable File and Position Tracking
      (when (fboundp 'recentf-mode) (recentf-mode -1))
      (when (fboundp 'save-place-mode) (save-place-mode -1))
      (when (fboundp 'desktop-save-mode) (desktop-save-mode -1))
      
      ;; 3. Block Package-Specific History
      (setq projectile-merge-cached-projects nil)
      (when (fboundp 'undo-fu-session-global-mode) (undo-fu-session-global-mode -1))
      
      ;; 4. Disable Auto-Save and Backups globally
      (setq make-backup-files nil)
      (setq auto-save-default nil)
      (setq auto-save-list-file-prefix nil)
      
      (setq my/incognito-mode-active t)
      (message "Incognito Mode: ENABLED (No history, backups, or states saved)"))))

(provide 'my-incognito)
;;; my-incognito.el ends here
