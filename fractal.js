// Generated by CoffeeScript 1.6.3
(function() {
  var app, buddhabrot, c, canvas, ctx, f, julia2, julia3, mandelbrot2, mandelbrot3, n2;

  canvas = document.querySelector("canvas");

  ctx = canvas.getContext("2d");

  c = [
    {
      x: 0.285,
      y: 0
    }, {
      y: 0,
      x: 1 - 1.6180339887
    }, {
      x: 0.4,
      y: 0.6
    }, {
      x: 0.285,
      y: 0.01
    }
  ];

  f = function(c, z) {
    return {
      x: z.x * z.x - z.y * z.y + c.x,
      y: 2 * z.y * z.x + c.y
    };
  };

  julia2 = function(z, c, max, iter) {
    var max2, xx, yy;
    max2 = max * max;
    xx = z.x * z.x;
    yy = z.y * z.y;
    while (xx + yy < max2 && iter--) {
      z.y = z.y * (z.x + z.x) + c.y;
      z.x = xx - yy + c.x;
      xx = z.x * z.x;
      yy = z.y * z.y;
    }
    return iter;
  };

  julia3 = function(z, c, max, iter) {
    var kx, ky, max2, x, xx, y, yy;
    max2 = max * max;
    xx = z.x * z.x;
    yy = z.y * z.y;
    while (xx + yy < max2 && iter--) {
      x = z.x;
      y = z.y;
      kx = xx - yy;
      ky = 2 * z.x * z.y;
      z.x = kx * x - ky * y + c.x;
      z.y = kx * y + ky * x + c.y;
      xx = z.x * z.x;
      yy = z.y * z.y;
    }
    return iter;
  };

  mandelbrot2 = function(z, c, max, iter) {
    return julia2(z, z, max, iter);
  };

  mandelbrot3 = function(z, c, max, iter) {
    return julia3(z, z, max, iter);
  };

  buddhabrot = function(z, c, max, iter, brot) {
    var b, n;
    b = 0;
    n = 0;
    while (++b < $scope.buddhabrot) {
      z = {
        x: X + Math.random() * dx - dx / 2,
        y: Y + Math.random() * dy - dy / 2
      };
      if (julia(z, z, max, $scope.iter) < brot / 2) {
        n++;
      }
    }
    return n / brot * iter;
  };

  n2 = function(z) {
    return z.x * z.x + z.y * z.y;
  };

  app = angular.module('app', []);

  app.controller('FractaltCtrl', function($scope) {
    var fct, name, v, _ref, _ref1;
    $scope.scenes = [
      {
        name: "Julia 1",
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
        iter: 80
      }, {
        name: "Julia 2",
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
        iter: 80
      }, {
        name: "Mandelbrot",
        f: "mandelbrot",
        p: {
          x: 0,
          y: 0
        },
        d: {
          x: 2,
          y: 2
        },
        iter: 80
      }, {
        name: "Buddhabrot",
        f: "buddhabrot",
        p: {
          x: 0,
          y: 0
        },
        d: {
          x: 2,
          y: 2
        },
        iter: 60,
        buddhabrot: 20
      }
    ];
    $scope.functions = {
      "julia": julia2,
      "julia cube": julia3,
      "mandelbrot": mandelbrot2,
      "mandelbrot cube": mandelbrot3,
      "buddhabrot": buddhabrot
    };
    $scope.methods = [];
    _ref = $scope.functions;
    for (name in _ref) {
      fct = _ref[name];
      $scope.methods.push(name);
    }
    $scope.colors = {
      "black/white": [1, 1, 1],
      "red": [1, 0, 0],
      "green": [0, 1, 0],
      "blue": [0, 0, 1]
    };
    $scope.colorList = [];
    _ref1 = $scope.colors;
    for (name in _ref1) {
      v = _ref1[name];
      $scope.colorList.push(name);
    }
    $scope.color = $scope.colorList[0];
    $scope.redraw = true;
    $scope.draw = function() {
      var X, Y, antialias, data, dist, dx, dy, i, j, offset, pixels, time, toImage, w;
      canvas.width = $('canvas').width();
      canvas.height = $('canvas').height();
      dx = $scope.d.x / canvas.width;
      dy = $scope.d.y / canvas.height;
      f = $scope.functions[$scope.f];
      antialias = false;
      toImage = false;
      console.log("start draw");
      time = (new Date).getTime();
      data = pixels = 0;
      if (toImage) {
        data = ctx.getImageData(0, 0, canvas.width, canvas.height);
        pixels = data.data;
      }
      ctx.fillStyle = "rgb(0,0,0)";
      ctx.fillRect(0, 0, canvas.width, canvas.height);
      i = 0;
      X = $scope.p.x - $scope.d.x / 2;
      while (i < canvas.width) {
        j = 0;
        Y = $scope.p.y - $scope.d.y / 2;
        while (j < canvas.height) {
          dist = f({
            x: X,
            y: Y
          }, $scope.c, $scope.max, $scope.iter);
          if ($scope.inversed) {
            w = Math.floor(255 * dist / $scope.iter);
          } else {
            w = 255 - Math.floor(255 * dist / $scope.iter);
          }
          c = $scope.colors[$scope.color];
          if (toImage) {
            offset = (i * canvas.width + j) * 4;
            pixels[offset] = w;
            pixels[offset + 1] = w;
            pixels[offset + 2] = w;
          } else if (antialias) {
            ctx.fillStyle = "rgb(" + (w * c[0]) + "," + (w * c[1]) + "," + (w * c[2]) + ")";
            ctx.fillRect(i - 0.5, j - 0.5, 2, 2);
          } else {
            ctx.fillStyle = "rgb(" + (w * c[0]) + "," + (w * c[1]) + "," + (w * c[2]) + ")";
            ctx.fillRect(i, j, 1, 1);
          }
          Y += dy;
          j++;
        }
        X += dx;
        i++;
      }
      if (toImage) {
        ctx.putImageData(data, 0, 0);
      }
      console.log("enddraw");
      return $scope.load_time = (new Date).getTime() - time;
    };
    $scope.redraw = function() {
      if ($scope.redraw) {
        return $scope.draw();
      }
    };
    $scope.load = function(scene) {
      $scope.f = angular.copy(scene.f);
      $scope.p = angular.copy(scene.p);
      $scope.d = angular.copy(scene.d);
      $scope.c = angular.copy(scene.c);
      $scope.iter = scene.iter;
      $scope.max = 2;
      return $scope.buddhabrot = scene.buddhabrot || 0;
    };
    $scope.createFractal = function(char) {
      var scene;
      if (char !== 13) {
        return;
      }
      scene = {
        name: $scope.newFractal,
        f: $scope.f,
        p: $scope.p,
        d: $scope.d,
        c: $scope.c,
        iter: $scope.iter
      };
      $scope.scenes.push(scene);
      $scope.newFractal = '';
      return $scope.load(scene);
    };
    $(canvas).scroll = function(e) {
      return console.log("sceo");
    };
    $scope.zoom = function(e) {
      var x, y;
      x = e.pageX - $("canvas").offset().left;
      y = e.pageY - $("canvas").offset().top;
      $scope.p.x += (x - $("canvas").width() / 2) / $("canvas").width() * $scope.d.x;
      $scope.p.y += (y - $("canvas").height() / 2) / $("canvas").height() * $scope.d.y;
      $scope.d.x *= 2 / 3;
      $scope.d.y *= 2 / 3;
      $scope.iter = 500 / (Math.abs($scope.d.x + Math.abs($scope.d.y)));
      if ($scope.redraw) {
        return $scope.draw();
      }
    };
    return $scope.load($scope.scenes[0]);
  });

}).call(this);
