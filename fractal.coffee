canvas = document.querySelector "canvas"
ctx = canvas.getContext("2d")


p = x: -0, y: -0
c = [{x:0.285, y:0}, {y:0, x:1 - 1.6180339887}, {x: 0.4, y: 0.6}, {x: 0.285, y: 0.01}]

f = (c, z) ->
	x: z.x*z.x - z.y*z.y + c.x
	y: 2*z.y*z.x + c.y

n2 = (z) -> z.x*z.x + z.y*z.y


draw = (p, c, zoom, it) ->
	ctx.fillStyle = "rgb(0,0,0)"
	i = 0
	img = new Image()
	img.width = 1600
	img.height = 1600
	img_ctx = ctx.createImageData(1600, 1600)

	while i < img.width
		j = 0
		while j < img.height
			z = x: p.x + i * zoom / img.width, y: p.y + j * zoom / img.height

			n = 0
			while ++n < it and n2(z) < 4
				z = f(c, z)
			if n is it
				w = Math.sqrt(n2(z)) * 256
				img_ctx.data[(i * img.width + j) * 4] = w
				img_ctx.data[(i * img.width + j) * 4 + 1] = w
				img_ctx.data[(i * img.width + j) * 4 + 2] = w
				img_ctx.data[(i * img.width + j) * 4 + 3] = w
			else
				img_ctx.data[(i * img.width + j) * 4] = 0
				img_ctx.data[(i * img.width + j) * 4 + 1] = 0
				img_ctx.data[(i * img.width + j) * 4 + 2] = 0
				img_ctx.data[(i * img.width + j) * 4 + 3] = 255
				#ctx.fillRect(i, j, 1, 1)
			j++
		i++
	ctx.putImageData(img_ctx, 0, 0)
	#ctx.putImageData(img_ctx, 0, 0, canvas.width, canvas.height)

zoom = 1
N = 0

app = angular.module('app', [])
app.controller 'FractaltCtrl', ($scope) ->

	$scope.x = 0
	$scope.y = 0

	$scope.a = c[N].x
	$scope.b = c[N].y

	$scope.iteration = 60

	done = true
	setInterval (->
		return if done is false
		done = false
		ctx.fillStyle = "rgb(255,255,255)"
		ctx.fillRect 0,0,canvas.width, canvas.height
		console.log "draw"
		draw({x: $scope.x, y: $scope.y}, {x: $scope.a, y: $scope.b}, zoom, $scope.iteration)
		done = true
		console.log "enddraw"
	), 2000

	$scope.keyPress = (char) ->

		console.log {x: $scope.a, y: $scope.b}

		console.log 'keypress:' + char

		$scope.x -= 0.1 * zoom if char is 65  # a
		$scope.x += 0.1 * zoom if char is 68 # d
		$scope.y -= 0.1 * zoom if char is 87 # up
		$scope.y += 0.1 * zoom if char is 83 # down

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

