var browserify = require('browserify');
var gulp = require('gulp');
var handleErrors = require('../util/handleErrors');
var source = require('vinyl-source-stream');

gulp.task('menus', function(){
  	browserify({
      entries: ['./src/menus/context_menu.coffee'],
      extensions: ['.coffee']
    })
    .bundle({debug: true})
    .on('error', handleErrors)
    .pipe(source('context_menu.js'))
    .pipe(gulp.dest('./public'))
    .pipe(gulp.dest('./dist'));

    gulp.src('./public/vendor/jquery/dist/jquery.js')
    .pipe(gulp.dest('./public/js'))
    .pipe(gulp.dest('./dist/js'));
});
