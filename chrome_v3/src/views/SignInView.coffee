###

Copyright (c) 2014 ...

###

# Dependencies

class SignInView extends Backbone.View

  #------------------------------------------------------------------------------
  #
  #  GifMe App View
  #
  #------------------------------------------------------------------------------

  initialize: =>
    @$wrapper = $("#wrapper")

    ## Size the window
    $("html,body").height(243)

    ## Set the welcome mat out
    @template = JST['sign-in']()
    @$wrapper.html(@template)

    #------------------------------------------------------------------------------
    #
    # Bind All Buttons
    #
    #------------------------------------------------------------------------------
    $(".button").not('.external').on('click', (event) ->
      event.preventDefault()
      url = $(@).attr('href')

      GifMe.instance._router.navigate(url,{trigger: true})
    )
    
    #------------------------------------------------------------------------------
    #
    #  Bind Keystrokes
    #
    #------------------------------------------------------------------------------
    $("#name,#password").on('blur', ->
      if $(@).val() != ""
        $(@).addClass('verified')
    )

  login: =>
    if $("#name").val() != ""
      if $("#password").val() != ""
        GifMe.instance.app.modal.deploy('modal_loading',{message: "Logging in..."})

        @model.login( $("#name").val(), $("#password").val() ,( message ) =>
          if message == 401
            @failure("Uh Oh! Bad Username or Password")
          else if message == 404
            @failure("Uh Oh! No Account!")
          else
            GifMe.instance.app.modal.remove()
        )

      else
        @failure("missing password!")
    else
      @failure("missing user name!")

  failure: (message) =>
    GifMe.instance.app.modal.deploy('modal_sad',{message: message})
      
    setTimeout( ->
      GifMe.instance.app.modal.remove()
      GifMe.instance._router.navigate('sign-in')
    ,1500)

module.exports = SignInView
