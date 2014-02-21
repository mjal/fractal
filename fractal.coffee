canvas = document.querySelector "canvas"
ctx = canvas.getContext("2d")


c = [{x:0.285, y:0}, {y:0, x:1 - 1.6180339887}, {x: 0.4, y: 0.6}, {x: 0.285, y: 0.01}]

f = (c, z) ->
	x: z.x*z.x - z.y*z.y + c.x
	y: 2*z.y*z.x + c.y

n2 = (z) -> z.x*z.x + z.y*z.y

log2 = 1 / Math.log(2.0)

draw = (p, d, c, it) ->
	ctx.fillStyle = "rgb(0,0,0)"
	ctx.fillRect(0, 0, canvas.width, canvas.height)

	X = p.x - d.x / 2
	dx = d.x / canvas.width
	dy = d.y / canvas.height
	i = 0
	while i < canvas.width
		j = 0
		Y = p.y - d.y / 2
		while j < canvas.height
			z = x: X, y: Y
			n = 0
			while ++n < it and n2(z) < 4
				z = f(x: X, y: Y, z)
			w = 0
			w = 255 if n is it
			ctx.fillStyle = "rgb(#{w},#{w},#{w})"
			ctx.fillRect(i, j, 1, 1)
			Y += dy
			j++
		X += dx
		i++

N = 3

app = angular.module('app', [])
app.controller 'FractaltCtrl', ($scope) ->

	$scope.redraw = false

	$scope.px = 0
	$scope.py = 0

	$scope.dx = 2.5
	$scope.dy = 2.5

	$scope.a = c[N].x
	$scope.b = c[N].y

	$scope.iteration = 60

	$scope.keyPress = (char) ->
		console.log 'keypress:' + char
		$scope.p.x -= 0.1 * zoom if char is 65  # a
		$scope.p.x += 0.1 * zoom if char is 68 # d
		$scope.p.y -= 0.1 * zoom if char is 87 # up
		$scope.p.y += 0.1 * zoom if char is 83 # down
		zoom *= 0.9 if char is 90 # x
		zoom *= 1.1 if char is 88 # z
		$scope.a += 0.01 if char is 72 # h
		$scope.b += 0.01 if char is 74 # j
		$scope.a -= 0.01 if char is 75 # k
		$scope.b -= 0.01 if char is 76 # l
		if char is 78 # n
			N = (N + 1) % c.length
			$scope.a = c[N].x
			$scope.b = c[N].y

	$scope.draw = ->
		console.log "draw"
		draw({x:$scope.px; y:$scope.py},
		{x:$scope.dx; y:$scope.dy},
		{x: $scope.a, y: $scope.b},
		$scope.iteration)
		console.log "enddraw"

	$scope.zoom = (e) ->
		x = e.pageX - $("canvas").offset().left
		y = e.pageY - $("canvas").offset().top
		$scope.px += (x - $("canvas").width() / 2) / $("canvas").width() * $scope.dx
		$scope.py += (y - $("canvas").height() / 2) / $("canvas").height() * $scope.dy
		$scope.dx /= 6 / 4
		$scope.dy /= 6 / 4
		$scope.draw() if $scope.redraw

	$scope.move = (dir) ->
		$scope.px -= $scope.dx / 4 if dir is "left"
		$scope.px += $scope.dx / 4 if dir is "right"
		$scope.py -= $scope.dy / 4 if dir is "up"
		$scope.py += $scope.dy / 4 if dir is "down"
		$scope.draw() if $scope.redraw

	$scope.movec = (dir) ->
		$scope.a -= 0.001 if dir is "left"
		$scope.a += 0.001 if dir is "right"
		$scope.b -= 0.001 if dir is "up"
		$scope.b += 0.001 if dir is "down"
		$scope.draw() if $scope.redraw

	$scope.moveit = (dir) ->
		$scope.iteration += 5 if dir is "up"
		$scope.iteration -= 5 if dir is "down"
		$scope.draw() if $scope.redraw
