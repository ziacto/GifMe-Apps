###

Copyright (c) 2014 ...

###

# Dependencies

class GifDetailView extends Backbone.View

  #------------------------------------------------------------------------------
  #
  #  GifMe Detail View
  #
  #------------------------------------------------------------------------------

  initialize: (options) =>
    @$wrapper = $("#wrapper")
    @data = options.gif
    @render()

  render: =>
    ## resize
    $("html,body").height(520)

    @model.get_user()

    ## Normalize Tags and defaults
    if @data.tags.length == 0 || !@data.tags[0].tag || @data.tags[0].tag == "null"
      @data.tags = ""
    else
      @data.tags = @data.tags[0].tag

    ## Set template and append
    @template = $(JST.gif_detail(@data))
    @$wrapper.append(@template)

    ## Load Static
    @static = @data.gif.static.thumb.url
    $("#detail_large").imgur({
      img: @static
    }, (el,data) =>
      $(el).css
        'background-image': 'url('+data+')'
    )

    ## Load Animates
    @animated = @data.gif.link
    $("#detail_animated").imgur({
      img: @animated
    }, (el,data) =>
      $(el).css
        'background-image': 'url('+data+')'
      $(el).fadeIn()
    )

    if GifMe.instance.app.settingsModel.get('short_url')

      if @data.gif.short_url
        $("#detail_copy_link").val(@data.gif.short_url)
      else
        $.ajax({
          url: "https://api-ssl.bitly.com/v3/shorten?access_token=7b0e006b7db97efcf9d4b362d101f5c4dfa39153&longUrl="+@data.gif.link
          success: (data) =>
            $("#detail_copy_link").val(data.data.url)
        }) 

    #------------------------------------------------------------------------------
    #
    #  If tip
    #
    #------------------------------------------------------------------------------
    if !localStorage.getItem('drag_tip')
      GifMe.instance.app.modal.deploy('modal_copied',{ message: 'TIP: you can drag the gif to other apps'})
      localStorage.setItem('drag_tip', true)
    #------------------------------------------------------------------------------
    #
    #  Clicks
    #
    #------------------------------------------------------------------------------
    $("#detail_large").on('mousedown', =>
      $("#hidden_gif").show()
      GifMe.instance.app.modal.remove()
    )

    $("#detail_large").on('mouseup', =>
      $("#hidden_gif").hide()
      GifMe.instance.app.modal.remove()
    )

    $("#detail_copy").click( =>

      $("#detail_copy_link").focus().select()
      document.execCommand('copy')
      GifMe.instance.app.modal.deploy('modal_copied',{ message: 'copied'})
      setTimeout( =>
        GifMe.instance.app.modal.remove()
      ,900)
      _gaq.push(['_trackEvent', 'copy_link', 'clicked'])
      
    )

    $("#detail_cancel").click( =>
      @close()
    )

    $("#detail_save").click( =>
      @save()
    )

    $("#detail_tags").click( =>
      if !localStorage.getItem('tag_tip')
        GifMe.instance.app.modal.deploy('modal_copied',{ message: 'TIP: use spaces between tags'})
        localStorage.setItem('tag_tip',true)
    )

    $("#bad_thumbnail").click( =>
      GifMe.instance.app.modal.deploy('modal_loading', {message: "Repairing thumbnail"})

      @model.repair_gif(@data.gif.id, =>
        GifMe.instance.app.modal.deploy('modal_copied',{ message: 'Gif thumbnail repaired!'})

      )
    )


    $("#detail_delete").click( =>
      GifMe.instance.app.modal.deploy('modal_loading',{ message: 'deleting...' })
      $(".gif[data-slug="+@data.gif.id+"]").remove()
      @model.delete_gif(@data.gif.id, =>
        @close()
      )
    )

    $("#tweet").click( =>
      $("html,body").height(326)
      if GifMe.instance.model.get('twitter')
        @load_tweet()
      else
        @load_tweet_overview()
    )

    #------------------------------------------------------------------------------
    #
    #  Keyboard bindings
    #
    #------------------------------------------------------------------------------
    $(window).on('keyup',(e) =>
      if e.which == 13 && $("#tweet-page").length < 0
        @save()
      GifMe.instance.app.modal.remove()

      if $("#tweet-page").length > 0
        @characters = 140 - $("#tweet-box").val().length
        $("#characters").html(@characters)

        if @characters < 50 && @characters > 10
          $("#characters").addClass('caution')

        else if @characters < 10
          $("#characters").addClass('stop')

        else if @characters > 50
          $("#characters").removeClass('stop').removeClass('caution')

    )

    ## Bring in Detail
    @template.fadeIn()

  #------------------------------------------------------------------------------
  #
  #  Copy link
  #
  #------------------------------------------------------------------------------
  copy: =>

  #------------------------------------------------------------------------------
  #
  #  Close no save
  #
  #------------------------------------------------------------------------------
  close: =>
    GifMe.instance.app.modal.remove()
    $("html,body").height(600)
    $(window).off('keydown')
    @template.fadeOut( =>
      @template.remove()
    )

  #------------------------------------------------------------------------------
  #
  #  Save
  #
  #------------------------------------------------------------------------------
  save: =>
    GifMe.instance.app.modal.remove()
    @tags = $("#detail_tags").val()
    GifMe.instance.app.modal.deploy('modal_loading',{ message: 'saving...' })
    @model.update_gif(@data.gif.id, @tags, =>
      @close()
    )

  #------------------------------------------------------------------------------
  #
  #  Delete
  #
  #------------------------------------------------------------------------------
  delete: =>

  #------------------------------------------------------------------------------
  #
  #  Load Tweet
  #
  #------------------------------------------------------------------------------
  load_tweet: () =>
    @$tweet = $(JST.tweet(@data))
    @$wrapper.append(@$tweet)

    @characters = 140 - $("#tweet-box").val().length
    $("#characters").html(@characters)

    $("#tweet-box").focus()

    $("#tweet-it-nevermind").click( (event) =>
      event.preventDefault()
      $("#tweet-page").fadeOut( =>
        $("#tweet-page").remove()
      )
      $("html,body").height(486)

    )

    $("#tweet-it").click( (event) =>
      event.preventDefault()
      if 140 - $("#tweet-box").val().length >= 0
        tweet = {
          message: $("#tweet-box").val()
          gif: @data.gif.link
          user: @model.get('user_id')
        }
        GifMe.instance.app.modal.deploy('modal_loading', {message: "Posting Tweet..."})
        
        GifMe.instance.model.post_tweet(tweet, (data) =>
          GifMe.instance.app.modal.deploy('modal_copied', {message: 'Tweet Posted!'})
          $("#tweet-page").fadeOut( =>
            $("#tweet-page").remove()
          )
          $("html,body").height(486)

        )
      else
        GifMe.instance.app.modal.deploy('modal_sad', {message: 'Too many characters!'})
    )


  load_tweet_overview: () =>
    @$overview = $(JST.tweet_overview())
    @$wrapper.append(@$overview)

    $("#nevermind-twitter").click( (event) =>
      event.preventDefault()
      $("#tweet-overview").fadeOut( =>
        $("#tweet-overview").remove()
      )
      $("html,body").height(486)

    )

module.exports = GifDetailView
