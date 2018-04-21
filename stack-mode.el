;; https://www.emacswiki.org/emacs/ModeTutorial

(setq debug-on-error t)

(defvar stack-mode nil)

(defvar stack-mode-map (define-key (make-keymap) "\C-j" 'newline-and-indent))

(add-to-list 'auto-mode-alist '("\\ stack\\'" . stack-mode))
