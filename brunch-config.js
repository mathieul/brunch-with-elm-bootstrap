// brunch-config.js
module.exports = {
  files: {
    javascripts: {joinTo: 'js/app.js'},
    stylesheets: {joinTo: 'css/app.css'}
  },

  plugins: {
    elmBrunch: {
      mainModules: ['app/elm/Main.elm'],
      outputFolder: 'public/js',
      /* '--debug' parameter activates Elm 0.18 history debugger */
      makeParameters: '--debug'
    },
    sass: {
      options: {
        includePaths: [
          'node_modules/bootstrap/scss'
        ]
      }
    }
  },
  overrides: {
    production: {
      plugins: {
        elmBrunch: {
          makeParameters: []
        }
      }
    }
  }
}
