(defvar myenv-path-list nil
  "The paths in this list are added to environment variables")

(defun myenv--remove-dups (coll)
  (remove-duplicates coll :test 'equal :from-end t))

(defun myenv--update-path-string ()
  (mylet [coll (append myenv-path-list
		       (s-split ":" (getenv "PATH")))
	       coll (myenv--remove-dups coll)]
	 (s-join ":" coll)))

(defun myenv--update-path ()
  (setenv "PATH" (myenv--update-path-string)))

(setq myenv-result (generate-new-buffer "*myenv*"))

(defun myenv-view-path()
  (interactive)
  (mylet [coll (->> (getenv "PATH")
		    (s-split ":"))]
	 (with-current-buffer myenv-result
	   (save-excursion
	     (erase-buffer)
	     (loop for s in coll
		   do
		   (insert-text-button
		    (concat s "\n")
		    'action
		    (lexical-let((s s))
		      (-lambda (_)
			(find-file-other-window s)))))))
	 (switch-to-buffer-other-window myenv-result)))

(provide 'myenv)
