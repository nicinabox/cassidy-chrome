_ = require('lodash')

module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  config =
    pkg: grunt.file.readJSON('package.json')

    watch:
      options:
        livereload: true
        files: ['.tmp/**/*', 'Gruntfile*']

      gruntfile:
        files: 'Gruntfile*'

      scripts:
        files: 'app/javascripts/**/*.coffee'
        tasks: ['coffee', 'concat']

      styles:
        files: 'app/stylesheets/**/*.scss'
        tasks: ['compass:main']

      templates:
        files: 'app/templates/**/*.hbs'
        tasks: ['handlebars', 'concat']

    handlebars:
      compile:
        options:
          namespace: "JST"
          processName: (filePath) ->
            filePath
              .replace('app/templates/', '')
              .replace('.hbs', '')

        files:
          ".tmp/javascripts/templates.js": [
            "app/templates/*.hbs"
          ]

    coffee:
      compileBare:
        files:
          ".tmp/javascripts/application.js": [
            'app/javascripts/*.coffee'
          ]

    concat:
      dist:
        files:
          ".tmp/javascripts/application.js": [
              'node_modules/jquery/dist/jquery.js'
              'node_modules/handlebars/dist/handlebars.runtime.js'
              '.tmp/javascripts/templates.js'
              '.tmp/javascripts/application.js'
            ]

    compass:
      options:
        importPath: []
        sassDir: "app/stylesheets"

      main:
        options:
          cssDir: ".tmp/stylesheets"
          environment: 'development'

      dist:
        options:
          cssDir: "dist/stylesheets"
          environment: 'production'

    clean:
      dist: ['dist/*']
      server: '.tmp'

    copy:
      dist:
        expand: true
        cwd: '.tmp'
        dest: 'dist'
        src: [
          'images/*'
          '*.html'
        ]

  grunt.initConfig config

  grunt.registerTask 'default', [
    'compile'
    'watch'
  ]

  grunt.registerTask 'compile', [
    'handlebars'
    'coffee'
    'concat'
    'compass:main'
  ]

  grunt.registerTask 'build', [
    'clean:dist'
    'handlebars'
    'compass:dist'
    'coffee'
    'copy:dist'
  ]
