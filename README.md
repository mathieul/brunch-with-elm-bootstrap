# Brunch + Elm 0.17 + Sass + Bootstrap 4 #

This is an [Elm](http://elm-lang.org) application skeleton for [Brunch](http://brunch.io).
It comes setup with Babel, Sass and Bootstrap 4.

You can use it with [Brunch](http://brunch.io) to generate a new application or follow the instructions to do it manually.

## Installation ##

Clone is repo manually or use `brunch new dir -s mathieul/brunch-with-elm-bootstrap`

## Getting Started ##

* Install (if you don't have them):
    * [Node.js](http://nodejs.org): `brew install node` on OSX
    * [Brunch](http://brunch.io): `npm install -g brunch`
    * [Elm](http://elm-lang.org): `brew install elm` on OSX
    * Brunch plugins and app dependencies: `npm install`
* Run:
    * `brunch watch --server` — watches the project with continuous rebuild. This will also launch HTTP server with [pushState](https://developer.mozilla.org/en-US/docs/Web/Guide/API/DOM/Manipulating_the_browser_history).
    * `brunch build --production` — builds minified project for production
* Learn:
    * Place Elm files in `app/elm/` and JavaScript files in `app/js/`.
    * `public/` dir is fully auto-generated and served by HTTP server.  Write your code in `app/` dir.
    * Place static files you want to be copied from `app/assets/` to `public/`.
    * Place Sass files in `app/scss/`, they will compile to `public/css/`.
    * [Brunch site](http://brunch.io), [Getting started guide](https://github.com/brunch/brunch-guide#readme)

## Or Do It Yourself ##

You can also start from a brunch ES6 generated application and set it up manually to understand how each component work.

Follow the steps below:

    $ brunch new my-app -s es6
    $ cd my-app
    $ echo "\n# Elm files\nelm-stuff/" >> .gitignore

Let's make sure it all works:

    $ brunch watch --server

and open `http://localhost:3333` in a new browser window. Open the developer tools
and make sure you see the `Initialized app` message in the web console.

Let's add Sass and Bootstrap (4.0.0-alpha.2 at the moment of this writing):

    $ npm install bootstrap@4.0.0-alpha.2 --save-dev
    $ npm install sass-brunch --save-dev

And setup Elm for our new app:

    $ npm install elm-brunch --save-dev
    $ elm package install elm-lang/html -y

We update the `elm-package.json` file to list the directory intended to contain our application Elm files as a dependency:

    [...]
      "source-directories": [
          ".",
          "app/elm"
      ],
    [...]

We replace the content of `brunch-config.js` to tell Brunch about Elm and Sass:

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

Now let's add a bit of structure to the project:

    $ mkdir app/js app/scss app/elm
    $ mv app/initialize.js app/js/
    $ echo '@import "bootstrap";' > app/scss/application.scss

And edit `index.html` to change the files to include:

    [...]
      <title>Brunch with ES6</title>
      <link rel="stylesheet" href="css/app.css" charset="utf-8">
    </head>
    <body>
      <div id="elm-main"></div>

      <script src="js/main.js"></script>
      <script src="js/app.js"></script>
      <script>require('js/initialize');</script>
    </body>
    </html>

Now we need to initialize our Elm application with:

    // app/js/initialize.js
    document.addEventListener('DOMContentLoaded', () => {
      const elmNode = document.getElementById('elm-main')
      Elm.Main.embed(elmNode)
    })

and start with a basic Elm application:

    -- app/elm/Main.elm
    module Main exposing (main)

    import Html exposing (div, h1, text)
    import Html.Attributes exposing (class)


    main =
        div [ class "jumbotron" ]
            [ h1 []
                [ text "Hello Elm 0.17" ]
            ]

and finally we open `http://localhost:3333` in a new browser window. We should see our message rendered by `Main.elm`.
