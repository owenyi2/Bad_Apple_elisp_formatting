(require 'cl-lib)

(defun pad-list-to-length (list length)
  "given LIST pad 0's to right until correct LENGTH."
  (append list (make-list (max 0 (- length (length list))) 0))
  )

(defun wrap-line (row text_list word_count)
  "given a 1D list ROW of 1's and 0's denoting the black white pixels in a particular row of a particular frame, and a 1D list TEXT_LIST of strings to use as words to render the frame, and an index WORD_COUNT denoting the words in TEXT_LIST used, produce a string of words from TEXT_LIST starting from WORD_COUNT to render ROW"
  (setq pixel_count 0)
  (setq wrapped_line "")

  (while (< pixel_count (length row))
    (setq word (concat (nth word_count text_list) " "))
    (setq word_len (length word))

    "; grab the next WORD_LEN pixels from ROW so to determine if there's enough white pixel to add the next WORD"
    (setq look_ahead (pad-list-to-length (cl-subseq row pixel_count (min (length row) (+ pixel_count word_len))) word_len)) 

    (if (> (/(apply '+ look_ahead) (length look_ahead)) .55)
    (progn
      (setq wrapped_line (concat wrapped_line word)) "; add WORD"
      (setq word_count (1+ word_count))
      (setq pixel_count (+ pixel_count word_len))
      )
    (setq wrapped_line (concat wrapped_line " ")) "; add ' '"
    (setq pixel_count (1+ pixel_count))
    )

    
    )
  "; need to pass on WORD_COUNT for next call of WRAP-LINE for the next ROW to keep track of position within TEXT_LIST"
  (list wrapped_line word_count)

  )


(defun create_wrapped_text (frame text_list)
  "call wrap-line a for each row in FRAME until we render entire FRAME with TEXT_LIST"
  (setq word_count 0)
  (setq full_wrapped_text "")
  (setq height (length frame))

  (setq i 0)

  (while (< i height)
    (setq row (nth i frame))
    (setq wrap-line-output (wrap-line row text_list word_count))

    (setq wrapped_line (nth 0 wrap-line-output))
    (setq word_count (nth 1 wrap-line-output))

    (setq full_wrapped_text (concat full_wrapped_text wrapped_line "\n"))
    
    (setq i (1+ i))
    )

  "; if we haven't used up all of TEXT_LIST shove the excess at the end"
  (if (< word_count (length text_list))
      (setq full_wrapped_text (concat full_wrapped_text "\n" (mapconcat 'identity (cl-subseq text_list word_count (length text_list)) " ")))
     
      )
  
  full_wrapped_text
  )

(defun lisp--match-hidden-arg (limit) nil) "; suppress the red syntax highlighting produced by LISP--MATCH-HIDDEN-ARG flagging our crime-against-humanity of a lisp formatter"

(defun main ()
  (setq frame_number 0)
  (setq code_buffer (buffer-name))

  (switch-to-buffer code_buffer)
  (setq text_list (split-string (buffer-substring-no-properties (point-min) (point-max))))
  
  (switch-to-buffer "*scratch*")
  (text-scale-set -3)

  (switch-to-buffer "*temporary*") "; use *temporary* to house the ./lisp_list.txt"
  (buffer-disable-undo) "; avoid Warning (undo). we're not going to undo this buffer anyway so this is fine"
  (erase-buffer)
  (insert-file-contents "./lisp_list.txt") ";(change directory to where this file is first in emacs with M-x cd)"
  (goto-char (point-min))

  (print "BAD APPLE ON EMACS!!")

  (while (not (eobp)) "; while not eobp in *temporary*"
    (setq frame_start_time (float-time)) "; need to time how long rendering takes in order to adjust sleep time"
	 
    (setq line_string (thing-at-point 'line))
    (setq line_string_stripped (cl-subseq line_string 0 (- (length line_string) 1)))
    (setq bad_apple_frame (eval (car (read-from-string line_string_stripped)))) 

    (setq wrapped_text (create_wrapped_text bad_apple_frame text_list))

    (print frame_number)
    (switch-to-buffer "*scratch*")
    (goto-char (point-min))

    (erase-buffer)
    (insert wrapped_text)
    (goto-char (point-min))

    (setq frame_number (1+ frame_number))
    
    (setq frame_time (- (float-time) frame_start_time))
    (sit-for (max 0 (- (/ 1 29.97) frame_time)))
    
    (switch-to-buffer "*temporary*")
    "; iterate line-by-line in *temporary* to flip through each bad apple frame"
    (forward-line 1) 

      
    )
  (switch-to-buffer code_buffer)
  )

"; my code is so delicate that even a touch sends the code into a freeze so I need to wrap it in a while-no-input for safety"
(while-no-input (main)) "; <- ENTRY POINT: move cursor here and M-x eval-buffer"


";; Note that comments are encapsulated in quotes to allow breaking across lines"
";; Our script is too short to cover the entire frame so I'm going to go spam the above function defintions below"


