julia = (z, c, max, iter) ->
  max2 = max*max
  xx = z.x * z.x
  yy = z.y * z.y
  while xx+yy < max2 and iter--
    z.y = 2 * z.x * z.y + c.y
    z.x = xx - yy + c.x
    xx = z.x * z.x
    yy = z.y * z.y
  iter

app = angular.module('app', [])
app.controller 'FractaltCtrl', ($scope) ->

  $scope.keys = (obj) ->
    key for key, val of obj

  $scope.scenes =
    "Scene 1":
      f: "julia"
      p: {x: 0, y: 0}
      d: {x: 3, y: 3}
      c: {x: -0.8, y: 0.156}
      max: 2
      iter: 60
    "Scene 2":
      f: "julia"
      p: {x: 0, y: 0}
      d: {x: 2.5, y: 2.5}
      c: {x: 0.285, y: 0}
      max: 2
      iter: 200

  $scope.colors =
    "black/white": [1,1,1]
    "red": [1,0,0]
    "green": [0,1,0]
    "blue": [0,0,1]

  $scope.set_color = ->
    $scope.scene.color = $scope.colors[$scope.scene_color]

  $scope.set_scene = ->
    $scope.scene = angular.copy $scope.scenes[$scope.scene_name]
    $scope.set_color()

  $scope.scene_name = "Scene 1"
  $scope.scene_color = "black/white"

  $scope.set_scene()
  $scope.set_color()

  worker = new Worker 'worker.js'

  $scope.draw = ->
    canvas = document.querySelector 'canvas'
    canvas.width = $(canvas).width()
    canvas.height = $(canvas).height()
    worker.postMessage(scene: $scope.scene, w: canvas.width, h: canvas.height)

  worker.addEventListener 'message', (worker_data) ->
    canvas = document.querySelector 'canvas'
    ctx = canvas.getContext('2d')
    img_data = ctx.createImageData(worker_data.data.w, worker_data.data.h)
    img_data.data.set worker_data.data.buffer
    ctx.putImageData img_data, 0, 0

  $scope.draw()
