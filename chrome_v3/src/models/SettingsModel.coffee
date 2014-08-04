###

Copyright (c) 2014 ...

###

# Dependencies]

class SettingsModel extends Backbone.Model

	defaults:
		short_url: false || localStorage.getItem('short_url')
		oc_source: false || localStorage.getItem('oc_source')

	initialize: () =>
		@.bind('change:short_url', @update_short_url)
		@.bind('change:oc_source', @update_oc_source)

		

	update_oc_source: () =>
		console.log @get('short_url'),@get('oc_source')
		localStorage.setItem('oc_source', @get('oc_source'))

	update_short_url: () =>
		console.log @get('short_url'),@get('oc_source')
	
		localStorage.setItem('short_url', @get('short_url'))


module.exports = SettingsModel
