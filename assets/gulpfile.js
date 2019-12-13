const gulp           = require('gulp');
const webpack        = require('webpack-stream');
var postcss = require('gulp-postcss');
var autoprefixer = require('autoprefixer');
var postcssImport = require('postcss-import');
var tailwindcss = require('tailwindcss');
var postcssNested = require('postcss-nested');
var purgecss = require('@fullhuman/postcss-purgecss');
var cssnano = require('cssnano');

var isProduction = process.env.NODE_ENV === 'production';

const paths = {
  config: {
    tailwind: './tailwind.js',
    webpack:  './webpack.config.js'
  },
  src: {
    css: 'src/css/styles.css',
    js: 'src/js/index.js'
  },
  dist: {
    css:  '../public/assets/css/',
    js:   '../public/assets/js'
  }
}

var js = function() {
  return gulp.src(paths.src.js)
    .pipe(webpack(require(paths.config.webpack)))
    .pipe(gulp.dest(paths.dist.js));
}

var css = function() {
  var plugins = [
    postcssImport(),
    tailwindcss(),
    postcssNested(),
    autoprefixer(),
  ];
  if (isProduction) {
    plugins.push(
      purgecss({

        // Specify the paths to all of the template files in your project
        content: [
          '../views/**/*.mustache',
          './src/js/**/*.js',
        ],

        // Include any special characters you're using in this regular expression
        defaultExtractor: content => content.match(/[\w-/:]+(?<!:)/g) || []
      }));
  }

  plugins.push(cssnano());
  return gulp.src(paths.src.css)
    .pipe(postcss(plugins))
    .pipe(gulp.dest(paths.dist.css));
};

gulp.task('build', gulp.parallel(css, js));