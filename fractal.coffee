canvas = document.querySelector "canvas"
ctx = canvas.getContext("2d")

iteration_max = 50
x1 = -2.1
y1 = -1.2
x2 = 0.6
y2 = 1.2
zoom_x = canvas.width/(x2 - x1)
zoom_y = canvas.height/(y2 - y1)

f = (c, z) ->
	x: z.x*z.x - z.y*z.y + c.x
	y: 2*z.y*z.x + c.y

n2 = (z) -> z.x*z.x + z.y*z.y

p = x: -0, y: -0

c = [{x:0.285, y:0}, {y:0, x:1 - 1.6180339887}, {x: 0.4, y: 0.6}, {x: 0.285, y: 0.01}]

draw = (p, zoom, c) ->
	ctx.fillStyle = "rgb(0,0,0)"
	i = 0
	img = new Image()
	img.width = 800
	img.height = 800
	img_ctx = ctx.getImageData(0, 0, img.width, img.height)

	while i < img.width
		j = 0
		while j < img.height
			z = x: p.x + i * zoom / img.width, y: p.y + j * zoom / img.height

			n = 0
			while ++n < iteration_max and n2(z) < 4
				z = f(c, z)
			if n is iteration_max
				w = Math.sqrt(n2(z)) * 256
				img_ctx.data[(i * 800 + j) * 4] = 255
				img_ctx.data[(i * 800 + j) * 4 + 1] = 255
				img_ctx.data[(i * 800 + j) * 4 + 2] = 255
				img_ctx.data[(i * 800 + j) * 4 + 3] = 255
				ctx.fillRect(i, j, 1, 1)
			j++
		i++
		ctx.putImageData(img_ctx, 0, 0,img.width,img.height,canvas.width,canvas.height)
	#ctx.putImageData(img_ctx, 0, 0, canvas.width, canvas.height)

zoom = 1
N = 0
draw(p, zoom, c[N])

upX = upY = downX = downY = false

document.addEventListener 'keypress',((e) ->
	char = e.which || e.keyCode
	console.log 'keypress:' + char

	p.x -= 0.1 * zoom if char is 97  # a
	p.x += 0.1 * zoom if char is 100 # d
	p.y -= 0.1 * zoom if char is 119 # up
	p.y += 0.1 * zoom if char is 115 # down

	zoom *= 0.9 if char is 120 # x
	zoom *= 1.1 if char is 122 # z

	c[N].x += 0.01 if char is 104 # h
	c[N].y += 0.01 if char is 106 # j
	c[N].x -= 0.01 if char is 107 # k
	c[N].y -= 0.01 if char is 108 # l

	N = (N + 1) % c.length if char is 110 # n

	ctx.fillStyle = "rgb(255,255,255)"
	ctx.fillRect 0,0,canvas.width, canvas.height
	draw(p, zoom, c[N])
),false
