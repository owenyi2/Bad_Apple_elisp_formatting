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

(defun pad-list-to-length (list length)
  "given LIST pad 0's to right until correct LENGTH."
  (append list (make-list (max 0 (- length (length list))) 0))
  )

(defun wrap-line (row text_list word_count)
  (setq pixel_count 0)
  (setq wrapped_line "")

  (while (< pixel_count (length row))
    (setq word (concat (nth word_count text_list) " "))
    (setq word_len (length word))
    
    (setq look_ahead (pad-list-to-length (cl-subseq row pixel_count (min (length row) (+ pixel_count word_len))) word_len))
    
    (setq word_reduced (mapcar (lambda (x) 1) (split-string word "" t)))

    (if (> (/(apply '+ look_ahead) (length look_ahead)) .55)
    (progn
      (setq wrapped_line (concat wrapped_line word))
      (setq word_count (1+ word_count))
      (setq pixel_count (+ pixel_count word_len))
      )
    (setq wrapped_line (concat wrapped_line " "))
    (setq pixel_count (1+ pixel_count))
    )

    
    )

  (list wrapped_line word_count)
  )


(defun create_wrapped_text (frame text_list)
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

  (if (< word_count (length text_list))
      (setq full_wrapped_text (concat full_wrapped_text "\n" (mapconcat 'identity (cl-subseq text_list word_count (length text_list)) " ")))
      
    
     
      )
  
  full_wrapped_text
  )

(defun main ()
  (setq folder_path "/Users/owenyi/Desktop/Code Projects/Python/Bad_Apple/Autoformatter/")
  (setq bad_apple_frame_list (read-list-from-file (concat folder_path "lisp_list.txt")))

  (setq text_list (split-string (buffer-substring-no-properties (point-min) (point-max))))

  (setq frame_number 0)
  
  (global-font-lock-mode 0)
  
  (dolist (bad_apple_frame bad_apple_frame_list)
   
    (setq wrapped_text (create_wrapped_text bad_apple_frame text_list))
    
    (print frame_number)

    (switch-to-buffer "*scratch*")
    (goto-char (point-min))

    (text-scale-set 1)
    (text-scale-decrease 7)
    (erase-buffer) 
    (insert wrapped_text)
    (goto-char (point-min))

    (setq frame_number (1+ frame_number))
    (sit-for (/ 1 29.97))
    
    )

  (switch-to-buffer (other-buffer))
  )

;; and here is the entry point

(main)

"
When a program creates a list or the user defines a new function (such as by loading a library), that data is placed in normal storage. If normal storage runs low, then Emacs asks the operating system to allocate more memory. Different types of Lisp objects, such as symbols, cons cells, small vectors, markers, etc., are segregated in distinct blocks in memory. (Large vectors, long strings, buffers and certain other editing types, which are fairly large, are allocated in individual blocks, one per object; small strings are packed into blocks of 8k bytes, and small vectors are packed into blocks of 4k bytes).

Beyond the basic vector, a lot of objects like markers, overlays and buffers are managed as if they were vectors. The corresponding C data structures include the union vectorlike_header field whose size member contains the sub

type enumerated by enum pvec_type and an information about how many Lisp_Object fields this structure contains and what the size of the rest data is. This information is needed to calculate the memory footprint of an object, and used by the vector allocation code while iterating over the vector blocks.

It is quite common to use some storage for a while, then release it by (for example) killing a buffer or deleting the last pointer to an object. Emacs provides a garbage collector to reclaim this abandoned storage. The garbage collector operates, in essence, by finding and marking all Lisp objects that are still accessible to Lisp programs. To begin with, it assumes all the symbols, their values and associated function definitions, and any data presently on the stack, are accessible. Any objects that can be reached indirectly through other accessible objects are also accessible, but this calculation is done “conservatively”, so it may slightly overestimate how many objects that are accessible.

When marking is finished, all objects still unmarked are garbage. No matter what the Lisp program or the user does, it is impossible to refer to them, since there is no longer a way to reach them. Their space might as well be reused, since no one will miss them. The second (sweep) phase of the garbage collector arranges to reuse them. (But since the marking was done “conservatively”, not all unused objects are guaranteed to be garbage-collected by any one sweep.)

The sweep phase puts unused cons cells onto a free list for future allocation; likewise for symbols and markers. It compacts the accessible strings so they occupy fewer 8k blocks; then it frees the other 8k blocks. Unreachable vectors from vector blocks are coalesced to create largest possible free areas; if a free area spans a complete 4k block, that block is freed. Otherwise, the free area is recorded in a free list array, where each entry corresponds to a free list of areas of the same size. Large vectors, buffers, and other large objects are allocated and freed individually.

 Pellentesque elementum lacinia sollicitudin. Ut interdum tortor id nisi lacinia, quis gravida augue malesuada. Cras fermentum condimentum ultricies. Curabitur interdum cursus facilisis. Curabitur porttitor id nisl id condimentum. In quis diam eu lorem blandit pretium in ut augue. Sed nunc metus, vulputate ac neque quis, vestibulum rhoncus sem. Duis et magna scelerisque, facilisis erat ac, cursus nibh. Duis dignissim ullamcorper tellus, sit amet aliquet urna lacinia ac. Quisque nisi massa, gravida sit amet libero nec, iaculis elementum justo. Nullam blandit eget justo vitae blandit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. In mi ante, tincidunt eu ipsum quis, posuere fermentum nisi. Pellentesque nibh erat, vulputate vel tortor nec, cursus blandit lacus.

Nulla ac gravida augue. Aenean ut libero sit amet mi suscipit vestibulum. Cras eu facilisis massa. Morbi nisl nisi, ultricies a condimentum ac, luctus non nisi. Aliquam facilisis aliquet nunc. Nullam quis ante sed turpis elementum commodo. Praesent egestas pellentesque dictum. Sed vel dolor ut ante commodo tempus a tempor dolor.

Quisque sit amet nunc vitae mi viverra ullamcorper vitae at tellus. Sed gravida sem vel fermentum mattis. Suspendisse nec ligula ut lectus porta tempor. Proin vel nisl lobortis, eleifend diam a, bibendum velit. Maecenas sollicitudin pulvinar neque, vitae fringilla massa. Phasellus iaculis lacus nibh, nec tincidunt sem lobortis a. Ut dapibus, nisl eget consectetur varius, mauris lacus posuere leo, a maximus enim magna sit amet dolor. Donec ornare suscipit pharetra. Nam blandit bibendum massa, a eleifend tortor aliquet in. Nam in mi sed mauris accumsan luctus ut ac ante. Vivamus iaculis leo et nunc tristique, quis vehicula est congue. Aliquam quis cursus erat, vel lobortis risus. Donec felis dui, cursus eget posuere quis, tempus scelerisque sem. Vivamus rhoncus sagittis eros et commodo. Phasellus odio ante, ultrices sit amet ornare eget, ultricies a justo.

Nam placerat urna id eros placerat, ac hendrerit magna pellentesque. Ut vitae nulla in justo dictum mollis efficitur et diam. Sed ac faucibus nulla. Donec id leo non augue pharetra placerat. Quisque lectus ex, tempus iaculis leo quis, malesuada luctus quam. Nulla facilisi. Mauris viverra augue ac turpis fermentum volutpat. Nulla varius euismod felis, dignissim consequat justo tincidunt sed. Sed pretium porta venenatis. Mauris in fermentum felis. Morbi pellentesque turpis quis tellus interdum lacinia.

Quisque in sagittis nulla, faucibus tempor tortor. Mauris gravida nunc nec interdum dapibus. Cras tempor est vel velit accumsan cursus. Mauris non tellus nec neque pharetra maximus sed nec ipsum. Suspendisse potenti. Etiam sed dignissim orci, eu finibus libero. Suspendisse a feugiat nunc. 
"
