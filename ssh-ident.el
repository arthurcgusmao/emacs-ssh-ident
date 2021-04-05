;;; ssh-ident.el --- Filter to interface with ssh-ident for Emacs -*- lexical-binding: t -*-

;; Copyright (C) 2020  Arthur Colombini Gusmao

;; Author: Arthur Colombini Gusmao
;; Maintainer: Arthur Colombini Gusmao

;; URL: https://github.com/arthurcgusmao/emacs-ssh-ident
;; Version: 0.1

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides a simple filter for an ssh-ident process so that the
;; Emacs user can enter the respective SSH keys passphrases.

;;; Code:

(defun ssh-ident-askpass-filter (proc string)
  "Filter for processing `ssh-ident' output.

Adapted from Magit's SSH Agency package
(https://github.com/magit/ssh-agency)"
  (condition-case ()
      (with-current-buffer (process-buffer proc)
        (goto-char (point-max))
        (insert string)                 ; Record all output.
        (when (string-match-p "Enter passphrase for .*: *\\'" string)
          (let ((pwd (read-passwd string)))
            (send-string proc pwd)
            (clear-string pwd)
            (send-string proc "\n"))))
    (quit (kill-process proc)
          (process-put proc :user-quit t))))

(defun ssh-ident-grab-passphrase ()
  "Trigger an `ssh-ident' process to grab the appropriate SSH
keys' passphrases by trying to fetch all repositories in the
current git repo.

Ideally we would wrap the actual Magit command that the user
performed and apply the ssh-ident filter there, but since I did
not want to spent too much time trying to figure that out I used
this dirty hack. (Please push improvements if you know it!)"
  (with-temp-buffer
    (let ((exit-status
           (let* ((process-connection-type t) ; pty needed for filter.
                  (proc (apply #'start-process "git-fetch-process"
                               (current-buffer) "git" '("fetch" "--all"))))
             (setf (process-filter proc) #'ssh-ident-askpass-filter)
             (while (eq (process-status proc) 'run)
               (accept-process-output proc))
             (if (process-get proc :user-quit)
                 0 ; Quitting is not an error.
               (process-exit-status proc)))))
      (unless (eq 0 exit-status)
        (lwarn 'ssh-ident :error
               "Process started by `ssh-ident-enter-passphrase'
               failed with status %d: %s" exit-status (buffer-string))))))

;;;###autoload
(add-hook 'magit-credential-hook 'ssh-ident-grab-passphrase)

(provide 'ssh-ident)
