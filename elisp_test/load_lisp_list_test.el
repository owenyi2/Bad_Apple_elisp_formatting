(require 'cl-lib)

(defun read-list-from-file-line-by-line (file line)
  "read LINE of FILE containing lisp list strings delimited by lines"
  (with-temp-buffer
    (insert-file-contents file)
    

    )
  )


(defun main ()
  (setq folder_path "/Users/owenyi/Desktop/Code Projects/Python/Bad_Apple/Autoformatter/")
  (setq bad_apple_frame_list (read-list-from-file (concat folder_path "lisp_list.txt")))

  (setq frame_number 0)
  
  )
