(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(eval-when-compile (require 'use-package))
(require 'use-package-ensure)
(setq use-package-always-ensure t)
(when (not package-archive-contents)
    (package-refresh-contents))

(add-hook 'tex-mode-hook 'turn-on-auto-fill)

(use-package auctex
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (LaTeX-electric-left-right-brace t)
  :hook
  (TeX-mode . prettify-symbols-mode)
  (LaTeX-mode . (lambda ()
                  (push (list 'output-pdf "Zathura")
                        TeX-view-program-selection)))
  (doc-view-mode . (lambda () (display-line-numbers-mode -1)))
  )

(use-package yasnippet
  :config
  (yas-global-mode 1)
  (use-package yasnippet-snippets))

;; Spell check a single word or region: M-$
;; Change the language of a single buffer: M-x ispell-change-dictionary
;(setq-default ispell-aspell-dict-dir nil) ;; Uncomment if aspell dict dir breaks and restart emacs
(use-package ispell
  :custom
  (ispell-program-name "aspell")
  (ispell-dictionary "brasileiro") ; or english
  (ispell-dictionary-alist (ispell-find-aspell-dictionaries))
  )
(use-package flyspell
  :hook
  (org-mode . flyspell-mode)
  (text-mode . (lambda () ;; Don't start flyspell in the scratch buffer
                 (unless (string= (buffer-name) "*scratch*") (flyspell-mode))
                 ))
  )

(use-package symbol-overlay
  :hook (TeX-mode . symbol-overlay-mode))
