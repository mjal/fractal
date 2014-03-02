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
    var worker;
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
        iter: 200
      }
    };
    $scope.colors = {
      "black/white": [1, 1, 1],
      "red": [1, 0, 0],
      "green": [0, 1, 0],
      "blue": [0, 0, 1]
    };
    $scope.set_color = function() {
      return $scope.scene.color = $scope.colors[$scope.scene_color];
    };
    $scope.set_scene = function() {
      $scope.scene = angular.copy($scope.scenes[$scope.scene_name]);
      return $scope.set_color();
    };
    $scope.scene_name = "Scene 1";
    $scope.scene_color = "black/white";
    $scope.set_scene();
    $scope.set_color();
    worker = new Worker('worker.js');
    $scope.draw = function() {
      var canvas;
      canvas = document.querySelector('canvas');
      canvas.width = $(canvas).width();
      canvas.height = $(canvas).height();
      return worker.postMessage({
        scene: $scope.scene,
        w: canvas.width,
        h: canvas.height
      });
    };
    worker.addEventListener('message', function(worker_data) {
      var canvas, ctx, img_data;
      canvas = document.querySelector('canvas');
      ctx = canvas.getContext('2d');
      img_data = ctx.createImageData(worker_data.data.w, worker_data.data.h);
      img_data.data.set(worker_data.data.buffer);
      return ctx.putImageData(img_data, 0, 0);
    });
    return $scope.draw();
  });

}).call(this);
