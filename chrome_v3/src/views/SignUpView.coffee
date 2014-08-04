###

Copyright (c) 2014 ...

###

# Dependencies

class SignUpView extends Backbone.View

  #------------------------------------------------------------------------------
  #
  #  GifMe App View
  #
  #------------------------------------------------------------------------------

  initialize: =>
    @$wrapper = $("#wrapper")

    ## Size the window
    $("html,body").height(260)

    ## Set the welcome mat out
    @template = JST['sign-up']()
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

    #------------------------------------------------------------------------------
    #
    #  Bind Keystrokes
    #
    #------------------------------------------------------------------------------
    $("#name,#password").on('blur', ->
      if $(@).val() != ""
        $(@).addClass('verified')
    )

  register: =>
    if $("#name").val() != ""
      if $("#password").val() != ""
        GifMe.instance.app.modal.deploy('modal_loading',{message: "creating an account..."})

        @model.create_user( $("#name").val(), $("#password").val() ,( message ) =>
          if message == 501
            @failure("username already in use")
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
      GifMe.instance._router.navigate('sign-up')
    ,1500)

module.exports = SignUpView
