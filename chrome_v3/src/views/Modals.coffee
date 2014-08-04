###

Copyright (c) 2014 ...

###

# Dependencies

class Modals extends Backbone.View

  #------------------------------------------------------------------------------
  #
  #  Modals
  #
  #------------------------------------------------------------------------------
  initialize: ->
    @$body = $('body')

  #------------------------------------------------------------------------------
  #
  #  Deploy
  #  @modal - reference to modal to show
  #
  #------------------------------------------------------------------------------
  deploy: (modal,data) =>
    @data = data
    @modal = $(JST[modal]( @data ))

    ## append
    @$body.append( @modal )
    setTimeout( ->
      $(".modal").css
        top: 0
    ,0)

  #------------------------------------------------------------------------------
  #
  #  ToolTip Deploy
  #  @data - The message to display
  #  @el - element to point to
  #  @direction - Direction to point
  #
  #------------------------------------------------------------------------------
  tooltip_deploy: (el, data) =>
    @data = data
    @tooltip = $(JST['tooltip'](@data))
    console.log $(el).position().top,$(el).position().left

    @$body.append( @tooltip )
    @tooltip.css
      top: data.y
      left: data.x

  #------------------------------------------------------------------------------
  #
  #  Remove
  #
  #------------------------------------------------------------------------------
  remove: =>
    $(".modal").css
      top: "-150px"

    setTimeout( ->
      $(".modal").remove()
    ,900)
    
  tooltip_remove: =>
    setTimeout( ->
      $(".tooltip").remove()
    ,900)

module.exports = Modals
