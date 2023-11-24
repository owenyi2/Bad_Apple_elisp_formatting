(defun read-file (file)
  "read file by name FILE and return content as string"
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (buffer-string)
    )
  )


(let ((x 1))
  (while (< x 519)
    (setq file_name (format "~/Desktop/Code Projects/Python/Bad_Apple/Autoformatter/output/wrapped_output_%d.txt" x))
    (setq x (1+ x))

    (setq file_content (read-file file_name))
    
    ;;;(print (cl-subseq file_content 100 110))

    (switch-to-buffer "*scratch*")
    (goto-char (point-min))

    (text-scale-set 1)
    (text-scale-decrease 7)
    (erase-buffer) 
    (insert file_content)

    (sit-for (/ 1 29.97))
    
    (switch-to-buffer (other-buffer))
    
    ))
