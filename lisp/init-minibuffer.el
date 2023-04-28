;;; init-minibuffer.el --- Config for minibuffer completion       -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:


(when (maybe-require-package 'vertico)
  (add-hook 'after-init-hook 'vertico-mode)

  (when (maybe-require-package 'embark)
    (with-eval-after-load 'vertico
      (define-key vertico-map (kbd "C-c C-o") 'embark-export)
      (define-key vertico-map (kbd "C-c C-c") 'embark-act)))

  (when (maybe-require-package 'consult)
    (defmacro sanityinc/no-consult-preview (&rest cmds)
      `(with-eval-after-load 'consult
         (consult-customize ,@cmds :preview-key "M-P")))

    (sanityinc/no-consult-preview
     consult-ripgrep
     consult-git-grep consult-grep
     consult-bookmark consult-recent-file consult-xref
     consult--source-recent-file consult--source-project-recent-file consult--source-bookmark)

    (when (maybe-require-package 'projectile)
      (setq-default consult-project-root-function 'projectile-project-root))

    (when (and (executable-find "rg") (maybe-require-package 'affe))
      (defun sanityinc/affe-grep-at-point (&optional dir initial)
        (interactive (list prefix-arg (when-let ((s (symbol-at-point)))
                                        (symbol-name s))))
        (affe-grep dir initial))
      (global-set-key (kbd "M-?") 'sanityinc/affe-grep-at-point)
      (sanityinc/no-consult-preview sanityinc/affe-grep-at-point)
      (with-eval-after-load 'affe (sanityinc/no-consult-preview affe-grep)))

    (global-set-key (kbd "C-x C-b") 'consult-buffer)
    (global-set-key (kbd "C-x o") 'consult-outline)
    (global-set-key [remap switch-to-buffer-other-window] 'consult-buffer-other-window)
    (global-set-key (kbd "C-x 4 C-f") 'find-file-other-window)
    (global-set-key (kbd "C-x 4 C-b") 'consult-buffer-other-window)
    (global-set-key [remap switch-to-buffer-other-frame] 'consult-buffer-other-frame)
    (global-set-key [remap goto-line] 'consult-goto-line)
    (global-set-key [remap yank-pop] 'consult-yank-pop)
    (global-set-key (kbd "C-x C-l") 'consult-line)
    (global-set-key (kbd "M-g M-l") 'consult-line)
    (global-set-key (kbd "M-g M-o") 'consult-outline)
    (global-set-key (kbd "C-x f") nil)
    (global-set-key (kbd "C-x f t") 'consult-ripgrep)
    (global-set-key (kbd "C-x f b") 'consult-bookmark)
    (global-set-key (kbd "C-x f a") 'consult-org-agenda)
    (global-set-key (kbd "C-x C-r") 'consult-recent-file)


    (when (maybe-require-package 'embark-consult)
      (with-eval-after-load 'embark
        (require 'embark-consult)
        (add-hook 'embark-collect-mode-hook 'embark-consult-preview-minor-mode)))

    (maybe-require-package 'consult-flycheck)))

(when (maybe-require-package 'marginalia)
  (add-hook 'after-init-hook 'marginalia-mode))


(provide 'init-minibuffer)
;;; init-minibuffer.el ends here
