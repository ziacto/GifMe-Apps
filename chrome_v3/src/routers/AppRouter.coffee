###

Copyright (c) 2014 ...

###

class AppRouter extends Backbone.Router

  routes:
    "index"             : "index"
    "settings"          : "settings"
    "go-to"             : "go_to"
    "about"             : "about"
    "sign-up"           : "sign_up"
    "sign-in"           : "sign_in"
    "welcome"           : "welcome"
    "register"          : "register"
    "login"             : "login"
    "view/:id"          : "view"
    "search-results"    : "search"


  index: =>
    GifMe.instance.app.model.set('search_term','')
  
    @clear_route()
    console.log "Loading Index"
    GifMe.instance.app.index()
    

  settings: =>
    GifMe.instance.app.model.set('search_term','')
    @clear_route()
    console.log "Loading Settings"
    GifMe.instance.app.settings()
    

  go_to: =>
    GifMe.instance.app.model.set('search_term','')

    @clear_route()
    console.log "Loading GoTo"
    GifMe.instance.app.go_to()
    

  about: =>
    GifMe.instance.app.model.set('search_term','')

    @clear_route()
    console.log "Loading About"
    GifMe.instance.app.about()
    

  welcome: =>
    @clear_route()
    console.log "Loading Welcome"
    GifMe.instance.app.welcome()
    

  sign_up: =>
    @clear_route()
    console.log "Loading Sign Up"
    GifMe.instance.app.sign_up()
    

  register: =>
    @clear_route()
    console.log "Loading Register"
    GifMe.instance.app.view.register()
    

  sign_in: =>
    @clear_route()
    console.log "Loading Sign in"
    GifMe.instance.app.sign_in()
    

  login: =>
    @clear_route()
    console.log "Logging In"
    GifMe.instance.app.view.login()
    

  view: (id) =>
    @clear_route()
    console.log "loading: "+id
    GifMe.instance.app.detail(id)
    

  search: () =>
    @clear_route()
    console.log "loading Search"
    GifMe.instance.app.search()
    

  clear_route: =>
    $("#wrapper").off('scroll')
    GifMe.instance._router.navigate("/index.html",{trigger: true})

    scrollDiv = document.createElement("div")
    scrollDiv.className = "scrollbar-measure"
    document.body.appendChild(scrollDiv)
    scrollbarWidth = scrollDiv.offsetWidth - scrollDiv.clientWidth;
    document.body.removeChild(scrollDiv)
    $("body,html,#wrapper").width(320 + scrollbarWidth)


module.exports = AppRouter
