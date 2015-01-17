gulp          = require 'gulp'
messageformat = require 'gulp-messageformat'
{log, colors} = require 'gulp-util'
handleErrors  = require '../util/handleErrors'
config        = require '../config'

gulp.task 'messageformat', (callback) ->

  queue = Object.keys(config.messageformat).length if config.messageformat

  return callback() unless queue

  compile = (locale, config) ->
    gulp.src config.src
      .pipe messageformat { locale }
      .on 'error', handleErrors
      .pipe gulp.dest config.dest
      .on 'end', ->
        log "Compiled locale '#{colors.green(locale)}'"
        queue--
        callback() if queue is 0

  compile locale, config for locale, config of config.messageformat
