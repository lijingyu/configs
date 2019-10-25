
;;put next two line in ~/.emacs.el
;;(set-frame-font "-MS  -Consolas-normal-normal-normal-*-23-*-*-*-m-0-iso10646-1" t t)
;;(load-file "~/bin/emacs.d/init.el")

(add-to-list 'load-path "~/bin/emacs.d/lisp")
(setq inhibit-startup-message t)
(setq  initial-scratch-message nil)

(set-background-color "#002b36")
(set-foreground-color "#b3b3b3")

(show-paren-mode t)
(setq dired-recursive-deletes 'always)

(require 'xcscope)
(require 'sr-speedbar)
(require 'gtags)

(setq c-default-style "linux"
      c-basic-offset 4
      tab-width 4
      indent-tabs-mode nil)

(setq c-mode-hook
      '(lambda ()
	 (gtags-mode 1)
	 ))
(setq gtags-mode-hook
      '(lambda ()
	 (setq gtags-path-style 'relative)))

(add-to-list 'load-path "~/bin/emacs.d/lisp/elpa/company-0.9.3")
(load-file "~/bin/emacs.d/lisp/elpa/company-0.9.3/company.el")
(autoload 'company-mode "company" nil t)
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-hook 'after-init-hook 'global-company-mode)
(global-set-key (kbd "\t") 'company-complete)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-auto-complete t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-hook 'gtags-mode-hook
	  '(lambda ()
	     (define-key gtags-mode-map "\C-t" 'gtags-pop-stack)
	     (define-key gtags-mode-map "\M-s" 'gtags-find-with-grep)
	     (define-key gtags-mode-map "\M-]" 'gtags-find-tag)
	     (define-key gtags-mode-map "\M-[" 'gtags-find-rtag)
	     (define-key gtags-mode-map "\M-\\" 'gtags-find-symbol)
	     (define-key gtags-mode-map "\M-/" 'gtags-find-pattern)
	     (define-key gtags-mode-map "\M-f" 'gtags-find-file)
	     ))
