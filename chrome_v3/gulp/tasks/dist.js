var gulp = require('gulp');

gulp.task('dist', ['clean'], function() {
  gulp.start('build');
  gulp.start('manifest');
  gulp.start('menus');
});