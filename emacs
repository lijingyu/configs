(setq inhibit-startup-message t)

(add-to-list 'load-path "~/.emacs.d/color-theme")
(add-to-list 'load-path "~/.emacs.d")
(require 'color-theme)
(color-theme-initialize)
(load-file "~/.emacs.d/color-theme/themes/monokai-theme.el")
(color-theme-monokai)

(require 'setnu)
(setnu-mode t)
(show-paren-mode t)
(set-default-font "-microsoft-Consolas-normal-normal-normal-*-19-*-*-*-m-0-iso10646-1")

(require 'xcscope)
