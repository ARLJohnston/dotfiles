;; Do as early as possible to avoid flashbang
(load-theme 'modus-vivendi-tinted t)

(defun my/nixos-p ()
  "Return t if operating system is NixOS, nil otherwise."
  (string-match-p "NixOS" (shell-command-to-string "uname -v")))

(defun my/nixos/get-emacs-build-date ()
  "Return NixOS Emacs build date."
  (string-match "--prefix.*emacs.*\\([[:digit:]]\\{8\\}\\)"
                system-configuration-options)
  (string-to-number (match-string 1 system-configuration-options)))

(when (my/nixos-p) (setq default-frame-alist '((undecorated . t))))

;; Needed on NixOS-WSL
(setq elpaca-core-date (list (my/nixos/get-emacs-build-date)))


;; Set *very* short proced format when nix (which has very long path names for processes)
(when (my/nixos-p)
  (setq proced-format-alist
        '((short user pid tree pcpu pmem start time (comm)))))

(add-to-list 'default-frame-alist
             '(font . "MonoLisa Nerd Font-10"))

(set-face-attribute 'default nil
                    :family "MonoLisa Nerd Font"
                    ;; :height 200
                    :weight 'normal
                    :width 'condensed)

(defvar elpaca-installer-version 0.7)
(defvar elpaca-directory
  (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory
  (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory
  (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo
                        "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1
                              :files
                              (:defaults "elpaca-test.el"
                                         (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let
            ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                 ((zerop (apply #'call-process `("git" nil ,buffer t
                                                 "clone"
                                                 ,@(when-let ((depth (plist-get order :depth)))
                                                     (list (format "--depth=%d" depth) "--no-single-branch"))
                                                 ,(plist-get order
                                                             :repo)
                                                 ,repo))))
                 ((zerop (call-process "git" nil buffer t "checkout"
                                       (or (plist-get order :ref) "--"))))
                 (emacs (concat invocation-directory invocation-name))
                 ((zerop (call-process emacs nil buffer nil "-Q" "-L"
                                       "." "--batch"
                                       "--eval"
                                       "(byte-recompile-directory \".\" 0 'force)")))
                 ((require 'elpaca))
                 ((elpaca-generate-autoloads "elpaca" repo)))
            (progn
              (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  (elpaca-use-package-mode))

(elpaca-wait)

(use-package general
  :config
  (general-auto-unbind-keys)
  (general-evil-setup t)
  (general-create-definer rune/leader-keys
    :states
    '(normal visual motion emacs insert)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")
  :ensure t
  :demand t)

(elpaca-wait)

(use-package evil
  :custom
  (evil-want-integration t)
  (evil-want-keybinding nil)
  (evil-want-C-u-scroll t)
  (evil-undo-function 'undo-only)
  (evil-redo-function 'undo-redo)
  (evil-undo-system 'undo-redo)
  :config
  (evil-mode 1)
  :ensure t)

(use-package evil-collection
  :config
  (evil-collection-init)
  :diminish evil-collection-unimpaired-mode
  :after evil
  :ensure t)

(use-package emacs
  :custom
  (native-comp-speed 3)
  (ring-bell-function 'ignore)
  (initial-scratch-message 'nil)
  (read-extended-command-predicate
   #'command-completion-default-include-p)
  (scroll-step 1)
  (scroll-margin 4)
  (display-line-numbers-type 'relative)
  (default-tab-width 2)
  (warning-minimum-level :error)
  (text-mode-ispell-word-completion nil)
  (global-auto-revert-non-file-buffers t)
  :init
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (global-display-line-numbers-mode 1)
  (global-auto-revert-mode 1)
  (save-place-mode 1)
  (global-auto-revert-mode 1)
  (fido-vertical-mode 1)
  (savehist-mode)
  (recentf-mode)
  (display-battery-mode)
  ;;(electric-indent-mode -1)
  (setq backup-directory-alist '(("." . "~/.backups"))
        backup-by-copying t    ; Don't delink hardlinks
        version-control t      ; Use version numbers on backups
        delete-old-versions t
        kept-new-versions 20
        kept-old-versions 5)
  (setq auto-save-file-name-transforms '((".*" "~/.autosaves/" t)))
  (winner-mode 1)
  (global-visual-line-mode)
  (setq custom-file "~/.emacs-custom.el") ;; Apply and save customisations to writable file
  :bind
  ("C-c h" . winner-undo)
  ("C-c l" . winner-redo)
  ("C-c c" . comment-or-uncomment-region)
  ("C-c /" . comment-or-uncomment-region)
  ("C-x s" . save-buffer)
  ("C-x S" . save-some-buffers)
  :general
  (rune/leader-keys
    "bk" 'kill-current-buffer
    "bm" 'buffer-menu
    "bi" 'recentf
    "SPC" 'find-file
    "r" 'switch-to-buffer
    ;; God mode bindings
    "w" (general-simulate-key "C-w")
    "x" (general-simulate-key "C-x")
    "c" (general-simulate-key "C-c")
    )

  (general-define-key
   :states '(normal)
   :keymaps 'dired-mode-map
   "h" 'dired-up-directory
   "l" 'dired-find-file
   "q" 'kill-this-buffer
   )

  (general-define-key
   :states '(insert normal motion visual)
   "C-p" 'yank-from-kill-ring)

  :diminish visual-line-mode
  :ensure nil)

(use-package transient
  :ensure
  t)

(use-package magit
  :after
  transient
  :general
  (rune/leader-keys
    "m" 'magit)
  :ensure t)

(use-package magit-todos
  :hook
  (elpaca-after-init . magit-todos-mode)
  :after magit
  :ensure t)

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode)
  :ensure t)

(use-package pdf-tools
  :init
  (pdf-loader-install)
  (add-hook 'pdf-view-mode-hook
            #'(lambda () (display-line-numbers-mode -1)))
  (add-hook 'pdf-view-mode-hook 'pdf-view-midnight-minor-mode)
  (add-hook 'pdf-mode-hook
            #'(lambda () (interactive) (display-line-numbers-mode -1)))
  :ensure t)

(use-package eglot
  :bind
  ("M-RET" . eglot-code-actions)
  ("M-r" . eglot-rename)
  :custom
  (gc-cons-threshold 100000000)
  (read-process-output-max (* 1024 1024)) ;; 1mb
  (eglot-autoshutdown t) ; shutdown after closing the last managed buffer
  (eglot-sync-connect 0) ; async, do not block, useful for when nix is actively installing lsp server
  (flymake-show-diagnostics-at-end-of-line 1)
  :config
  (setq-default eglot-workspace-configuration
                '((:gopls .
                          (
                           (staticcheck . t)
                           (completeUnimported          . t)
                           (usePlaceholders             . t)
                           (expandWorkspaceToModule     . t)
                           ))
                  (:yaml .
       (:format
  (:enable t
     :singleQuote nil
     :bracketSpacing t
     :proseWrap "preserve"
     :printWidth 80)
        :validate t
        :hover t
        :completion t
  :schemas
  (https://raw.githubusercontent.com/chainguard-dev/melange/refs/heads/main/pkg/config/schema.json
   ["/*.yaml"]
                              https://json.schemastore.org/yamllint.json
                              ["/*.yaml"])
  :schemaStore (:enable t)
        :maxItemsComputed 5000))))
  :hook
  (prog-mode . eglot-ensure)
  (yaml-mode . eglot-ensure)
  (before-save . eglot-format-buffer)
  (eglot-managed-mode . (lambda ()
                          (setq-local completion-at-point-functions
                                      (list (cape-capf-super
                                             #'eglot-completion-at-point
                                             #'yasnippet-capf)))))
  :ensure nil)

(use-package whitespace
  :init
  (global-whitespace-mode)
  :custom
  (whitespace-display-mappings
   '(
     (tab-mark ?\t [62 62])
     (space-mark 32 [183] [46])
     (space-mark 160 [164] [95])
     (newline-mark 10 [36 10])
     )
   )
  (whitespace-style
   '(
     empty
     face
     newline
     newline-mark
     space-mark
     spaces
     tab-mark
     tabs
     trailing
     )
   )
  :hook (before-save . whitespace-cleanup)
  :diminish whitespace-mode
  :ensure nil)

(use-package ligature
  :config
  (ligature-set-ligatures 'prog-mode '("-->" "->" "->>" "-<" "--<"
                                       "-~" "]#" ".-" "!=" "!=="
                                       "#(" "#{" "#[" "#_" "#_("
                                       "/=" "/==" "|||" "||" ; "|"
                                       "==" "===" "==>" "=>" "=>>"
                                       "=<<" "=/" ">-" ">->" ">="
                                       ">=>" "<-" "<--" "<->" "<-<"
                                       "<!--" "<|" "<||" "<|||" "|>"
                                       "<|>" "<=" "<==" "<==>" "<=>"
                                       "<=<" "<<-" "<<=" "<~" "<~>"
                                       "<~~" "~-" "~@" "~=" "~>"
                                       "~~" "~~>" ".=" "..=" "---"
                                       "{|" "[|" ".."  "..."  "..<"
                                       ".?"  "::" ":::" "::=" ":="
                                       ":>" ":<" ";;" "!!"  "!!."
                                       "!!!"  "?."  "?:" "??"  "?="
                                       "**" "***" "*>" "*/" "#:"
                                       "#!"  "#?"  "##" "###" "####"
                                       "#=" "/*" "/>" "//" "///"
                                       "&&" "|}" "|]" "$>" "++"
                                       "+++" "+>" "=:=" "=!=" ">:"
                                       ">>" ">>>" "<:" "<*" "<*>"
                                       "<$" "<$>" "<+" "<+>" "<>"
                                       "<<" "<<<" "</" "</>" "^="
                                       "%%" "'''" "\"\"\"" ))
  (ligature-set-ligatures 'org-mode '("=>"))
  (global-ligature-mode t)
  :ensure t)

(use-package dap-mode
  :hook
  (elpaca-after-init . dap-ui-mode)
  :init
  (require 'dap-dlv-go)
  (add-hook 'dap-stopped-hook
            (lambda (arg) (call-interactively #'dap-hydra)))
  :ensure t)

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode)
  :ensure t)

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-prefix 1)
  (corfu-auto-delay 0.2)
  (corfu-popupinfo-delay '(0.4 . 0.2))
  (corfu-echo-documentation t)
  ;; https://github.com/minad/corfu/issues/108
  (corfu-on-exact-match nil)
  :init (global-corfu-mode)
  :hook (global-corfu-mode . corfu-popupinfo-mode)
  :diminish corfu-mode
  :ensure t)

(use-package marginalia
  :config
  (marginalia-mode 1)
  :ensure t)

(use-package cape
  :init
  (setq cape-dict-file "~/config/emacs/dictionary.dic")
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  :ensure t)

(use-package yasnippet-capf
  :after
  cape
  :ensure t)

(use-package yasnippet
  :init
  (yas-global-mode 1)
  (yas-minor-mode-on)
  :bind
  ("M-s" . yas-insert-snippet)
  :custom
  (yas-snippet-dirs '("~/config/emacs/snippets"))
  :diminish yas-minor-mode
  :ensure t)

(use-package orderless
  :custom
  (completion-styles '(flex orderless basic))
  (completion-category-overrides
   '((file (styles basic partial-completion))))
  :ensure t)

(use-package jinx
  :init
  (global-jinx-mode)
  :general
  (general-define-key
   "C-;" 'jinx-correct-nearest)
  :diminish jinx-mode
  :ensure t)

(use-package mw-thesaurus
  :bind
  ("C-'" . mw-thesaurus-lookup-dwim)
  :ensure t)

(use-package docker
  :general
  (rune/leader-keys
    "d" 'docker)
  :ensure t)

;; Modes not in treesit-auto
(use-package nix-ts-mode
  :mode
  "\\.nix\\'"
  :ensure t)

(use-package auctex
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-master nil)
  ;; to use pdfview with auctex
  (TeX-view-program-selection '((output-pdf "pdf-tools"))
                              TeX-source-correlate-start-server t)
  (TeX-view-program-list '(("pdf-tools" "TeX-pdf-tools-sync-view")))
  (TeX-after-compilation-finished-functions
   #'TeX-revert-document-buffer)
  :hook
  (LaTeX-mode . (lambda ()
                  (setq TeX-PDF-mode t)
                  (setq TeX-source-correlate-method 'synctex)
                  (setq TeX-source-correlate-start-server t)))
  :ensure t)

(use-package envrc
  :hook
  (elpaca-after-init . envrc-global-mode)
  :ensure t)

(use-package eat
  :ensure t)

(use-package disproject
  :general
  (rune/leader-keys
    "p" 'disproject-dispatch)
  :ensure t)

(elpaca-wait)
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "RET") nil)
  (define-key evil-motion-state-map (kbd "TAB") nil))
