###

Copyright (c) 2014 ...

###

# Dependencies]

class AppModel extends Backbone.Model

	defaults:
		user_id: null
		user: null
		twitter: false
		# url: 'http://0.0.0.0:3000'
		url: 'http://166.78.184.106'
		current_page: 0
		search_results: []
		search_term: ''

	#------------------------------------------------------------------------------
	#
	#	Log Out
	#
	#------------------------------------------------------------------------------
	log_out: =>
		chrome.storage.sync.remove('gifme_uuid')
		chrome.storage.sync.remove('user')
		localStorage.clear()

	#------------------------------------------------------------------------------
	#
	#	Get The User
	#
	#------------------------------------------------------------------------------
	get_user: =>
		chrome.storage.sync.get({'gifme_uuid','user','twitter'}, @set_user_id )

	#------------------------------------------------------------------------------
	#
	#	Set the user
	#
	#------------------------------------------------------------------------------
	set_user_id: (data) =>
		if data.user != "user"
			@set({
				user_id: data.gifme_uuid
				user: data.user
				twitter: data.twitter
			})
			$.ajax({
				url: @get('url')+"/user/"+@get('user').id+"/stats"
				type: "GET"
				success: (data) =>
					@get('user').url = data.meta.url
					@set('twitter', data.user.twitter)
					chrome.storage.sync.set({
						'twitter': data.user.twitter
					})
			})
		else
			@set({
				user_id: 0
				user: null
				twitter: false
			})

	#------------------------------------------------------------------------------
	#
	#	Create User
	#
	#------------------------------------------------------------------------------
	create_user: (username, pass, callback) =>

		$.ajax({
			url: @get('url')+"/user/create_new"
			type: "POST"
			dataType: "JSON"
			crossDomain: true
			data: "email="+username+"&pass="+pass
			success: (data) =>

				if data != 501
					chrome.storage.sync.set({
						'gifme_uuid': data.id,
						'user': data.user_data
						'twitter': data.user_data.twitter
					}, =>
						@set({
							user: data.user_data
							user_id: data.id
							twitter: data.user_data.twitter
						})
					)

				callback(data)
		})

	#------------------------------------------------------------------------------
	#
	#	Login
	#
	#------------------------------------------------------------------------------
	login: (username, pass, callback) =>

		$.ajax({
			url: @get('url')+"/user/login_new"
			type: "POST"
			dataType: "JSON"
			crossDomain: true
			data: "email="+username+"&pass="+pass
			headers: { 'x-app-header': 'desktop-extension' }
			success: (data) =>
				
				if data != 404 && data != 401
					chrome.storage.sync.set({
						'gifme_uuid': data.id,
						'user': data.user_data
						'twitter': data.user_data.twitter
					}, =>
						@set({
							user: data.user_data
							user_id: data.id
							twitter: data.user_data.twitter
						})
					)

				callback(data)
		})



	#------------------------------------------------------------------------------
	#
	#	Get Page
	#
	#------------------------------------------------------------------------------
	get_page: (callback) =>
		cb = callback
		$.ajax({
			url: @get('url')+"/userbeta/"+@get('user_id')+"/gifs/"+@get('current_page')
			type: "GET"
			success: (data) =>
				cb(data)
				if !data.user.last_page
					np = @get('current_page') + 1
					@set({
						current_page: np
					})
		})

	#------------------------------------------------------------------------------
	#
	#	Load Gif
	#
	#------------------------------------------------------------------------------
	load_detail: (id, callback) =>
		$.ajax({
			url: @get('url')+"/gif/"+id+"/details"
			type: "GET"
			success: (data) =>
				callback(data)
		})

	#------------------------------------------------------------------------------
	#
	#	Search
	#
	#------------------------------------------------------------------------------
	search: (search,callback) =>
		$.ajax({
			url: @get('url')+"/user/"+@get('user_id')+"/tags/"+search
			type: "GET"
			success: (data) =>
				@set({
					'search_results': data
					'search_term': search
				})
				callback(data)
				_gaq.push(['_trackEvent', 'search', search])

		})

	#------------------------------------------------------------------------------
	#
	#	Update Gif
	#
	#------------------------------------------------------------------------------
	update_gif: (id, tags, callback) =>
		$.ajax({
			url: @get('url')+'/user/'+@get('user_id')+"/tag/"
			type: "POST"
			data: 'tag='+tags+"&gif="+id
			success: (data) =>
				callback(data)
		})

	#------------------------------------------------------------------------------
	#
	#	Repair Gif
	#
	#------------------------------------------------------------------------------
	repair_gif: (gif, callback) =>

		$.ajax({
			url: @get('url')+'/gif/repair'
			type: 'POST'
			data: "id="+gif
			success: (data) =>
				callback()
		})

	#------------------------------------------------------------------------------
	#
	#	Delete Gif
	#
	#------------------------------------------------------------------------------
	delete_gif: (id, callback) =>
		$.ajax({
			url: @get('url')+"/gif/"+id+"/delete"
			type: "GET"
			success: (data) =>
				callback()
		})

	#------------------------------------------------------------------------------
	#
	#	Tweet
	#
	#------------------------------------------------------------------------------
	post_tweet: (tweet, callback) =>

		$.ajax({
			url: @get('url')+'/services/twitter/post_tweet'
			data: "message="+encodeURIComponent(tweet.message)+"&user="+tweet.user+"&gif="+tweet.gif
			type: "POST"
			success: (data) =>
				console.log data
				callback()
		})

module.exports = AppModel
