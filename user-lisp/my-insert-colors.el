;;; my-insert-colors.el --- Custom color insertion utility -*- lexical-binding: t; -*-
(require 'cl-lib)

(defun my-parse-and-convert-color (input format)
  "Parse raw INPUT string and format it according to FORMAT."
  (let* ((clean (string-trim input))
         (parts (split-string clean "[ ,()]+"))
         (hex-regex "^#?\\([0-9a-fA-F]\\{3\\}\\|[0-9a-fA-F]\\{6\\}\\)$")
         (matched-color (member clean (defined-colors))))
    
    (cond
     ;; Case 1: Exact match in defined-colors
     (matched-color
      (let ((rgb (color-name-to-rgb clean)))
        (if rgb
            (my-format-rgb-list rgb format)
          (error "Could not resolve color name"))))
     
     ;; Case 2: Process raw hex input
     ((string-match hex-regex clean)
      (let* ((hex (replace-regexp-in-string "^#" "" clean))
             ;; Expand 3-digit hex (e.g. "f00") to 6-digit (e.g. "ff0000")
             (full-hex (if (= (length hex) 3)
                           (let ((r (substring hex 0 1))
                                 (g (substring hex 1 2))
                                 (b (substring hex 2 3)))
                             (concat r r g g b b))
                         hex))
             (rgb (color-name-to-rgb (concat "#" full-hex))))
        (if rgb
            (my-format-rgb-list rgb format)
          (error "Invalid hex color"))))
     
     ;; Case 3: Process raw comma/space separated values
     ((>= (length parts) 3)
      (let* ((v1 (floor (string-to-number (nth 0 parts))))
             (v2 (floor (string-to-number (nth 1 parts))))
             (v3 (floor (string-to-number (nth 2 parts)))))
        (pcase format
          ("hex"  (format "#%02x%02x%02x" v1 v2 v3))
          ("rgb"  (format "rgb(%d, %d, %d)" v1 v2 v3))
          ("hsl"  (if (string-match-p "hsl" clean)
                      (format "hsl(%d, %d%%, %d%%)" v1 v2 v3)
                    (let ((hsl (color-rgb-to-hsl (/ v1 255.0) (/ v2 255.0) (/ v3 255.0))))
                      (format "hsl(%d, %d%%, %d%%)" 
                              (round (* (nth 0 hsl) 360))
                              (round (* (nth 1 hsl) 100))
                              (round (* (nth 2 hsl) 100))))))
          ("cmyk" (let ((rgb (color-name-to-rgb (format "#%02x%02x%02x" v1 v2 v3))))
                    (my-format-rgb-list rgb format))))))
     (t (error "Invalid color format or name")))))

(defun my-format-rgb-list (rgb-list format)
  "Convert a normalized RGB list (r g b) from 0.0-1.0 to the target FORMAT."
  (let ((r (round (* (nth 0 rgb-list) 255)))
        (g (round (* (nth 1 rgb-list) 255)))
        (b (round (* (nth 2 rgb-list) 255))))
    (pcase format
      ("hex"  (format "#%02x%02x%02x" r g b))
      ("rgb"  (format "rgb(%d, %d, %d)" r g b))
      ("hsl"  (let ((hsl (color-rgb-to-hsl (nth 0 rgb-list) (nth 1 rgb-list) (nth 2 rgb-list))))
                (format "hsl(%d, %d%%, %d%%)" 
                        (round (* (nth 0 hsl) 360))
                        (round (* (nth 1 hsl) 100))
                        (round (* (nth 2 hsl) 100)))))
      ("cmyk" (let* ((r-norm (nth 0 rgb-list))
                     (g-norm (nth 1 rgb-list))
                     (b-norm (nth 2 rgb-list))
                     (k (- 1 (max r-norm g-norm b-norm)))
                     (c (if (= k 1) 0 (/ (- 1 r-norm k) (- 1 k))))
                     (m (if (= k 1) 0 (/ (- 1 g-norm k) (- 1 k))))
                     (y (if (= k 1) 0 (/ (- 1 b-norm k) (- 1 k)))))
                (format "cmyk(%d%%, %d%%, %d%%, %d%%)"
                        (round (* c 100)) (round (* m 100)) 
                        (round (* y 100)) (round (* k 100))))))))

(defun insert-color ()
  "Prompts for a format, then a color name or raw value, and inserts it."
  (interactive)
  (let* ((formats '("hex" "rgb" "hsl" "cmyk"))
         (chosen-format (completing-read "Select output format: " formats nil t))
         (color-choices (defined-colors))
         (chosen-color (completing-read "Select color (or type raw values): " color-choices)))
    (if (string-empty-p chosen-color)
        (user-error "No color provided")
      (insert (my-parse-and-convert-color chosen-color chosen-format)))))

;;;###autoload
(provide 'my-insert-colors)
;;; my-color-insert.el ends here
