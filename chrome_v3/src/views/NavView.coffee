###

Copyright (c) 2014 ...

###

# Dependencies

class NavView extends Backbone.View

	initialize: ->
		@$window = $(window)
		@$search_icon = $("#nav-search-button")
		@$search_area = $("#search-area")
		@$search_input = $("#search")
		@$menu_button = $("#menu-button")
		@$menu = $("#menu")
		@$nav_button = $("#menu .menu-button")

		@render()

	render: =>
		_this = @
		$("#header").show()
		
		#------------------------------------------------------------------------------
		#
		#	Bind Search Icon
		#
		#------------------------------------------------------------------------------
		@$search_icon.click( =>
			@$search_area.addClass 'open'
			@$search_input.focus()
		)

		#------------------------------------------------------------------------------
		#
		#	Bind Input Blur
		#
		#------------------------------------------------------------------------------
		@$search_input.on( 'blur', =>
			@$search_area.removeClass 'open'
		)

		#------------------------------------------------------------------------------
		#
		#	Bind keyboard event
		#
		#------------------------------------------------------------------------------
		@$search_input.on('focus', =>
			GifMe.instance.app.model.set('search_term','')
			@$window.on('keydown', (event) =>
				if @$search_area.hasClass('open') && @$search_input.val() != "" && event.which == 13
					
					@$search_input.blur()
					@$window.off('keydown')
					@model.search( @$search_input.val(), (data) =>

						@$search_input.val('')
						GifMe.instance._router.navigate('/search-results', {trigger: true})
					)
				)
		)

		#------------------------------------------------------------------------------
		#
		#	Bind Menu Button
		#
		#------------------------------------------------------------------------------
		@$menu_button.click( =>
			@$menu_button.toggleClass 'open'
			@$menu.toggleClass 'open'
			@$menu_button.toggleClass 'icon-cross'
		)

		$("#upload").click( =>
			window.open('https://gifme.io/upload')
		)

		#------------------------------------------------------------------------------
		#
		#	Bind Nav Buttons
		#
		#------------------------------------------------------------------------------
		@$nav_button.click( (event) ->

			event.preventDefault();
			url = $(@).attr('href')
			GifMe.instance._router.navigate(url,{trigger: true})

			_this.$menu_button.toggleClass 'open'
			_this.$menu.toggleClass 'open'
			_this.$menu_button.toggleClass 'icon-cross'
		)

	toggle_drawer: =>


module.exports = NavView
