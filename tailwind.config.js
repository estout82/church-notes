module.exports = {
  mode: "jit",
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/presenters/**/*.rb",
    "./app/javascript/**/*.js",
    "./app/javascript/**/*.jsx",
    "./app/javascript/**/*.ts",
    "./app/javascript/**/*.tsx"
  ],
  theme: {
    fontFamily: {
      sans: ["Open Sans", "Inter", "sans-serif"]
    },
    extend: {
      colors: {
        primary: "#7986cb",
        secondary: "#e5e5e5",
        fill: "#ffffff",
        muted: "#808091",
        input: "#F5F6FA",
        dark: "#808091",
        default: "#000000",
        error: "#CB7979",
        success: "#49b36c",
        info: "#52bdfa"
      },
      minWidth: {
        "screen": "100vw"
      },
      minHeight: {
        "input": "35px"
      },
      spacing: {
        "128": "32rem",
        "256": "64rem"
      },
      boxShadow: {
        "box": "0px 2px 7px rgba(0, 0, 0, .15)"
      }
    }
  },
  plugins: [
    require("@tailwindcss/typography"),
    require("@tailwindcss/line-clamp")
  ]
};
