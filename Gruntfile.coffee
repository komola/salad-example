module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"

    uglify:
      options:
        banner: '/*! <%= pkg.name %> -v<%= pkg.version %> - <%= grunt.template.today("yyyy-mm-dd") %> */\n'
        report: 'gzip'
      dist:
        files:
          'public/assets/application.min.js': ['public/assets/application.js']

    bgShell:
      runNode:
        cmd: "./node_modules/.bin/supervisor --extensions 'node|js|coffee' app server.js"
        bg: true
    stylus:
      compile:
        options:
          paths: ["app/stylesheets"]
        files:
          "public/stylesheets/application.css": "app/stylesheets/application.styl"

    concat:
      options:
        separator: ";"

      dist:
        files:
          "public/assets/application.js": "public/javascripts/**/*.js"
          "public/assets/application.css": "public/stylesheets/*.css"

    watch:
      options:
        livereload: true

      coffee:
        files: ['app/**/client/*.coffee']
        tasks: ['coffee']

      css:
        files: ['app/stylesheets/*.styl']
        tasks: ['stylus']

    coffee:
      compileEachMap:
        options:
          sourceMap: true
        files: [
          expand: true
          cwd: "app"
          src: "*/client/*.coffee"
          dest: "public/javascripts"
          ext: ".js"
        ]

  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-stylus"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-bg-shell"

  grunt.registerTask "compile", ["coffee", "stylus"]
  grunt.registerTask "server", ["bgShell:runNode", "watch"]

  grunt.registerTask "build", ["concat", "uglify"]

  grunt.registerTask "default", ["compile"]
