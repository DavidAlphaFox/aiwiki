const purgecss = [
  "@fullhuman/postcss-purgecss",
  {
    content: ["./components/**/*.jsx", "./pages/**/*.jsx"],
    defaultExtractor: content => content.match(/[\w-/:]+(?<!:)/g) || []
  }
];
module.exports = {
  plugins: [
    "postcss-import",
    "tailwindcss",
    "postcss-nested",
    "autoprefixer",
    ...(process.env.NODE_ENV === "production" ? [purgecss] : [])
  ]
};
