import cv2
import numpy as np
import matplotlib.pyplot as plt

HORI_RES = 360
ASPECT = 2.5 # Height of Character / Width of Character in terminal

def resize(img, hori_res, character_aspect_ratio):
    new_size = (hori_res, int(hori_res / character_aspect_ratio * img.shape[0] // img.shape[1]))
    return cv2.resize(img, new_size)    

def black_white(img):
    return (~np.round(img / 255).astype(bool)).astype(int)

def to_ascii(img):
    with open("temp.txt", "w") as f:
        write = "\n".join(["".join([" " if x == 0 else '#' for x in row]) for row in img])
        f.write(write)

def to_text(img):
    with open("temp1.txt", "w") as f:
        f.write(str(img.tolist()))

def to_plot(img):
    plt.imshow(img, cmap='Greys')
    plt.show()

img = cv2.imread(f"bad_apple_{291}.png", cv2.IMREAD_GRAYSCALE)
img = resize(img, HORI_RES, ASPECT)
img = black_white(img)

to_ascii(img)
to_text(img)
to_plot(img)