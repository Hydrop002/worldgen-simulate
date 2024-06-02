from manim import *

class Zoom(Scene):
    def construct(self):
        dim = 10
        size = 0.25
        width = 429
        height = 428
        src = ImageMobject("image/0.png").get_pixel_array()
        anims = []
        for i in range(dim):
            for j in range(dim):
                color = src[int((i + 0.5) * width / dim)][int((j + 0.5) * height / dim)]
                pixel = ImageMobject(np.uint8([[color]]))
                pixel.shift(((j - dim / 2 + 1) * size, (-i + dim / 2 - 1) * size, 0))
                pixel.height = size + 0.01
                pixel.set_resampling_algorithm(RESAMPLING_ALGORITHMS["nearest"])
                self.add(pixel)
                anims.append(pixel.animate.shift(((j - dim / 2) * size, (-i + dim / 2) * size, 0)))
        self.wait(0.5)
        self.play(*anims)
        new_dim = (dim - 1) * 2
        src = ImageMobject("image/0-1.png").get_pixel_array()
        anims = []
        for i in range(new_dim):
            for j in range(new_dim):
                color = src[int((i + 0.5) * width / new_dim)][int((j + 0.5) * height / new_dim)]
                pixel = ImageMobject(np.uint8([[color]]))
                pixel.shift(((j - new_dim / 2) * size, (-i + new_dim / 2) * size, 0))
                pixel.fade(1)
                pixel.height = size + 0.01
                pixel.set_resampling_algorithm(RESAMPLING_ALGORITHMS["nearest"])
                self.add(pixel)
                anims.append(pixel.animate.fade(0.2))
        self.play(*anims)
        self.wait(0.5)
