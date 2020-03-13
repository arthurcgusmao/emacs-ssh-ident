# ssh-ident.el

This package provides a simple filter for an ssh-ident process so that the
Emacs user can enter the respective SSH keys passphrases.

Provides integration with Magit via a hook for when Magit needs credentials.
The hook will be automatically added when you load this package.

## Installation

### Disclaimer

For ssh and related commands (such as Git, used by Magit) to work with ssh-ident inside Emacs, the ssh command that Emacs runs should be pointing to an instance of ssh-ident. For instance, you can create a symlink from ssh to ssh-ident in `~/.local/bin`, and then add that path to the Emacs environment PATH variable:

```console
ln -s /path/to/ssh-ident ~/.local/bin/ssh
```

```lisp
(defun add-to-env-path (path)
  "Add PATH (first position) to the PATH environment variable"
  (setenv "PATH" (concat (expand-file-name path)
                         path-separator (getenv "PATH"))))

(add-to-env-path "~/.local/bin")
```

### Manual install

Clone the repository somewhere in your machine, add its location to the Emacs
path and require it:

```lisp
(add-to-list 'load-path "/path/to/emacs-ssh-ident/")
(require 'ssh-ident)
```

### Install with [straight.el](https://github.com/raxod502/straight.el) and [use-package](https://github.com/jwiegley/use-package):

```lisp
(use-package ssh-ident
  :straight (:host github :repo "arthurcgusmao/emacs-ssh-ident"))
```
