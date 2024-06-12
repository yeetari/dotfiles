(require 'use-package)

(use-package consult
  :bind (([remap switch-to-buffer] . consult-buffer)
     ([remap goto-line] . consult-goto-line)
     ([remap imenu] . consult-imenu)
     ([remap bookmark-jump] . consult-bookmark)
     ("M-s d" . consult-find)
     ("M-s g" . consult-grep)))

(use-package vertico
  :init (vertico-mode))

(set-frame-font "Fantasque Sans Mono 14" nil t)

;; Enable cut, copy, paste, and undo on C-x, C-c, C-v, C-z.
(cua-mode 1)

;; Disable ~ backup files.
(setq make-backup-files nil)

;; Enable autoreload for DocView buffers.
(add-hook 'doc-view-mode-hook 'auto-revert-mode)
