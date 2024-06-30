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

(use-package emacs
  :init
  (set-frame-font "Fantasque Sans Mono 14" nil t)

  ;; Enable cut, copy, paste, and undo on C-x, C-c, C-v, C-z.
  (cua-mode 1)

  ;; Disable # autosave files.
  (setq auto-save-default nil)

  ;; Disable ~ backup files.
  (setq make-backup-files nil)

  ;; Hide commands in M-x which do not work in the current mode.
  (setq read-extended-command-predicate #'command-completion-default-include-p)

  ;; Set indent style to four spaces.
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 4))

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
  :mode ("\\.tex\\'" . LaTeX-mode)
  :config

  ;; Enable TeX parsing on load and explicitly set master file.
  (setq TeX-parse-self t)
  (setq-default TeX-master "main")

  ;; Disable fontification of subscripts and superscripts.
  (setq font-latex-fontify-script nil)

  ;; Keep colours but remove large fontification of section headers.
  (setq font-latex-fontify-sectioning 'color)

  (setq-default LaTeX-indent-level tab-width))

(use-package vertico
  :init (vertico-mode)
  :bind (:map vertico-map ("TAB" . minibuffer-complete)))

(use-package which-key
  :init (which-key-mode))
