###

Copyright (c) 2014 ...

###

# Dependencies
GifView = require('./GifView')

class IndexView extends Backbone.View

  #------------------------------------------------------------------------------
  #
  #  IndexView
  #
  #------------------------------------------------------------------------------
  initialize: ->
    @$wrapper = $("#wrapper")
    @$header = $("#header")

    ## set viewport
    $("html,body").height(600)
    @$wrapper.html('<div id="content"></div>')

    $("#logo").click( =>
      GifMe.instance._router.navigate('index',{trigger: true})
    )

    @$wrapper.on('scroll', =>
      if @$wrapper.scrollTop() + $("#wrapper").height() == $("#content").height()
          @load_page()
    )
    
    _.defer(@load_page)
  
  #------------------------------------------------------------------------------
  #
  #  Load Page
  #
  #------------------------------------------------------------------------------
  load_page: =>
    @$wrapper.height(window.innerHeight - parseFloat(@$header.height()))
    
    ## Load
    GifMe.instance.app.modal.deploy('modal_loading',{ message: 'loading...' })

    ## Model Get
    @model.get_page( (data) =>

      if data.user.total == 0
        @new_user()
        GifMe.instance.app.modal.remove()

      else
        @parse_page(data)

    )

  #------------------------------------------------------------------------------
  #
  #  Parse Page Data
  #
  #------------------------------------------------------------------------------
  parse_page: (data) =>
    _.each data.users, (gif,i) =>
      g = new GifView(gif)
      g.render()

      if i == data.users.length - 1
        $("#content").append("<div class='clearfix'></div>")
        GifMe.instance.app.modal.remove()

  #------------------------------------------------------------------------------
  #
  #  Nothin found in search
  #
  #------------------------------------------------------------------------------
  none_found: =>
    

  #------------------------------------------------------------------------------
  #
  #  If a new user with no data
  #
  #------------------------------------------------------------------------------
  new_user: =>
    $("#nav-search-button").hide()
    @$wrapper.html(JST['new_user']())
    @$wrapper.height('100%')



module.exports = IndexView
