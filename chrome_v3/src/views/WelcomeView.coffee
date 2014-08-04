###

Copyright (c) 2014 ...

###

# Dependencies

class WelcomeView extends Backbone.View

  #------------------------------------------------------------------------------
  #
  #  GifMe App View
  #
  #------------------------------------------------------------------------------

  initialize: =>
    @$wrapper = $("#wrapper")

    ## Size the window
    $("html,body").height(200)

    ## Set the welcome mat out
    @template = JST['welcome']()
    @$wrapper.html(@template)

    #------------------------------------------------------------------------------
    #
    # Bind All Buttons
    #
    #------------------------------------------------------------------------------
    $(".button").on('click', (event) ->
      event.preventDefault()
      url = $(@).attr('href')

      GifMe.instance._router.navigate(url,{trigger: true})
    )

module.exports = WelcomeView
