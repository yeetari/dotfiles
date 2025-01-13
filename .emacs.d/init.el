(use-package company
  :hook (cmake-mode eglot-managed-mode))

(use-package compile
  :defer t
  :config

  ;; Hide compile buffers after one second if they succeed.
  (defun bury-if-successful (buffer string)
    (if (and
         (string-match "compilation" (buffer-name buffer))
         (string-match "finished" string)
         (not
          (with-current-buffer buffer
            (search-forward "warning" nil t))))
        (run-with-timer 1 nil
                        (lambda (buf)
                          (bury-buffer buf)
                          (switch-to-prev-buffer (get-buffer-window buf) 'kill))
                        buffer)))
  (add-hook 'compilation-finish-functions #'bury-if-successful))

(use-package consult
  :bind (([remap switch-to-buffer] . consult-buffer)
         ([remap goto-line] . consult-goto-line)
         ([remap imenu] . consult-imenu)
         ([remap bookmark-jump] . consult-bookmark)
         ("M-s d" . consult-find)
         ("M-s g" . consult-grep)))

(use-package doc-view
  :hook (doc-view-mode . auto-revert-mode))

(use-package eglot
  :defer t
  :config
  (setq eglot-ignored-server-capabilities '(:hoverProvider :inlayHintProvider)))

(use-package emacs
  :init
  (set-frame-font "Fantasque Sans Mono 14" nil t)

  ;; Increase GC threshold by a lot.
  (setq gc-cons-threshold (* 32 1024 1024))

  ;; Disable # autosave files.
  (setq auto-save-default nil)

  ;; Disable ~ backup files.
  (setq make-backup-files nil)

  ;; Hide commands in M-x which do not work in the current mode.
  (setq read-extended-command-predicate #'command-completion-default-include-p)

  ;; Set indent style to four spaces.
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 4)

  ;; Mark c-file-offsets as safe.
  (put 'c-file-offsets 'safe-local-variable (lambda (x) t))

  ;; Mark cmake-tab-width as safe.
  (put 'cmake-tab-width 'safe-local-variable #'numberp)

  (defun current-line-empty-p ()
    (save-excursion
      (beginning-of-line)
      (looking-at-p "[[:blank:]]*$")))

  (defun delete-current-line ()
    (interactive)
    (delete-region
     (line-beginning-position)
     (line-end-position))
    (delete-char 1))

  (defun smart-backward-kill-word ()
    (interactive)
    (if (current-line-empty-p)
        (progn (delete-current-line) (backward-char))
      (backward-kill-word 1)))

  (defvar keys-mode-keymap (make-keymap))
  (bind-key "C-d" #'delete-current-line keys-mode-keymap)
  (bind-key "C-<backspace>" #'smart-backward-kill-word keys-mode-keymap)

  (define-minor-mode keys-mode ""
    :lighter " Keys"
    :keymap keys-mode-keymap)
  :hook (prog-mode . keys-mode)
  :hook (LaTeX-mode . keys-mode)
  :bind ("C-z" . undo))

(use-package marginalia
  :init (marginalia-mode)
  :bind (:map minibuffer-local-map ("M-a" . marginalia-cycle)))

(use-package orderless
  :config

  ;; Configure orderless as the default style dispatcher with basic as a fallback.
  (setq completion-styles '(orderless basic))

  ;; Enable partial completion for file path expansion (find-file).
  (setq completion-category-overrides '((file (styles partial-completion)))))

(use-package sgml-mode
  :defer t
  :config
  (setq-default sgml-basic-offset tab-width))

(use-package tex-site
  :config

  ;; Enable TeX parsing on load and explicitly set master file.
  (setq TeX-parse-self t)
  (setq-default TeX-master "main")

  ;; Disable fontification of subscripts and superscripts.
  (setq tex-fontify-script nil)
  (setq font-latex-fontify-script nil)

  ;; Keep colours but remove large fontification of section headers.
  (setq font-latex-fontify-sectioning 'color))

(use-package vertico
  :init (vertico-mode)
  :bind (:map vertico-map
              ("TAB" . minibuffer-complete)
              ("RET" . vertico-directory-enter)))

(use-package which-key
  :init (which-key-mode))
