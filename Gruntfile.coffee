module.exports = (grunt) ->

  grunt.initConfig
    coffee:
      compile:
        files:
          'index.js': 'src/index.coffee'
          'worker.js': 'src/worker.coffee'
    jade:
      compile:
        files:
          'index.html': 'src/index.jade'
    stylus:
      compile:
        files:
          'index.css': 'src/index.styl'
    watch:
      scripts:
        files: ['src/*'],
        tasks: ['default']

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['coffee', 'stylus', 'jade']
