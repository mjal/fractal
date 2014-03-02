(function() {
  var draw, julia;

  julia = function(z, c, max, iter) {
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
  };

  draw = function(scene, w, h) {
    var X, Y, buffer, dist, dx, dy, i, index, j, v;
    dx = scene.d.x / w;
    dy = scene.d.y / h;
    buffer = new Uint8Array(new ArrayBuffer(4 * w * h));
    i = 0;
    Y = scene.p.y - scene.d.y / 2;
    while (i < h) {
      j = 0;
      X = scene.p.x - scene.d.x / 2;
      while (j < w) {
        index = (i * w + j) * 4;
        dist = julia({
          x: X,
          y: Y
        }, scene.c, scene.max, scene.iter);
        v = 255 - Math.floor(255 * dist / scene.iter);
        buffer[index + 0] = v * scene.color[0];
        buffer[index + 1] = v * scene.color[1];
        buffer[index + 2] = v * scene.color[2];
        buffer[index + 3] = 255;
        X += dx;
        j++;
      }
      Y += dy;
      i++;
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
