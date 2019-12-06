
var gulp = require('gulp');
var postcss = require('gulp-postcss');
var autoprefixer = require('autoprefixer');
var postcssImport = require('postcss-import');
var tailwindcss = require('tailwindcss');
var postcssNested = require('postcss-nested');
var purgecss = require('@fullhuman/postcss-purgecss');
var cssnano = require('cssnano');

var isProduction = process.env.NODE_ENV === 'production';

function clientCSS() {
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
          '../views/**/*.mustache'
        ],

        // Include any special characters you're using in this regular expression
        defaultExtractor: content => content.match(/[\w-/:]+(?<!:)/g) || []
      }));
  }

  plugins.push(cssnano());
  return gulp.src('./src/client.css')
    .pipe(postcss(plugins))
    .pipe(gulp.dest('../public/assets/css/'));
};

function adminCSS() {
  var plugins = [
    postcssImport(),
    tailwindcss(),
    postcssNested(),
    autoprefixer(),
  ];
  if (isProduction) {
    plugins.push(purgecss({

      // Specify the paths to all of the template files in your project
      content: [
        '../aiwiki-admin/src/**/*.jsx',
        '../aiwiki-admin/public/index.html'
      ],

      // Include any special characters you're using in this regular expression
      defaultExtractor: content => content.match(/[\w-/:]+(?<!:)/g) || []

    }));
  }
  return gulp.src('./src/admin.css')
    .pipe(postcss(plugins))
    .pipe(gulp.dest('../aiwiki-admin/src/'));
};
exports.clientCSS = clientCSS;
exports.adminCSS = adminCSS;
exports.default = gulp.parallel(clientCSS, adminCSS);
