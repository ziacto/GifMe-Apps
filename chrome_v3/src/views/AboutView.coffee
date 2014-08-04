###

Copyright (c) 2014 ...

###

# Dependencies

class AboutView extends Backbone.View

  #------------------------------------------------------------------------------
  #
  #  GifMe App View
  #
  #------------------------------------------------------------------------------

  initialize: =>
    @$wrapper = $("#wrapper")

    $("html,body").height(320)
    
    ## Set the welcome mat out
    @template = JST['about']()
    @$wrapper.html(@template)


module.exports = AboutView
