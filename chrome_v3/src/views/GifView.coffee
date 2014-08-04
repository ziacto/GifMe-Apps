###

Copyright (c) 2014 ...

###

# Dependencies

class GifView extends Backbone.View

	initialize: (data) =>
		@$wrapper = $("#content")
		@data = data
		@animated = data.link
		@static = data.static.static.thumb.url
		@id = data.id

	render: =>
		@template = $(JST.gif(@data))
		@animation_div = @template.children('.animated')
		@$wrapper.append(@template)
		@$maximize = @template.children('.overlay').children('.options').children('.icon-maximize')
		@$copy = @template.children('.overlay').children('.options').children('.icon-link')

		@$maximize.on 'click', () ->
			GifMe.instance._router.navigate('#view/'+$(this).data('slug'),{trigger: true})
			_gaq.push(['_trackEvent', 'edit_page', 'clicked'])

		if GifMe.instance.app.settingsModel.get('short_url')

			if @data.short_url
		        @template.children('.meta').children('input').val(@data.short_url)
		    else
				$.ajax({
			        url: "https://api-ssl.bitly.com/v3/shorten?access_token=7b0e006b7db97efcf9d4b362d101f5c4dfa39153&longUrl="+@data.link
			        success: (data) =>
			          @template.children('.meta').children('input').val(data.data.url)
			      }) 

		@$copy.on 'click', () =>
			@template.children('.meta').children('input').focus().select()
			document.execCommand('copy')
			GifMe.instance.app.modal.deploy('modal_copied',{ message: 'copied'})
			setTimeout( =>
				GifMe.instance.app.modal.remove()
			,900)
			_gaq.push(['_trackEvent', 'copy_link_short', 'clicked'])

		setTimeout( =>
			@template.imgur({
				img: @static
			}, (el,data) =>
				$(el).animate(
					opacity: 0
				,0)
				
				setTimeout( =>
					$(el).css
						'background-image': 'url('+data+')'
						'background-size': 'cover'
						opacity: 1

					@template.hover( =>
						@animation_div.imgur({
							img: @animated
						}, (el,data) =>
							$(el).css
								'background-image': 'url('+data+')'
							@animation_div.show()
						)
					, =>
						@animation_div.hide()
					)
					
				,350)
				
			)
		,350)

		#------------------------------------------------------------------------------
		#
		#	Copy link
		#
		#------------------------------------------------------------------------------
		@template.children('')

module.exports = GifView
