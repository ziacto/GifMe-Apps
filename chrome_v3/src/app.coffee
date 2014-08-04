###

Copyright (c) 2014 GifMe.io

###

# Dependencies
Env = require './env'
Utils = require './utils'
Router = require './routers/AppRouter'

# Models
AppModel = require './models/AppModel'

# Views
AppView = require './views/AppView'

class Application

  #------------------------------------------------------------------------------
  #
  #  GifMe
  #
  #------------------------------------------------------------------------------
  constructor: ->
    ## Model
    @model = new AppModel()

    _.defer(@build)

  #------------------------------------------------------------------------------
  #
  #  Assemble GifMe
  #
  #------------------------------------------------------------------------------
  build: =>
    window.location.hash = ""
    
    ## Build The App
    @app = new AppView({model: @model})

    ## App router
    @_router = new Router()
    Backbone.history.start({pushState: true})

    chrome.browserAction.setBadgeText({
      'text': ""
    });
    chrome.browserAction.setIcon({
      'path': 'images/icon_48.png'
    })

module.exports = Application

$ ->
  # instance
  GifMe.instance = new Application()

  window._gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-43186612-1'])
  _gaq.push(['_trackPageview'])