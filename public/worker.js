(function() {
  var draw, f;

  f = {
    julia: function(z, c, max, iter) {
      var max2, xx, yy;
      max2 = max * max;
      xx = z.x * z.x;
      yy = z.y * z.y;
      while (xx + yy < max2 && --iter) {
        z.y = 2 * z.x * z.y + c.y;
        z.x = xx - yy + c.x;
        xx = z.x * z.x;
        yy = z.y * z.y;
      }
      return iter;
    },
    julia_cube: function(z, c, max, iter) {
      var a, b, max2, x, xx, y, yy;
      max2 = max * max;
      xx = z.x * z.x;
      yy = z.y * z.y;
      while (xx + yy < max2 && --iter) {
        x = z.x;
        y = z.y;
        a = z.x * z.x - z.y * z.y;
        b = 2 * z.x * z.y;
        z.x = a * x - b * y + c.x;
        z.y = a * y + b * x - c.y;
        xx = z.x * z.x;
        yy = z.y * z.y;
      }
      return iter;
    },
    julia_sine: function(z, c, max, iter) {
      var emy, ey, t, xx, yy;
      xx = z.x * z.x;
      yy = z.y * z.y;
      while (xx + yy < max && --iter) {
        ey = Math.exp(z.y);
        emy = Math.exp(-z.y);
        t = {
          x: Math.sin(z.x) * (ey + emy) / 2,
          y: Math.cos(z.x) * (ey - emy) / 2
        };
        z = {
          x: c.x * t.x - c.y * t.y,
          y: z.y = c.x * t.y + c.y * t.x
        };
        yy = z.y * z.y;
        xx = z.x * z.x;
      }
      return iter;
    },
    julia_cosine: function(z, c, max, iter) {
      var emy, ey, t, xx, yy;
      xx = z.x * z.x;
      yy = z.y * z.y;
      while (xx + yy < max && --iter) {
        ey = Math.exp(z.y);
        emy = Math.exp(-z.y);
        t = {
          x: Math.cos(z.x) * (ey + emy) / 2,
          y: -Math.sin(z.x) * (ey - emy) / 2
        };
        z = {
          x: c.x * t.x - c.y * t.y,
          y: z.y = c.x * t.y + c.y * t.x
        };
        yy = z.y * z.y;
        xx = z.x * z.x;
      }
      return iter;
    }
  };

  draw = function(scene, w, h) {
    var X, Y, buffer, delta, dist, dx, dy, i, index, j, _i, _j;
    buffer = new Uint8Array(new ArrayBuffer(4 * w * h));
    dx = scene.d.x / w;
    dy = scene.d.y / h;
    Y = scene.p.y - scene.d.y / 2;
    for (i = _i = 0; 0 <= h ? _i <= h : _i >= h; i = 0 <= h ? ++_i : --_i) {
      X = scene.p.x - scene.d.x / 2;
      for (j = _j = 0; 0 <= w ? _j <= w : _j >= w; j = 0 <= w ? ++_j : --_j) {
        dist = scene.iter - f[scene.f]({
          x: X,
          y: Y
        }, scene.c, scene.max, scene.iter);
        delta = Math.floor(255 * dist / scene.iter);
        index = (i * w + j) * 4;
        buffer[index + 0] = delta * scene.color[0];
        buffer[index + 1] = delta * scene.color[1];
        buffer[index + 2] = delta * scene.color[2];
        buffer[index + 3] = 255;
        X += dx;
      }
      Y += dy;
    }
    return buffer;
  };

  self.addEventListener('message', (function(e) {
    var buffer;
    buffer = draw(e.data.scene, e.data.w, e.data.h);
    return self.postMessage({
      buffer: buffer,
      w: e.data.w,
      h: e.data.h
    }, [buffer.buffer]);
  }), false);

}).call(this);
