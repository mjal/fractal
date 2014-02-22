canvas = document.querySelector "canvas"
ctx = canvas.getContext("2d")


c = [{x:0.285, y:0}, {y:0, x:1 - 1.6180339887}, {x: 0.4, y: 0.6}, {x: 0.285, y: 0.01}]

f = (c, z) ->
	x: z.x*z.x - z.y*z.y + c.x
	y: 2*z.y*z.x + c.y

julia2 = (z, c, max, iter) ->
	max2 = max*max
	xx = z.x*z.x
	yy = z.y*z.y
	while xx+yy < max2 and iter--
		z.y =z.y*(z.x+z.x) + c.y
		z.x = xx - yy + c.x
		xx = z.x*z.x
		yy = z.y*z.y
	iter

julia3 = (z, c, max, iter) ->
	max2 = max*max
	xx = z.x*z.x
	yy = z.y*z.y
	while xx+yy < max2 and iter--
		x = z.x
		y = z.y
		kx = xx-yy
		ky = 2 * z.x * z.y
		z.x = kx*x - ky*y + c.x
		z.y = kx*y + ky*x + c.y
		xx = z.x*z.x
		yy = z.y*z.y
	iter

mandelbrot2 = (z, c, max, iter) ->
	julia2(z, z, max, iter)

mandelbrot3 = (z, c, max, iter) ->
	julia3(z, z, max, iter)

buddhabrot = (z, c, max, iter, brot) ->
	b = 0
	n = 0
	while ++b < $scope.buddhabrot
		z = x: X + Math.random() * dx - dx / 2, y: Y + Math.random() * dy - dy / 2
		n++ if julia(z, z, max, $scope.iter) < brot / 2
		#n++ if julia(z, z, $scope.max, $scope.iter)
	(n / brot * iter)

n2 = (z) -> z.x*z.x + z.y*z.y

app = angular.module('app', [])
app.controller 'FractaltCtrl', ($scope) ->

	$scope.scenes = [ {
		name: "Julia 1"
		f: "julia"
		p: {x: 0, y: 0}
		d: {x: 3, y: 3}
		c: {x: -0.8, y: 0.156}
		iter: 80
	}, {
		name: "Julia 2"
		f: "julia"
		p: {x: 0, y: 0}
		d: {x: 2.5, y: 2.5}
		c: {x: 0.285, y: 0}
		iter: 80
	}, {
		name: "Mandelbrot"
		f: "mandelbrot"
		p: {x: 0, y: 0}
		d: {x: 2, y: 2}
		iter: 80
	}, {
		name: "Buddhabrot"
		f: "buddhabrot"
		p: {x: 0, y: 0}
		d: {x: 2, y: 2}
		iter: 60
		buddhabrot: 20
	} ]

	$scope.functions =
		"julia": julia2
		"julia cube": julia3
		"mandelbrot": mandelbrot2
		"mandelbrot cube": mandelbrot3
		"buddhabrot": buddhabrot

	$scope.methods = []
	$scope.methods.push name for name, fct of $scope.functions

	$scope.colors =
		"black/white": [1,1,1]
		"red": [1,0,0]
		"green": [0,1,0]
		"blue": [0,0,1]

	$scope.colorList = []
	$scope.colorList.push name for name, v of $scope.colors

	$scope.color = $scope.colorList[0]

	$scope.redraw = true

	$scope.draw = ->
		canvas.width = $('canvas').width()
		canvas.height = $('canvas').height()
		dx = $scope.d.x / canvas.width
		dy = $scope.d.y / canvas.height
		f = $scope.functions[$scope.f]
		antialias = false
		toImage = false

		console.log "start draw"
		time = (new Date).getTime()

		data = pixels = 0
		if toImage
			data = ctx.getImageData(0,0,canvas.width,canvas.height)
			pixels = data.data
		ctx.fillStyle = "rgb(0,0,0)"
		ctx.fillRect(0,0,canvas.width, canvas.height)

		i = 0
		X = $scope.p.x - $scope.d.x / 2
		while i < canvas.width
			j = 0
			Y = $scope.p.y - $scope.d.y / 2
			while j < canvas.height

				dist = f({x:X,y:Y}, $scope.c, $scope.max, $scope.iter)

				if $scope.inversed
					w = Math.floor 255 * dist / $scope.iter
				else
					w = 255 - Math.floor 255 * dist / $scope.iter
				c = $scope.colors[$scope.color]
				if toImage
					offset = (i * canvas.width + j) * 4
					pixels[offset] = w
					pixels[offset+1] = w
					pixels[offset+2] = w
				else if antialias
					ctx.fillStyle = "rgb(#{w*c[0]},#{w*c[1]},#{w*c[2]})"
					ctx.fillRect(i-0.5, j-0.5, 2, 2)
				else
					ctx.fillStyle = "rgb(#{w*c[0]},#{w*c[1]},#{w*c[2]})"
					ctx.fillRect(i, j, 1, 1)
#				if $scope.buddhabrot
#					s = 0
#					in_points = 0
#					while ++s < $scope.buddhabrot
#						z = x: X + Math.random() * dx + dx / 2, y: Y + Math.random() * dy + dy / 2
#						n = 0
#						while ++n < $scope.iteration and n2(z) < 4
#							z = f($scope.c, z)
#						in_points++ if n is $scope.iteration
#					n = in_points * $scope.iteration / $scope.buddhabrot

				Y += dy
				j++

			X += dx
			i++

		if toImage
			ctx.putImageData(data,0,0)

		console.log "enddraw"
		$scope.load_time = (new Date).getTime() - time

	$scope.redraw = ->
		$scope.draw() if $scope.redraw

	$scope.load = (scene) ->
		$scope.f = angular.copy scene.f
		$scope.p = angular.copy scene.p
		$scope.d = angular.copy scene.d
		$scope.c = angular.copy scene.c
		$scope.iter = scene.iter
		$scope.max = 2
		$scope.buddhabrot = scene.buddhabrot || 0

	$scope.createFractal = (char) ->
		return unless char is 13
		scene =
			name: $scope.newFractal
			f: $scope.f
			p: $scope.p
			d: $scope.d
			c: $scope.c
			iter: $scope.iter
		$scope.scenes.push scene
		$scope.newFractal = ''
		$scope.load scene

	$(canvas).scroll = (e) ->
		console.log "sceo"

	$scope.zoom = (e) ->
		x = e.pageX - $("canvas").offset().left
		y = e.pageY - $("canvas").offset().top
		$scope.p.x += (x - $("canvas").width() / 2) / $("canvas").width() * $scope.d.x
		$scope.p.y += (y - $("canvas").height() / 2) / $("canvas").height() * $scope.d.y
		$scope.d.x *= 2 / 3
		$scope.d.y *= 2 / 3
		$scope.iter = 500 / (Math.abs $scope.d.x + Math.abs $scope.d.y)
		$scope.draw() if $scope.redraw

	$scope.load $scope.scenes[0]
