module.exports = (grunt) ->

  grunt.initConfig({
    browserify: {
      client: {
        files: {
          'public/module.js': ['client/index.coffee']
        }
        options: {
          transform: ['coffeeify']
        }
      }
    }
    pug: {
      defaultTask: {
        expand: true
        cwd: 'public'
        src: '*.pug'
        dest: 'public'
        ext: '.html'
      }
    }
    sass: {
      defaultTask: {
        files: {
          'public/style.css': 'public/style.sass'
        }
      }
    }
    watch: {
      pug: {
        files: 'public/*.pug'
        tasks: ['pug']
      }
      sass: {
        files: 'public/*.sass'
        task: ['sass']
      }
      browserify: {
        files: 'client/*.coffee'
        task: ['browserify']
      }
    }
  })

  grunt.loadNpmTasks 'grunt-contrib-pug'
  grunt.loadNpmTasks 'grunt-sass'
  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'compileClient', ['browserify', 'pug', 'sass']
  grunt.registerTask 'default', ['compileClient']

  # Watch is currently broken, so we don't use it for now
  #grunt.registerTask('default', ['compile', 'watch']);
