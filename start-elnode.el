;;; start-elnode.el
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(package-refresh-contents)
(package-install 'elnode)

(defvar vote-num 0)

(defun handler (httpcon)
  "Demonstration function"
  (elnode-http-start httpcon "200"
                     '("Content-type" . "text/html")
                     `("Server" . ,(concat "GNU Emacs " emacs-version)))
  (elnode-http-return
   httpcon
   (let ((body))
     (when (string= "POST" (elnode-http-method httpcon))
       (setq vote-num (1+ vote-num)))
     (with-temp-buffer
       (find-file "form.html")
       (setq body (buffer-substring-no-properties (point-min) (point-max))))
     (replace-regexp-in-string "{{vote-num}}" (format "%d" vote-num) body))))

(elnode-start 
    'handler 
    :port (string-to-number (or (getenv "PORT") "8080")) 
    :host "0.0.0.0")

(while t (accept-process-output nil 1))
