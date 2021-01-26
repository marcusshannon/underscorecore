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
      black: colors.black,
      white: colors.white,
      gray: colors.trueGray,
      red: colors.red,
      blue: colors.blue,
    },
    extend: {
      typography: (theme) => ({
        DEFAULT: {
          css: [
            {
              color: theme("colors.gray.400"),
              '[class~="lead"]': {
                color: theme("colors.gray.300"),
              },
              a: {
                color: theme("colors.white"),
              },
              strong: {
                color: theme("colors.white"),
              },
              "ol > li::before": {
                color: theme("colors.gray.400"),
              },
              "ul > li::before": {
                backgroundColor: theme("colors.gray.600"),
              },
              hr: {
                borderColor: theme("colors.gray.200"),
              },
              blockquote: {
                color: theme("colors.gray.200"),
                borderLeftColor: theme("colors.gray.600"),
              },
              h1: {
                color: theme("colors.white"),
              },
              h2: {
                color: theme("colors.white"),
              },
              h3: {
                color: theme("colors.white"),
              },
              h4: {
                color: theme("colors.white"),
              },
              "figure figcaption": {
                color: theme("colors.gray.400"),
              },
              code: {
                color: theme("colors.white"),
              },
              "a code": {
                color: theme("colors.white"),
              },
              pre: {
                color: theme("colors.gray.200"),
                backgroundColor: theme("colors.gray.800"),
              },
              thead: {
                color: theme("colors.white"),
                borderBottomColor: theme("colors.gray.400"),
              },
              "tbody tr": {
                borderBottomColor: theme("colors.gray.600"),
              },
            },
          ],
        },
      }),
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/aspect-ratio"),
    ({ addUtilities, theme, e }) => {
      const grayColors = theme("colors.gray");

      const textDecorationUtilities = Object.entries(grayColors).map(
        ([name, value]) => {
          return {
            [`.${e(`text-decoration-gray-${name}`)}`]: {
              textDecorationColor: value,
            },
          };
        }
      );
      addUtilities(textDecorationUtilities, {
        variants: ["hover"],
      });
    },
  ],
};
