;;; browse-rules.el --- Writing different rules for browsing various urls

;; Copyright (C) 2020 Sidharth Arya

;; Author: Sidharth Arya <sidhartharya10@gmail.com>
;; Maintainer: Sidharth Arya <sidhartharya10@gmail.com>
;; Created: 28 May 2020
;; Version: 0.1
;; Package-Requires: ((emacs "24.3"))
;; Keywords: browser
;; URL: https://github.com/SidharthArya/browse-rules.el

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or (at
;; your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
;; USA.

;;; Commentary:

;; browse-rules.el package lets you define rules to browse urls based on regexp

;;; Code:
(require 'browse-url)
(defcustom browse-rules '((".*" nil browse-url-default-browser "%s"))
  "A set of rules to browse various urls.
Each rule is a list of 4 elements.
\('URL Regexp' 'External' 'Function/Program with arguments' 'Format String')
URL Regexp - First element contains the regular expression based on which the
browser is selected.
External - Should an external program be used to browse the url or not.
Function/Program With arguments - If External was t, you can specify the program
with the arguments you want to add here.
If External was nil you can specify a function which should take as argument the
url.
Format String - Last element is the format string which would transform the url
into something else"
  :group 'browse-rules
  :type 'list)

(defun browse-rules-url (url &optional _new-window)
    "Based on the rules defined in `browse-rules' browse a particular URL."
    (interactive (browse-url-interactive-arg "URL: "))
    (let ((browse-pattern  nil))
    (dolist (pattern browse-rules)
      (if (string-match-p (car pattern) url)
	  (setq browse-pattern pattern)))
    (if (nth 1 browse-pattern)
	(apply 'call-process (nth 2 browse-pattern) nil 0 nil (append (split-string (format (nth 3 browse-pattern) url))))
      (apply (nth 2 browse-pattern) (list (format (nth 3 browse-pattern) url))))))

(provide 'browse-rules)

;;; browse-rules.el ends here
