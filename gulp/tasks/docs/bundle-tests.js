var mocha        = require('gulp-mocha');
var gutil        = require('gulp-util');
var browserify   = require('browserify');
var watchify     = require('watchify');
var bundleLogger = require('../../util/bundleLogger');
var gulp         = require('gulp');
var handleErrors = require('../../util/handleErrors');
var source       = require('vinyl-source-stream');
var todo         = require('gulp-todos');

gulp.task('docs:bundle-tests', function() {
  var bundler = browserify({
    // Required watchify args
    cache: {}, packageCache: {}, fullPaths: true,
    // Specify the entry point of your app
    entries: ['./lib-docs/coffee/tests.coffee'],
    // Add file extentions to make optional in your requires
    extensions: ['.coffee'],
    // Enable source maps!
    debug: true
  });

  var bundle = function() {
    // Log when bundling starts
    bundleLogger.start();
    return bundler
      .bundle()
      // Report compile errors
      .on('error', handleErrors)
      // Use vinyl-source-stream to make the
      // stream gulp compatible. Specifiy the
      // desired output filename here.
      // Specify the output destination
      .pipe(source('test.js'))
      .pipe(gulp.dest('./docs/js/'))
      // Log when bundling completes!
      .on('end', bundleLogger.end);
  };

  if(global.isWatching) {
    bundler = watchify(bundler);
    // Rebundle with watchify on changes.
    bundler.on('update', bundle);
  }

  return bundle();
});
