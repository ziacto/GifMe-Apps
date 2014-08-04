###

Copyright (c) 2014 ...

###

# Dependencies

class SettingsView extends Backbone.View

  #------------------------------------------------------------------------------
  #
  #  GifMe App View
  #
  #------------------------------------------------------------------------------

  initialize: =>
    @$wrapper = $("#wrapper")

    $("html,body").height(261)

    ## Set the welcome mat out
    @template = JST['settings']()
    @$wrapper.html(@template)

    $("#logout").click( =>
      GifMe.instance.app.model.log_out()
      window.location.reload(true)
    )

    $("#profile").click( =>
      window.open("https://gifme.io/u/"+GifMe.instance.app.model.get('user').url+"/0")
    )

    $("#close-settings").click( =>
      GifMe.instance._router.navigate('index',{trigger: true})
    )

    ## Short URL
    if @model.get('short_url') == "true" || @model.get('short_url') == true
      $("#shorten .switch-knob").addClass('on')
    else
      $("#shorten .switch-knob").addClass('off')

    ## OC Source
    if @model.get('oc_source') == "true" || @model.get('oc_source') == true
      $("#sources .switch-knob").addClass('on')
    else
      $("#sources .switch-knob").addClass('off')

    ## CLICKS
    $("#shorten").click( =>
      console.log @model.get('short_url')
      if @model.get('short_url') == "true" || @model.get('short_url') == true
        $("#shorten .switch-knob").removeClass('on').addClass('off')
        @model.set('short_url', false)
      else
        $("#shorten .switch-knob").removeClass('off').addClass('on')
        @model.set('short_url', true)
    )

    $("#sources").click( =>
      console.log @model.get('oc_source')

      if @model.get('oc_source') == "true" || @model.get('oc_source') == true
        $("#sources .switch-knob").removeClass('on').addClass('off')
        @model.set('oc_source', false)
      else
        $("#sources .switch-knob").removeClass('off').addClass('on')
        @model.set('oc_source', true)
    )



module.exports = SettingsView
