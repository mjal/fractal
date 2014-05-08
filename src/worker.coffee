f =
  julia: (z, c, max, iter) ->
    max2 = max * max
    xx = z.x * z.x
    yy = z.y * z.y
    while xx + yy < max2 and --iter
      z.y = 2 * z.x * z.y + c.y
      z.x = xx - yy + c.x
      xx = z.x * z.x
      yy = z.y * z.y
    iter

  julia_cube: (z, c, max, iter) ->
    max2 = max * max
    xx = z.x * z.x
    yy = z.y * z.y
    while xx + yy < max2 and --iter
      x = z.x
      y = z.y
      a = z.x * z.x - z.y * z.y
      b = 2 * z.x * z.y
      z.x = a * x - b * y + c.x
      z.y = a * y + b * x - c.y
      xx = z.x * z.x
      yy = z.y * z.y
    iter

  julia_sine: (z, c, max, iter) ->
    xx = z.x * z.x
    yy = z.y * z.y
    while xx + yy < max and --iter
      ey = Math.exp(z.y)
      emy = Math.exp(-z.y)
      t =
        x: Math.sin(z.x) * (ey + emy) / 2
        y: Math.cos(z.x) * (ey - emy) / 2
      z =
        x: c.x * t.x - c.y * t.y
        y: z.y = c.x * t.y + c.y * t.x
      yy = z.y * z.y
      xx = z.x * z.x
    iter

  julia_cosine: (z, c, max, iter) ->
    xx = z.x * z.x
    yy = z.y * z.y
    while xx + yy < max and --iter
      ey = Math.exp(z.y)
      emy = Math.exp(-z.y)
      t =
        x: Math.cos(z.x) * (ey + emy) / 2
        y: - Math.sin(z.x) * (ey - emy) / 2
      z =
        x: c.x * t.x - c.y * t.y
        y: z.y = c.x * t.y + c.y * t.x
      yy = z.y * z.y
      xx = z.x * z.x
    iter

draw = (scene, w, h) ->
  buffer = new Uint8Array(new ArrayBuffer(4 * w * h))

  dx = scene.d.x / w
  dy = scene.d.y / h

  Y = scene.p.y - scene.d.y / 2
  for i in [0..h]
    X = scene.p.x - scene.d.x / 2
    for j in [0..w]
      dist = scene.iter - f[scene.f]({x:X,y:Y}, scene.c, scene.max, scene.iter)
      delta = Math.floor(255 * dist / scene.iter)

      index = (i * w + j) * 4
      buffer[index + 0] = delta * scene.color[0]
      buffer[index + 1] = delta * scene.color[1]
      buffer[index + 2] = delta * scene.color[2]
      buffer[index + 3] = 255
      X += dx
    Y += dy
  return buffer

self.addEventListener 'message', ((e) ->
  buffer = draw(e.data.scene, e.data.w, e.data.h)
  self.postMessage {buffer: buffer, w: e.data.w, h: e.data.h}, [buffer.buffer]
), false
