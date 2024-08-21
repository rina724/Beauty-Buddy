module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      fontFamily: {
        abril: "Abril Fatface",
        gen: "Gen Jyuu GothicX"
      },
    },
    colors: {
      'cream': '#FFFBEC',
      'beige': '#EDDDC5',
      'mint': '#94D0BF',
      'yellow': '#FFE567'
    },
  },
  plugins: [require("daisyui")],
  daisyui: {
    themes: [
      {
        mytheme: { 
          "primary": "#a991f7",
          "secondary": "#f6d860",
          "accent": "#37cdbe",
          "neutral": "#3d4451",
          "base-100": "#ffffff",
          }
      }
    ]
  }
}
