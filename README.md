# ssh-ident.el

This package provides a simple filter for an ssh-ident process so that the
Emacs user can enter the respective SSH keys passphrases.

Provides integration with Magit via a hook for when Magit needs credentials.
The hook will be automatically added when you load this package.

## Installation

### Manual install

Clone the repository somewhere in your machine, add its location to the Emacs
path and require it:

```lisp
(add-to-list 'load-path "/path/to/emacs-ssh-ident/")
(require 'ssh-ident)
```

### With [straight.el](https://github.com/raxod502/straight.el) and [use-package](https://github.com/jwiegley/use-package):

```lisp
(use-package ssh-ident
  :straight (:host github :repo "arthurcgusmao/emacs-ssh-ident"))
```

