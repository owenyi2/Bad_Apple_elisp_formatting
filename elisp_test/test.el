(require 'cl-lib)

(defun read-file (file)
  "read file by name FILE and return content as string"
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (buffer-string)
    )
  )

(defun read-list-from-file (file)
  "read file by name FILE containing a lisp list string and return evaluated lisp list"
  (eval (car (read-from-string (read-file file))))
  )

(defun percent-similarity (list-a list-b)
  "given two lists of integers LIST-A LIST-B of equal length, calculate how many indexes common"
  (/ (apply '+
	    (mapcar (lambda (x) (if x 1 0)) (cl-mapcar 'equal list-a list-b))
	    )
     (float (length list-a))
  )
  )

(defun pad-list-to-length (list length)
  "given LIST pad 0's to right until correct LENGTH."
  (append list (make-list (max 0 (- length (length list))) 0))
 )

(setq bad_apple_frame (read-list-from-file "../lisp_list.txt"))
(setq lorem_ipsum_text (read-file "../lorem_ipsum.txt"))


(defun wrap-line (row text word_count)
  (setq pixel_count 0)
  (setq wrapped_line "")

  (while (< pixel_count (length row))
    
    )
  )

;; e.g.
(setq row (nth 100 bad_apple_frame)) ;; 100th row in frame
(setq text (split-string lorem_ipsum_text)) ;; split by whitespace


;; e.g.
(setq word (concat (nth word_count text) " "))
(setq word_len (length word))
(setq look_ahead (pad-list-to-length look_ahead word_len))

(mapcar (lambda (x) (if (equal x " ") 0 1)) '("" "a" "b")) ; kinda works but now we need to turn word into list
(split-string "hello" "" t) ; this does the trick

(mapcar (lambda (x) (if (equal x " ") 0 1)) (split-string word "" t)) ; combined

(if (> (percent-similarity word_reduced look_ahead) .6)
    (progn
      (setq wrapped_line (concat wrapped_line word))
      (setq word_count (1+ word_count))
      (setq pixel_count (+ pixel_count word_len))
      )
    (setq wrapped_line (concat wrapped_line " "))
    (setq pixel_count (1+ pixel_count))
    )
