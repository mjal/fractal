module.exports = (grunt) ->

  grunt.initConfig
    coffee:
      compile:
        files:
          'public/index.js': 'src/index.coffee'
    jade:
      compile:
        files:
          'public/index.html': 'src/index.jade'
    stylus:
      compile:
        files:
          'public/index.css': 'src/index.styl'

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-jade'

  grunt.registerTask 'default', ['coffee', 'stylus', 'jade']
