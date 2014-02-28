
/*
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
     *n++ if julia(z, z, $scope.max, $scope.iter)
  (n / brot * iter)

n2 = (z) -> z.x*z.x + z.y*z.y
 */

(function() {
  var app, julia;

  julia = function(z, c, max, iter) {
    var max2, xx, yy;
    max2 = max * max;
    xx = z.x * z.x;
    yy = z.y * z.y;
    while (xx + yy < max2 && iter--) {
      z.y = 2 * z.x * z.y + c.y;
      z.x = xx - yy + c.x;
      xx = z.x * z.x;
      yy = z.y * z.y;
    }
    return iter;
  };

  app = angular.module('app', []);

  app.controller('FractaltCtrl', function($scope) {
    $scope.keys = function(obj) {
      var key, val, _results;
      _results = [];
      for (key in obj) {
        val = obj[key];
        _results.push(key);
      }
      return _results;
    };
    $scope.scenes = {
      "Scene 1": {
        f: "julia",
        p: {
          x: 0,
          y: 0
        },
        d: {
          x: 3,
          y: 3
        },
        c: {
          x: -0.8,
          y: 0.156
        },
        max: 2,
        iter: 60
      },
      "Scene 2": {
        f: "julia",
        p: {
          x: 0,
          y: 0
        },
        d: {
          x: 2.5,
          y: 2.5
        },
        c: {
          x: 0.285,
          y: 0
        },
        max: 2,
        iter: 80
      }
    };
    $scope.set_scene = function(name) {
      return $scope.scene = angular.copy($scope.scenes[$scope.scene_name]);
    };
    $scope.scene_name = "Scene 1";
    $scope.set_scene();
    $scope.colors = {
      "black/white": [1, 1, 1],
      "red": [1, 0, 0],
      "green": [0, 1, 0],
      "blue": [0, 0, 1]
    };
    $scope.scene_color = "black/white";
    $scope.draw = function() {
      var X, Y, c, ctx, dist, dx, dy, h, i, j, scene, time, v, w, _results;
      ctx = $('canvas')[0].getContext("2d");
      scene = $scope.scene;
      console.log($('canvas')[0].width);
      console.log($('canvas').width());
      $('canvas')[0].width = $('canvas').width();
      $('canvas')[0].height = $('canvas').height();
      w = $('canvas').width();
      h = $('canvas').height();
      dx = scene.d.x / w;
      dy = scene.d.y / h;
      time = (new Date).getTime();
      ctx.fillStyle = "rgb(0,0,0)";
      ctx.fillRect(0, 0, w, h);
      i = 0;
      X = scene.p.x - scene.d.x / 2;
      _results = [];
      while (i < w) {
        j = 0;
        Y = scene.p.y - scene.d.y / 2;
        while (j < h) {
          dist = julia({
            x: X,
            y: Y
          }, scene.c, scene.max, scene.iter);
          v = 255 - Math.floor(255 * dist / scene.iter);
          c = $scope.colors[$scope.scene_color];
          ctx.fillStyle = "rgb(" + (v * c[0]) + "," + (v * c[1]) + "," + (v * c[2]) + ")";
          ctx.fillRect(i, j, 1, 1);
          Y += dy;
          j++;
        }
        X += dx;
        _results.push(i++);
      }
      return _results;
    };
    return $scope.draw();
  });

}).call(this);
