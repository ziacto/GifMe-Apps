var browserify = require('browserify');
var gulp = require('gulp');
var handleErrors = require('../util/handleErrors');
var source = require('vinyl-source-stream');

gulp.task('manifest', function(){
	gulp.src('./src/manifest.json')
    .pipe(gulp.dest('./public'))
    .pipe(gulp.dest('./dist'));
});
