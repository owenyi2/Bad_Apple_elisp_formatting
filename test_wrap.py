import numpy as np

bad_apple_frames = eval(open("temp1.txt", "r").read()) # really shitty way of writing and reading python lists but whatever i'm going to write it in lisp anyway
lorem_ipsum_text = open("lorem_ipsum.txt").read().split()




# let's try to configure 1 row of 1 frame for now
word_count = 0 

full_text = ""
for i in range(108):
    pixel_count = 0


    current_frame = bad_apple_frames[i]

    wrapped_text = ""

    while pixel_count < len(current_frame): 
        next_word = lorem_ipsum_text[word_count] + " "
        next_pixel = current_frame[pixel_count]

        print(f"pixel_count: {pixel_count} | next_pixel: {next_pixel} | word_count: {word_count} | next_word: {next_word}")

        if next_pixel == 0:
            wrapped_text += " "
            pixel_count += 1
        else:
            word_len = len(next_word)
            look_ahead = current_frame[pixel_count:pixel_count+word_len]

            word_reduced = [0 if x == "" else 1 for x in next_word]

            if sum(~np.logical_xor(word_reduced, look_ahead)) / len(look_ahead) > .51: 
                wrapped_text += next_word
                
                word_count += 1
                pixel_count += word_len
            else:
                wrapped_text += " "
                pixel_count += 1

        # input()

    # print(repr(wrapped_text))
    full_text += wrapped_text + "\n"

with open("temp3.txt", "w") as f:
    f.write(full_text)
    