(defconst user-init-dir
  (cond
   ((boundp 'user-emacs-directory) user-emacs-directory)
   ((boundp 'user-init-directory) user-init-directory)
   (t "~/.emacs.d/")))

(defun load-user-file (file)
  "Load a file in current user's configuration directory."
  (interactive "f")
  (load-file (expand-file-name file user-init-dir)))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

(require 'package)
(setq package-archives 
      '(("melpa" . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")
        ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(setq gc-cons-threshold (* 50 1000 1000))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure 't)

(set-face-attribute 'default nil
                    :font "Fira Code Retina"
                    :height 170)
(setq-default fill-column 80)
(setq-default line-spacing 2)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
(global-display-fill-column-indicator-mode t)
(line-number-mode 1) 
(column-number-mode 0)

(tooltip-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(blink-cursor-mode 0)
(setq use-dialog-box nil)
(set-fringe-mode 0)
(menu-bar-mode 0)

(make-directory
 (expand-file-name "backups/" user-emacs-directory) t)

(setq backup-directory-alist `(("." . ,(expand-file-name "backups/" user-emacs-directory)))
      backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 20   ; how many of the newest versions to keep
      kept-old-versions 5    ; and how many of the old
      )

(setq dired-dwim-target t) 
(setq delete-by-moving-to-trash t) 
(put 'dired-find-alternate-file 'disabled nil)
(setq dired-listing-switches "-agho --group-directories-first")

(savehist-mode 1)
(save-place-mode 1)
(setq history-length 25)
(global-auto-revert-mode 1)

(setq inhibit-startup-message t
      initial-major-mode 'org-mode
      initial-buffer-choice "~/Dropbox/sandbox.org")
(setq use-dialog-box nil)

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                   (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

(defun toggle-transparency ()
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter
     nil 'alpha
     (if (eql (cond ((numberp alpha) alpha)
                    ((numberp (cdr alpha)) (cdr alpha))
                    ;; Also handle undocumented (<active> <inactive>) form.
                    ((numberp (cadr alpha)) (cadr alpha))) 95)
         '(95 . 95) '(100 . 100)))))

(defun transparency (value)
  "Sets the transparency of the frame window. 0=transparent/100=opaque"
  (interactive "nTransparency Value 0 - 100 opaque:")
  (set-frame-parameter (selected-frame) 'alpha value))

(transparency 90)

(use-package beacon
  :diminish
  :config
  (beacon-mode 1)
  :custom
  (becon-push-mark 35))

(use-package nerd-icons
  :defer t)

(use-package doom-modeline 
  :init
  (doom-modeline-mode 1)
  :custom
  (doom-modeline--font-height 6))


(use-package doom-themes 
  :init
  (load-theme 'doom-palenight t))


(use-package rainbow-delimiters 
  :hook (prog-mode . rainbow-delimiters-mode))

(setq ispell-dictionary "english")

(use-package sly)

(use-package no-littering
  :diminish
  :defer t)

(use-package general  
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (rune/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package evil 
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection 
  :after evil
  :config
  (evil-collection-init))

(use-package undo-tree
  :ensure t
  :after evil
  :diminish
  :config
  (evil-set-undo-system 'undo-tree)
  (global-undo-tree-mode 1))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package auto-complete
  :diminish
  :config
  (auto-complete-mode 1))

(use-package paren
  :diminish
  :config (show-paren-mode))

(use-package eldoc
  :defer t
  :config (global-eldoc-mode))

(use-package paredit
  :demand t
  :bind
  (:map paredit-mode-map
        ("M-s" . nil))
  :config
  (add-hook 'emacs-lisp-mode-hook #'paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode))

(use-package which-key
  :init
  :config
  (which-key-mode)
  (setq which-key-idle-dely 0.5)
  (which-key-setup-minibuffer))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :diminish ivy-mode
  :diminish counsel-mode
  :bind (("C-s" . swiper)
         ("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :init
  (ivy-mode 1)
  (counsel-mode 1)
  :config
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t))

(use-package ivy-prescient
  :after counsel
  :init
  (ivy-prescient-mode)
  (prescient-persist-mode))

(use-package prescient
  :defer 0
  :diminish
  :config)

(use-package helpful  
  :defer t
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(defhydra hydra-text-scale (:timeout 4) 
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook 
  (lsp-mode . lsp-enable-which-key-integration)
  :custom
  (lsp-diagnostics-provider :capf)
  (lsp-headerline-breadcrumb-enable t)
  (lsp-headerline-breadcrumb-segments '(project file symbols))
  (lsp-lens-enable nil)
  (lsp-disabled-clients '((python-mode . pyls)))
  :init
  (setq lsp-keymap-prefix "C-c l")) ;; Or 'C-l', 's-l'

(use-package lsp-ivy
  :after lsp-mode)

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :after lsp-mode
  :custom
  (lsp-ui-doc-show-with-cursor nil)
  :config
  (setq lsp-ui-doc-position 'bottom))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package lsp-treemacs
  :after (lsp-mode treemacs))

(use-package lsp-pyright
  :hook
  (python-mode . (lambda ()
                   (require 'lsp-pyright)
                   (lsp-deferred))))

(use-package blacken
  :defer t
  :init
  (setq-default blacken-fast-unsafe nil))
  ;; (setq-default blacken-line-length 80)

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package company-prescient
  :after company
  :config
  (company-prescient-mode 1)
  (prescient-persist-mode))

(global-company-mode)

(use-package projectile  
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Dropbox/Projects/Code")
    (setq projectile-project-search-path '("~/Dropbox/Projects/Code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile  
  :config (counsel-projectile-mode))

(use-package magit 
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package forge)

(add-hook 'text-mode-hook 'visual-line-mode) ;; Sensible line breaking
(delete-selection-mode t) ;; Overwrite selected text
(setq scroll-error-top-bottom t)

(use-package flyspell
   :config
   ;; (setq ispell-program-name "hunspell"
   ;;       ispell-default-dictionary "en_AU")
   :hook (text-mode . flyspell-mode)
   :bind (("M-<f7>" . flyspell-buffer))
          ("<f7>" . flyspell-word)
          ("C-;" . flyspell-auto-correct-previous-word))

(use-package deft
  :config
  (setq deft-directory org-directory
        deft-recursive t
        deft-strip-summary-regexp ":PROPERTIES:\n\\(.+\n\\)+:END:\n"
        deft-use-filename-as-title t)
  :bind
  ("C-c n d" . deft))

(use-package eldoc
  :diminish eldoc-mode)

(use-package flycheck
  :diminish flycheck-mode
  :init
  (setq flycheck-check-syntax-automatically '(save new-line)
        flycheck-idle-change-delay 5.0
        flycheck-display-errors-delay 0.9
        flycheck-highlighting-mode 'symbols
        flycheck-indication-mode 'left-fringe
        flycheck-standard-error-navigation t
        flycheck-deferred-syntax-check nil))

(use-package yasnippet
  :ensure t
  :diminish
  :config
  (use-package yasnippet-snippets)
  (yas-reload-all)
  (yas-global-mode 1))

(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
(define-key yas-minor-mode-map (kbd "<C-tab>") 'yas-expand)

(use-package python-mode
  :hook
  (python-mode . flycheck-mode)
  (python-mode . company-mode)
  (python-mode . blacken-mode)
  (python-mode . yas-minor-mode)
  :custom
  (python-shell-interpreter "python3") 
  :config
  )


(use-package pyvenv
  :defer t
  :hook (pyvenv-mode . python-mode)
  :config
  (pyvenv-mode 1))

(use-package  yaml-mode
  :ensure t)

(setq image-dired-external-viewer "/usr/bin/gimp")

(use-package org)

(setq org-startup-indented t
      org-pretty-entities t
      org-hide-emphasis-markers t
      org-startup-with-inline-images t
      org-image-actual-width '(200))

(use-package org-appear
  :hook (org-mode . org-appear-mode))

(use-package deft
  :defer t
  :config
  (setq deft-directory org-directory
        deft-recursive t
        deft-strip-summary-regexp ":PROPERTIES:\n\\(.+\n\\)+:END:\n"
        deft-use-filename-as-title t))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (python . t) 
   (shell . t) 
   (haskell . t) 
   (latex . t) 
   (matlab . t)
   (sql . t)
   (emacs-lisp . t)))

(setq org-babel-python-command "python3")


(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (efs/org-font-setup))


(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "●" "○" "●" "○" "●" "○" "●")))


(setq sql-postgres-login-params
      '((user :default "postgres")
        (database :default "analysis")
        (server :default "localhost")
        (port :default 5432)))

(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page))

(use-package auctex
  :ensure t
  :defer t
  :hook (LaTeX-mode . (lambda ()
                        (push (list 'output-pdf "Zathura")
                              TeX-view-program-selection)))
        (LaTeX-mode . turn-on-prettify-symbols-mode))

(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-source-correlate-start-server t)

(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)

(put 'LaTeX-narrow-to-environment 'disabled nil)

(use-package cdlatex
  :hook (LaTeX-mode . cdlatex-mode)
  :config
  (cdlatex-mode 1))

(use-package company-math)
  ;; :hook (LaTeX-mode . company-math)

(use-package laas
  :hook (LaTeX-mode . lass-mode))

(add-hook 'TeX-mode-hook #'TeX-fold-mode)
(add-hook 'TeX-language-dk-hook
          (lambda () (ispell-change-dictionary "english")))

;; Enable parse on load and save.
(setq TeX-parse-self t)
(setq TeX-auto-save t)

(add-hook 'TeX-mode-hook 'flyspell-mode)
(add-hook 'TeX-mode-hook
          (lambda () (TeX-fold-mode 1)))
(add-hook 'TeX-mode-hook 'LaTeX-math-mode)
(add-hook 'TeX-mode-hook 'turn-on-reftex)

(use-package minions
  :custom
  (minions-mode 1))

(use-package csv-mode
  :mode "\\.csv\\'"
  :preface
  (defun csv-remove-commas ()
    (interactive)
    (goto-char (point-min))
    (while (re-search-forward "\"\\([^\"]+\\)\"" nil t)
      (replace-match (replace-regexp-in-string "," "" (match-string 1))))))

(use-package markdown-mode
  :mode (("\\`README\\.md\\'" . gfm-mode)
         ("\\.md\\'"          . markdown-mode)
         ("\\.markdown\\'"    . markdown-mode))
  :custom
  (markdown-command "pandoc -f markdown_github+smart")
  (markdown-command-needs-filename t)
  (markdown-enable-math t)
  (markdown-open-command "marked")
  :custom-face
  (markdown-header-face-1 ((t (:inherit markdown-header-face :height 2.0))))
  (markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.6))))
  (markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.4))))
  (markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.2))))
  :init
  (setq markdown-command "multimarkdown"))

(use-package markdown-preview-mode
  :after markdown-mode
  :config
  (setq markdown-preview-stylesheets
        (list (concat "https://github.com/dmarcotte/github-markdown-preview/"
                      "blob/master/data/css/github.css"))))

(use-package elisp-lint)

(use-package focus)

(use-package aggressive-indent
  :diminish
  :hook (emacs-lisp-mode . aggressive-indent-mode))

(use-package emojify
  :after erc
  :config
  (global-emojify-mode))

(rune/leader-keys
  "sq" '(sql-postgres :which-key "sql-postgres")
  "ww" '(evil-window-next :which-key "evil-window-next")
  "mm" '(markdown-mode :which-key "markdown-mode")
  "mv" '(markdown-view-mode :which-key "markdown-view-mode")
  "ts" '(hydra-text-scale/body :which-key "scale text")
  "cc" '(TeX-command-run-all :which-key "Tex-command-run-all")
  "cb" '(kill-this-buffer :which-key "kill-this-buffer")
  "cn" '(global-display-line-numbers-mode :which-key "global-display-number-mode")
  "tm" '(vterm :which-key "vterm")
  "ss" '(sly :which-key "sly")
  "cl" '(global-display-fill-column-indicator-mode :which-key "global-display-fill-column-indicator-mode")
  "bm" '(blacken-mode :which-key "blacken-mode")
  "tc" '(TeX-clean :which-key "TeX-clean")
  "lb" '(list-buffers :which-key "list-buffers")
  "tp" '(transparency :which-key "transparency")
  "bf" '(eval-buffer :which-key "eval-buffer")
)

(global-set-key (kbd "C-c t") 'toggle-transparency)

(global-set-key (kbd "<f1>") (lambda() (interactive) (find-file "~/Dropbox/mat265/")))
(global-set-key (kbd "<f2>") (lambda() (interactive) (find-file "~/Dropbox/GTD.org")))
(global-set-key (kbd "<f3>") (lambda() (interactive) (find-file "~/.config/")))
(global-set-key (kbd "<f4>") (lambda() (interactive) (find-file "~/Dropbox/research/clustering_particles/density_estimation")))
(global-set-key (kbd "<f5>") (lambda() (interactive) (find-file "~/.dotfiles/")))
(global-set-key (kbd "<f6>") (lambda() (interactive) (find-file "~/Dropbox/projects/")))

;; (load-user-file "./config/terminal.el")
;; (load-user-file "./config/project.el")
;; (load-user-file "./config/lsp.el")
;; (load-user-file "./config/orgmode.el")
;; (load-user-file "./config/latex.el")
;; (load-user-file "./config/kbd.el")

(use-package term
  :defer t
  :config
  (setq explicit-shell-file-name "bash") 
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package vterm
  :defer t
  :config
  (setq explicit-shell-file-name "bash") 
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(dolist (mode '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook
                vterm-mode-hook
                treemacs-mode-hook))
  (add-hook mode (lambda ()
                   (display-line-numbers-mode -1))))

(use-package haskell-mode
  :defer t)
(require 'haskell-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(setq-default indent-tabs-mode nil)
