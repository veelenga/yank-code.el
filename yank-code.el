(cl-defun yank-code--region(&key
                            (beg (and (use-region-p) (region-beginning)))
                            (end (and (use-region-p) (region-end))))
  "Return code in current region."
  (buffer-substring-no-properties beg end))

(cl-defun yank-code--indent-level(line)
  "Return line indentation level."
  (- (length line)
     (length (string-trim-left line))))

(cl-defun yank-code--autoindent(lines indent)
  "Autoindent lines using indentation level"
  (mapcar
   (lambda (line)
     (if (string-blank-p line)
         line
       (substring line indent (length line))))
   lines))

(cl-defun yank-code--format(code)
  "Formats code to be yanked."
  (let* ((lines (split-string code "\n"))
         (not-blank-lines (seq-remove #'string-blank-p lines))
         (indent (seq-min
                  (mapcar 'yank-code--indent-level not-blank-lines))))
    (string-join (yank-code--autoindent lines indent) "\n")))

(defun yank-code()
  "Yank pre-formatted code."
  (interactive)
  (kill-new (yank-code--format (yank-code--region))))
