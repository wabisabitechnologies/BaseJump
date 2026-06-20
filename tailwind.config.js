/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./app/**/*.html.erb",
    "./app/**/*.js",
    "./app/**/*.jsx",
    "./frontend/**/*.js",
    "./frontend/**/*.jsx",
    "./src/**/*.js",
    "./src/**/*.jsx",
    "./ui-src/**/*.js",
    "./ui-src/**/*.jsx",
  ],
  theme: {
    extend: {
      colors: {
        landing: {
          blue: '#007BB6',
          dark: '#283C46',
        },
        // you can add more as needed
      },
      fontFamily: {
        sans: ['Noto Sans', 'sans-serif'],
        serif: ['Noto Serif', 'serif'],
      },
    },
  },
  plugins: [],
}
