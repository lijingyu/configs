(setq inhibit-startup-message t)

(add-to-list 'load-path "~/.emacs.d/lisp/color-theme")
(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'color-theme)
(color-theme-initialize)
;(load-file "~/.emacs.d/lisp/color-theme/themes/monokai-theme.el")
;(color-theme-monokai)

(show-paren-mode t)
(set-frame-font "-CYRE-Inconsolata-normal-normal-normal-*-16-*-*-*-m-0-iso10646-1" t t)

(require 'xcscope)

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

(add-to-list 'load-path "~/.emacs.d/lisp/elpa/company-0.9.3")
(load-file "~/.emacs.d/lisp/elpa/company-0.9.3/company.el")
(autoload 'company-mode "company" nil t)
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

(require 'helm-config)
(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(helm-mode 1)
