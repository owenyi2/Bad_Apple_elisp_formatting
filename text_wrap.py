import numpy as np

bad_apple_frame = eval(open("python_list.txt", "r").read()) # really shitty way of writing and reading python lists but whatever i'm going to write it in lisp anyway
lorem_ipsum_text = open("lorem_ipsum.txt").read().split()

def create_wrapped_text(frame, text, width):
    word_count = 0
    full_wrapped_text = ""

    for i in range(width):
        pixel_count = 0
        wrapped_line = ""

        row = frame[i]

        while pixel_count < len(row):
            word = text[word_count] + " "
            pixel = row[pixel_count]

        
            word_len = len(word)
            look_ahead = row[pixel_count:pixel_count+word_len]
            look_ahead.extend([0] * (word_len - len(look_ahead))) # pad to avoid possible bug where if we are at the end of the row e.g. [1, 0, 0] but the word is longer e.g. "lisp", then the arrays are no longer the same length and we can't xor them


            word_reduced = [0 if x == "" else 1 for x in word]

            
            if sum(~np.logical_xor(word_reduced, look_ahead)) / len(look_ahead) > .6: 
                wrapped_line += word
                
                word_count += 1
                pixel_count += word_len
            else:
                wrapped_line += " "
                pixel_count += 1

        full_wrapped_text += wrapped_line + "\n"

    return full_wrapped_text

example = create_wrapped_text(bad_apple_frame, lorem_ipsum_text, len(bad_apple_frame))

with open("wrapped_output.txt", "w") as f:
    f.write(example)
    