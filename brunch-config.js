// brunch-config.js
module.exports = {
  files: {
    javascripts: {joinTo: 'js/app.js'},
    stylesheets: {joinTo: 'css/app.css'}
  },

  plugins: {
    babel: {
      presets: ['es2015']
    },
    elmBrunch: {
      mainModules: ['app/elm/Main.elm'],
      outputFolder: 'public/js'
    },
    sass: {
      options: {
        includePaths: [
          'node_modules/bootstrap/scss'
        ]
      }
    }
  }
}
