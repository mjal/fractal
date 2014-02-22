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
		xx = z.x*z.x
		yy = z.y*z.y
		z.y =z.y*(z.x+z.x) + c.y
		z.x = xx - yy + c.x
	iter

mandelbrot2 = (z, c, max, iter) ->
	julia2(z, z, max, iter)

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
		f: "julia2"
		p: {x: 0, y: 0}
		d: {x: 3, y: 3}
		c: {x: -0.8, y: 0.156}
		iter: 80
	}, {
		name: "Julia 2"
		f: "julia2"
		p: {x: 0, y: 0}
		d: {x: 2.5, y: 2.5}
		c: {x: 0.285, y: 0}
		iter: 80
	}, {
		name: "Julia 3"
		f: "julia2"
		p: {x: 0, y: 0}
		d: {x: 2.5, y: 2.5}
		c: {x: 0.70176, y:-0.38420}
		iter: 100
	}, {
		name: "Mandelbrot"
		f: "mandelbrot2"
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
		"julia2": julia2
		"mandelbrot2": mandelbrot2
		"buddhabrot": buddhabrot

	$scope.methods = ["julia2", "mandelbrot2", "buddhabrot"]

	$scope.redraw = true

	$scope.draw = ->
		canvas.width = $('canvas').width()
		canvas.height = $('canvas').height()
		dx = $scope.d.x / canvas.width
		dy = $scope.d.y / canvas.height
		f = $scope.functions[$scope.f]
		antialias = false
		toImage = false

		console.log "ddraw"
		data = pixels = 0
		if toImage
			data = ctx.getImageData(0,0,canvas.width,canvas.height)
			pixels = data.data

		i = 0
		X = $scope.p.x - $scope.d.x / 2
		while i < canvas.width
			j = 0
			Y = $scope.p.y - $scope.d.y / 2
			while j < canvas.height

				dist = f({x:X,y:Y}, $scope.c, $scope.max, $scope.iter)

				w = Math.floor 255 * dist / $scope.iter
				if toImage
					offset = (i * canvas.width + j) * 4
					pixels[offset] = w
					pixels[offset+1] = w
					pixels[offset+2] = w
				else if antialias
					ctx.fillStyle = "rgb(#{w},#{w},#{w})"
					ctx.fillRect(i-0.5, j-0.5, 2, 2)
				else
					ctx.fillStyle = "rgb(#{w},#{w},#{w})"
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
		$scope.draw() if $scope.redraw

	$scope.load $scope.scenes[0]
