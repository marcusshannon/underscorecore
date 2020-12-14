const colors = require("tailwindcss/colors");

module.exports = {
  purge: {
    content: [
      "../lib/underscorecore_web/templates/**/*.html.eex",
      "../lib/underscorecore_web/templates/**/*.html.leex",
    ],
  },
  theme: {
    colors: {
      ...colors,
      gray: colors.gray,
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/aspect-ratio"),
  ],
};
