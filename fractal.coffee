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
	while i < canvas.width
		j = 0
		while j < canvas.height
			z = x: p.x + i * zoom / canvas.width, y: p.y + j * zoom / canvas.height

			n = 0
			while ++n < iteration_max and n2(z) < 4
				z = f(c, z)
			if n is iteration_max
				ctx.fillRect(i, j, 1, 1)
			j++
		i++

zoom = 1
N = 0
draw(p, zoom, c[N])

upX = upY = downX = downY = false

document.addEventListener 'keyup',((e) ->
	char = e.which || e.keyCode;
	console.log 'keypress:' + char
	p.x += 0.1 if char is 39 # left
	p.x -= 0.1 if char is 37 # right
	p.y += 0.1 if char is 40 # up
	p.y -= 0.1 if char is 38 # down
	zoom *= 0.9 if char is 32 # down
	zoom *= 1.1 if char is 88
	N = N + 1 % c.length if char is 87
	upX = true if char is 65
	downX = true if char is 90
	upY = true if char is 81
	downY = true if char is 83
	ctx.fillStyle = "rgb(255,255,255)"
	ctx.fillRect(0,0,canvas.width, canvas.height);
	updateC()
	draw(p, zoom, c[N])
),false

updateC = ->
	c[N].x += 0.01 if upX
	c[N].y += 0.01 if upY
	c[N].x -= 0.01 if downX
	c[N].y -= 0.01 if downY
	upX = upY = downX = downY = false
