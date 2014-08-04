var gulp = require('gulp');

gulp.task('build',['copy', 'templates', 'scripts', 'menus', 'styles'], function() {
  gulp.start('usemin');
});