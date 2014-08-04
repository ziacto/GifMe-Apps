###

Copyright (c) 2014 ...

###

# Dependencies
GifView = require('./GifView')

class SearchView extends Backbone.View

  #------------------------------------------------------------------------------
  #
  #  SearchView
  #
  #------------------------------------------------------------------------------
  initialize: ->
    @$wrapper = $("#wrapper")
    @$header = $("#header")

    ## set viewport
    $("html,body").height(600)

    @$wrapper.html('<div id="content"></div>')

    $("#logo").click( =>
      window.location.reload(true)
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
    @parse_page(@model.get('search_results'))

  #------------------------------------------------------------------------------
  #
  #  Parse Page Data
  #
  #------------------------------------------------------------------------------
  parse_page: (data) =>
    
    if data.user.total == 0
      @$wrapper.html('<div id="content"><div class="page"><h1>You don\'t have any gifs tagged with that!</h1><br/><a href="https://gifme.io/search/q/'+@model.get('search_term')+'/0" target="_blank">Search on GifMe.io</a></div></div>')
      GifMe.instance.app.modal.remove()
    else

      _.each data.users, (gif,i) =>
        g = new GifView(gif)
        g.render()

        if i == data.users.length - 1
          console.log 'appennnd'
          $("#content").append("<div class='clearfix'></div>")

          GifMe.instance.app.modal.remove()
          setTimeout( =>
            if !localStorage.getItem('tip_search')
              GifMe.instance.app.modal.tooltip_deploy('#open-search',{x: 86, y: 40, el: 'open-search', message: 'TIP: click to open search on web'})
              setTimeout( =>
                  GifMe.instance.app.modal.tooltip_remove()
                  localStorage.setItem('tip_search', true)
              ,3500)
          ,900)

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



module.exports = SearchView
