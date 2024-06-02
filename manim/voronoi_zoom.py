import math
import random
from manim import *

class Voronoi(Animation):
    def __init__(self, polygon: Polygon, i, j, points, **kwargs) -> None:
        super().__init__(polygon,  **kwargs)
        self.i = i
        self.j = j
        self.points = points
        self.dim = 9
        self.size = 0.2

    def interpolate_mobject(self, alpha: float) -> None:
        point, polygon = self.points[self.i, self.j]
        lines = []
        x = point.get_x()
        y = point.get_y()
        for m in range(-2, 3):  # 半平面交
            for n in range(-2, 3):
                if m == 0 and n == 0:
                    continue
                if 0 <= self.i + m < self.dim and 0 <= self.j + n < self.dim:
                    nx = self.points[self.i + m, self.j + n][0].get_x()
                    ny = self.points[self.i + m, self.j + n][0].get_y()
                else:
                    nx = (self.j + n - self.dim / 2 + 0.5) * self.size * 4
                    ny = (-self.i - m + self.dim / 2 - 0.5) * self.size * 4
                lines.append({
                    "abc": (nx - x, ny - y, (nx + x) * (nx - x) / 2 + (ny + y) * (ny - y) / 2),
                    "theta": math.atan2(nx - x, -(ny - y))
                })
        lines.sort(key=lambda line : line["theta"])
        queue = [{
            "xy": self.get_intersect(lines[0]["abc"], lines[1]["abc"]),
            "line_pre": lines[0],
            "line_post": lines[1]
        }]
        # todo 当相邻直线的极角之差大于180度时将出现非封闭图形，此时必须引入一条虚构的直线使图形封闭
        for i in range(2, 24):
            all_left = True
            all_right = True
            line = lines[i]
            for point in queue:
                if self.is_point_left(point["xy"], line["abc"]):
                    all_right = False
                else:
                    all_left = False
            if not all_left and not all_right:  # 确保图形封闭
                while not self.is_point_left(queue[-1]["xy"], line["abc"]):
                    queue.pop()
                while not self.is_point_left(queue[0]["xy"], line["abc"]):
                    queue.pop(0)
                all_left = True
            if all_left:
                tp = self.get_intersect(queue[-1]["line_post"]["abc"], line["abc"])
                success1 = True
                for point in queue:
                    if not self.is_point_left(tp, point["line_pre"]["abc"]):
                        success1 = False
                        break
                hp = self.get_intersect(queue[0]["line_pre"]["abc"], line["abc"])
                success2 = True
                for point in queue:
                    if not self.is_point_left(hp, point["line_post"]["abc"]):
                        success2 = False
                if success1:
                    queue.append({
                        "xy": tp,
                        "line_pre": queue[-1]["line_post"],
                        "line_post": line
                    })
                if success2:  # 确保图形封闭
                    queue.append({
                        "xy": hp,
                        "line_pre": line,
                        "line_post": queue[0]["line_pre"]
                    })
            elif all_right:
                tp = self.get_intersect(queue[-1]["line_post"]["abc"], line["abc"])
                success1 = True
                for point in queue:
                    if not self.is_point_left(tp, point["line_pre"]["abc"]):
                        success1 = False
                        break
                hp = self.get_intersect(queue[0]["line_pre"]["abc"], line["abc"])
                success2 = True
                for point in queue:
                    if not self.is_point_left(hp, point["line_post"]["abc"]):
                        success2 = False
                if success1:  # 确保图形封闭
                    queue = [{
                        "xy": tp,
                        "line_pre": queue[-1]["line_post"],
                        "line_post": line
                    }]
                elif success2:
                    queue = [{
                        "xy": hp,
                        "line_pre": queue[0]["line_pre"],
                        "line_post": line
                    }]
                else:  # 不可能
                    queue = []
                    return
        # 在晶格内的点似乎只能产生最多12边形
        for i in range(12):
            point = queue[min(i, len(queue) - 1)]
            vertex = *point["xy"], 0
            self.set_point(polygon, i, vertex)
    
    def get_intersect(self, abc1, abc2):
        a1, b1, c1 = abc1
        a2, b2, c2 = abc2
        d = a1 * b2 - b1 * a2
        if d == 0:
            d = 0.0001
        ix = (c1 * b2 - b1 * c2) / d
        iy = (a1 * c2 - c1 * a2) / d
        return ix, iy
    
    def is_point_left(self, xy, abc):
        x, y = xy
        a, b, c = abc
        return round(a * x + b * y, 8) < round(c, 8)
    
    def get_circumcenter(self, p1, p2, p3):
        a1 = 2 * (p2[0] - p1[0])
        b1 = 2 * (p2[1] - p1[1])
        c1 = p2[0] ** 2 + p2[1] ** 2 - p1[0] ** 2 - p1[1] ** 2
        a2 = 2 * (p3[0] - p2[0])
        b2 = 2 * (p3[1] - p2[1])
        c2 = p3[0] ** 2 + p3[1] ** 2 - p2[0] ** 2 - p2[1] ** 2
        x = (c1 * b2 - c2 * b1) / (a1 * b2 - a2 * b1)
        y = (a1 * c2 - a2 * c1) / (a1 * b2 - a2 * b1)
        return x, y
    
    def set_point(self, polygon, i, vertex):
        n = int(len(polygon.points) / 4)
        neighbor = polygon.points[(i + 1) % n * 4]
        polygon.points[i * 4] = vertex
        polygon.points[i * 4 + 1] = self.interp(vertex, neighbor, 1 / 3)
        polygon.points[i * 4 + 2] = self.interp(vertex, neighbor, 2 / 3)
        polygon.points[i * 4 + 3] = neighbor
        neighbor = polygon.points[(i - 1) % n * 4]
        polygon.points[(i - 1) % n * 4] = neighbor
        polygon.points[(i - 1) % n * 4 + 1] = self.interp(neighbor, vertex, 1 / 3)
        polygon.points[(i - 1) % n * 4 + 2] = self.interp(neighbor, vertex, 2 / 3)
        polygon.points[(i - 1) % n * 4 + 3] = vertex
    
    def interp(self, p1, p2, t):
        x = p1[0] * (1 - t) + p2[0] * t
        y = p1[1] * (1 - t) + p2[1] * t
        z = p1[2] * (1 - t) + p2[2] * t
        return x, y, z

class VoronoiZoom(Scene):
    def construct(self):
        dim = 9
        size = 0.2
        width = 429
        height = 428

        src = ImageMobject("image/11.png").get_pixel_array()
        points = {}
        seperates = []
        lattices = []
        voronois = []
        rasters = []
        # random.seed(0)
        for i in range(dim):
            for j in range(dim):
                color = src[int((i + 0.5) * width / dim)][int((j + 0.5) * height / dim)]
                pixel = ImageMobject(np.uint8([[color]]))
                x = (j - dim / 2 + 0.5) * size
                y = (-i + dim / 2 - 0.5) * size
                pixel.shift((x, y, 0))
                pixel.height = size + 0.01
                pixel.set_resampling_algorithm(RESAMPLING_ALGORITHMS["nearest"])
                self.add(pixel)
                seperates.append(ApplyMethod(pixel.shift, (x * 3, y * 3, 0)))  # animate property is unsafe

                point = Dot((x * 4, y * 4, 0)).set_fill(ManimColor(color)).set_stroke(WHITE, 2)
                point.set_opacity(0)
                self.add(point)
                lattices.append(ApplyMethod(point.set_opacity, 1))
                vertices = []
                for _ in range(3):
                    vx = (j - 0.5 - dim / 2 + 0.5) * size * 4
                    vy = (-i + 0.5 + dim / 2 - 0.5) * size * 4
                    vertices.append((vx, vy, 0))
                for _ in range(3):
                    vx = (j - 0.5 - dim / 2 + 0.5) * size * 4
                    vy = (-i - 0.5 + dim / 2 - 0.5) * size * 4
                    vertices.append((vx, vy, 0))
                for _ in range(3):
                    vx = (j + 0.5 - dim / 2 + 0.5) * size * 4
                    vy = (-i - 0.5 + dim / 2 - 0.5) * size * 4
                    vertices.append((vx, vy, 0))
                for _ in range(3):
                    vx = (j + 0.5 - dim / 2 + 0.5) * size * 4
                    vy = (-i + 0.5 + dim / 2 - 0.5) * size * 4
                    vertices.append((vx, vy, 0))
                polygon = Polygon(*vertices).set_fill(ManimColor(color)).set_stroke(WHITE)
                polygon.set_opacity(0)
                self.add(polygon)
                lattices.append(ApplyMethod(polygon.set_opacity, 0.5))
                points[i, j] = point, polygon

                rx = (random.random() * 3.6 - 1.8) * size
                ry = (random.random() * 3.6 - 1.8) * size
                voronois.append(ApplyMethod(point.shift, (rx, ry, 0)))

                rasters.append(ApplyMethod(point.set_opacity, 0))
                rasters.append(ApplyMethod(polygon.set_opacity, 0))

        for ij, pp in points.items():
            i, j = ij
            point, polygon = pp
            voronois.append(Voronoi(polygon, i, j, points))

        self.wait(0.5)
        self.play(*seperates)
        self.play(*lattices)
        self.play(*voronois)

        new_dim = (dim - 1) * 4
        result = np.zeros((new_dim, new_dim, 4), dtype=np.uint8)
        for i in range(new_dim):
            for j in range(new_dim):
                oi = i // 4
                oj = j // 4
                nw, _ = points[oi, oj]
                ne, _ = points[oi, oj + 1]
                sw, _ = points[oi + 1, oj]
                se, _ = points[oi + 1, oj + 1]
                m = (j - new_dim / 2) * size
                n = (-i + new_dim / 2) * size
                d1 = round((nw.get_x() - m) ** 2 + (nw.get_y() - n) ** 2, 8)
                d2 = round((ne.get_x() - m) ** 2 + (ne.get_y() - n) ** 2, 8)
                d3 = round((sw.get_x() - m) ** 2 + (sw.get_y() - n) ** 2, 8)
                d4 = round((se.get_x() - m) ** 2 + (se.get_y() - n) ** 2, 8)
                if d1 <= d2 and d1 <= d3 and d1 <= d4:
                    result[i][j] = nw.get_fill_color().to_int_rgba()
                elif d2 <= d1 and d2 <= d3 and d2 <= d4:
                    result[i][j] = ne.get_fill_color().to_int_rgba()
                elif d3 <= d1 and d3 <= d2 and d3 <= d4:
                    result[i][j] = sw.get_fill_color().to_int_rgba()
                else:
                    result[i][j] = se.get_fill_color().to_int_rgba()
        image = ImageMobject(result)
        image.fade(1)
        image.shift((-0.5 * size, 0.5 * size, 0))
        image.height = size * new_dim
        image.set_resampling_algorithm(RESAMPLING_ALGORITHMS["nearest"])
        self.add(image)
        rasters.append(ApplyMethod(image.fade, 0.2))

        self.play(*rasters)
        self.wait(0.5)
