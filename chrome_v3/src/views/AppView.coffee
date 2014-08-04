###

Copyright (c) 2014 ...

###

# Dependencies
Nav = require './NavView'
WelcomeView = require './WelcomeView'
SignUpView = require './SignUpView'
SignInView = require './SignInView'
IndexView = require './IndexView'
IndexView = require './IndexView'
SearchView = require './SearchView'
GifDetailView = require './GifDetailView'
SettingsView = require './SettingsView'
AboutView = require './AboutView'
Modals = require './Modals'
SettingsModel = require '../models/SettingsModel'

class AppView extends Backbone.View

  #------------------------------------------------------------------------------
  #
  #  GifMe App View
  #
  #------------------------------------------------------------------------------
  initialize: =>
    
    ## DOM
    @$wrapper = $("#wrapper")
    @$header = $("#header")
    @$menu = $("#menu")

    ## Modals
    @modal = new Modals()

    ## Model Bindings
    @model.bind('change:user_id', @ready)
    @model.bind('change:error', @error)
    @model.bind('change:search_term', @update_search)

    # check user
    @model.get_user()

    @settingsModel = new SettingsModel()
    @settingsModel.initialize()

  #------------------------------------------------------------------------------
  #
  #  An Error Happened Things are fucked
  #
  #------------------------------------------------------------------------------
  error: =>
    GifMe.instance.app.modal.deploy('modal_sad',{ message: 'GifMe has a major update! Please update!'})

  #------------------------------------------------------------------------------
  #
  #  Model is ready
  #
  #------------------------------------------------------------------------------
  ready: =>
    ## if user_id is 0 sign in or up
    if @model.get('user_id') == 0
      @welcome()
      # @sign_up()
    else
      GifMe.instance._router.navigate('index',{trigger: true})

  #------------------------------------------------------------------------------
  #
  #  Search Term
  #
  #------------------------------------------------------------------------------
  update_search: =>
    $("#open-search").off('click')
    
    if @model.get('search_term') != '' && @model.get('user').url
      $("#open-search").show()
      $("#open-search").on('click', =>
        window.open("http://gifme.io/u/"+@model.get("user").url+"/search/"+@model.get('search_term')+"/0")
      )
    else
      $("#open-search").hide()

  #------------------------------------------------------------------------------
  #
  #  Signed in user
  #
  #------------------------------------------------------------------------------
  index: =>

    if localStorage.getItem('version') != '3.1.0'
      _gaq.push(['_trackEvent', 'updated', '3.1.0'])

      $("#overlay").show()
      localStorage.setItem('version','3.1.0')

      $("#close-button").click( =>
        $("#overlay").hide()
      )

    ## Nav
    @nav = new Nav({model: @model})
    @view = new IndexView({model: @model})


  #------------------------------------------------------------------------------
  #
  #  Settings
  #
  #------------------------------------------------------------------------------
  settings: =>
    @view = new SettingsView({ model: @settingsModel })

  #------------------------------------------------------------------------------
  #
  #  GoTo gifs
  #
  #------------------------------------------------------------------------------
  go_to: =>

  #------------------------------------------------------------------------------
  #
  #  About
  #
  #------------------------------------------------------------------------------
  about: =>
    @view = new AboutView({ model: @model })

  #------------------------------------------------------------------------------
  #
  #  Welcome
  #
  #------------------------------------------------------------------------------
  welcome: =>
    @view = new WelcomeView()

  #------------------------------------------------------------------------------
  #
  #  Sign Up
  #
  #------------------------------------------------------------------------------
  sign_up: =>
    @view = new SignUpView({model: @model})

  #------------------------------------------------------------------------------
  #
  #  Sign In
  #
  #------------------------------------------------------------------------------
  sign_in: =>
    @view = new SignInView({model: @model})

  #------------------------------------------------------------------------------
  #
  #  Detail
  #
  #------------------------------------------------------------------------------
  detail: (id) =>

    @model.load_detail(id, (data) =>
      @view = new GifDetailView({model: @model, gif: data})
    )

  #------------------------------------------------------------------------------
  #
  #  Search
  #
  #------------------------------------------------------------------------------
  search: () =>
    @view = new SearchView({ model: @model})


module.exports = AppView
