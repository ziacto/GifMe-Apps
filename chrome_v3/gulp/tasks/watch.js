var gulp = require('gulp');
var path = require('path');
var gutil = require('gulp-util');
var config = require('../config');

gulp.task('watch', function(){
  gulp.watch('src/**/*.coffee', ['scripts']);
  gulp.watch('src/styles/**', ['styles']);
  gulp.watch('src/templates/**', ['templates']);
  gulp.watch('src/manifest.json', ['manifest']);
  gulp.watch('src/menus/context_menu.coffee', ['menus']);


  livereload = require('gulp-livereload')();
  gulp.watch(['public/*.html', 'public/js/**', 'public/css/**', 'public/images/**'], function (file) {
    var relPath = path.relative('./public', file.path);
    gutil.log('File changed: ' + gutil.colors.magenta(relPath));
    livereload.changed(file.path);
  });
});
