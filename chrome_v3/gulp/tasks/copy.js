var gulp = require('gulp');

gulp.task('copy', function() {
  gulp.src('public/images/**/*')
  	.pipe(gulp.dest('dist/images/'));
  gulp.src('src/styles/fonts/**/*')
  	.pipe(gulp.dest('dist/styles/fonts'))
  	.pipe(gulp.dest('public/css/fonts'));
});