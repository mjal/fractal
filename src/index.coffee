app = angular.module('app', [])
app.controller 'FractaltCtrl', ($scope) ->

  $scope.floor = Math.floor

  $scope.keys = (obj) ->
    key for key, val of obj

  phi = 1.6180339887

  $scope.scenes =
    "Julia 1":
      f: "julia"
      p: {x: 0, y: 0}
      d: {x: 4, y: 4}
      c: {x: -0.8, y: 0.156}
      max: 2
      iter: 60
    "Julia 2":
      f: "julia"
      p: {x: 0, y: 0}
      d: {x: 2.5, y: 2.5}
      c: {x: 0.285, y: 0.01}
      max: 2
      iter: 200
    "Julia 3":
      f: "julia"
      p: {x: 0, y: 0}
      d: {x: 2.5, y: 2.5}
      c: {x: 0.285, y: 0.5}
      max: 2
      iter: 100
    "Julia Cube 1":
      f: "julia_cube"
      p: {x: 0, y: 0}
      d: {x: 2.5, y: 2.5}
      c: {x: 1 - phi, y: 0.3}
      max: 2
      iter: 100
    "Julia Sine 1":
      f: "julia_sine"
      p: {x: 0, y: 0}
      d: {x: 5, y: 5}
      c: {x: 1, y: 0.1}
      max: 500
      iter: 50
    "Julia Sine 2":
      f: "julia_sine"
      p: {x: 0, y: 0}
      d: {x: 5, y: 5}
      c: {x: 1, y: 0.3}
      max: 500
      iter: 50
    "Julia Cosine 1":
      f: "julia_cosine"
      p: {x: 0, y: 0}
      d: {x: 10, y: 10}
      c: {x: 1, y: 0.6}
      max: 500
      iter: 75

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

  $scope.scene_name = "Julia 1"
  $scope.scene_color = "black/white"

  $scope.set_scene()
  $scope.set_color()

  worker = new Worker 'lib/worker.js'

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
