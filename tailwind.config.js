module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
  ],
  theme: {
    extend: {
      fontFamily: {
        abril: "Abril Fatface",
        gen: "Gen Jyuu GothicX",
      },
    },
    colors: {
      'cream': '#FFFBEC',
      'beige': '#EDDDC5',
      'mint': '#94D0BF',
      'yellow': '#FFE567',
      'gray': '#f3f4f6',
      'green': '#86efac',
      'red': '#fca5a5',
    },
  },
  plugins: [require("daisyui")],
};
