###
*
*	
*	Copyright 2014 - GifMe.io	
*
*
###

# Dependencies

class GifmeMenu

	constructor: ->
		@u = null
		@auto_tag = false
		@endpoint = "http://166.78.184.106"
		# @endpoint = "http://0.0.0.0:3000"

		@downloading = 0
		@check_user()

	select_image: (info, tab) =>
		@check_user()

		if @u 
			url = info.srcUrl
			d = 1
			@downloading = setInterval( =>
				image = 'images/downloading/' + d + '.png'
				chrome.browserAction.setIcon({
					'path': image
				});

				if (d > 13)
					d = 0
				
				d = d + 1
			,50)

			## check if GyfCat
			if(info.mediaType == "video")
				console.log url
				if url.match(/gfycat.com/i)
					url = url.split("/")
					@fetch_gyf(url, (data) =>
						@save_image(data)
					)
				else if url.match(/pbs.twimg.com/i)
					@save_twitter(url)
				else if url.match(/vine.co/i)
					@save_vine(url)
				else
					alert("Sorry there is not a Gif source for this video! Try Gfycat!")
					@error()
			else
				@save_image(url)
		else
			alert("You need to register an account to use GifMe!")
			@error()


	save_image: (url) =>
		# url = url.replace('https://',"")
		# url = url.replace("http://","")

		if !url.match(/jpg|gif|GIF|JPEG|JPG|png|PNG/i)
			url = url.slice(0, -1) + ".gif"

		$.ajax({
			url: @endpoint + '/gif/create/' + @u
			type: "POST"
			data: "url="+url
			crossDomain: true
			success: (msg) =>
				if msg.status == "301"
					alert(msg.message)
					@error()
				else
					chrome.browserAction.setBadgeText({
						'text': "1"
					});
					chrome.browserAction.setIcon({
						'path': 'images/icon_48.png'
					});

					tags = prompt("Tag This Gif: ( use spaces between tags )", "")
					console.log msg
					$.ajax({
						url: @endpoint + "/user/" + @u + "/tag",
						type: "POST",
						data: 'tag=' + encodeURIComponent(tags) + "&gif=" + msg.gif.id,
						crossDomain: true,
						timeout: 10000
					})

				clearInterval(@downloading)
			error: (w,t,f) =>
				@error()

		})

	save_twitter: (url) =>

		$.ajax({
			url: @endpoint + '/gif/twitter/convert/' + @u
			type: "POST"
			data: "url="+url
			crossDomain: true
			success: (msg) =>
				if msg.status == "301"
					alert(msg.message)
					@error()
				else
					chrome.browserAction.setBadgeText({
						'text': "1"
					});
					chrome.browserAction.setIcon({
						'path': 'images/icon_48.png'
					});

					tags = prompt("Tag This Gif: ( use spaces between tags )", "")
					console.log msg
					$.ajax({
						url: @endpoint + "/user/" + @u + "/tag",
						type: "POST",
						data: 'tag=' + encodeURIComponent(tags) + "&gif=" + msg.gif.id,
						crossDomain: true,
						timeout: 10000
					})

				clearInterval(@downloading)
			error: (w,t,f) =>
				@error()

		})

	save_vine: (url) =>

		$.ajax({
			url: @endpoint + '/gif/vine/convert/' + @u
			type: "POST"
			data: "url="+url
			crossDomain: true
			success: (msg) =>
				if msg.status == "301"
					alert(msg.message)
					@error()
				else
					chrome.browserAction.setBadgeText({
						'text': "1"
					});
					chrome.browserAction.setIcon({
						'path': 'images/icon_48.png'
					});

					tags = prompt("Tag This Gif: ( use spaces between tags )", "")
					console.log msg
					$.ajax({
						url: @endpoint + "/user/" + @u + "/tag",
						type: "POST",
						data: 'tag=' + encodeURIComponent(tags) + "&gif=" + msg.gif.id,
						crossDomain: true,
						timeout: 10000
					})

				clearInterval(@downloading)
			error: (w,t,f) =>
				@error()

		})

	fetch_gyf: (url, callback) =>
		_url = url[url.length-1].split(".")
		u = _url[0]
		$.ajax({
			url: 'http://gfycat.com/cajax/get/'+u
			success: (data) =>
				callback(data.gfyItem.gifUrl)
		})

	check_user: =>
		chrome.storage.sync.get('gifme_uuid', (msg) =>
			@u = msg.gifme_uuid
		)

	error: =>
		alert("Oh Snap! Something went wrong. We've logged the issue and will be looking into it. Please try again.")
		chrome.browserAction.setBadgeText({
			'text': ("!")
		});
		chrome.browserAction.setIcon({
			'path': 'images/icon_48.png'
		});
		clearInterval(@downloading)

menu = new GifmeMenu()

###
*
*	
*	Chrome Specific	
*
*
###
## Check User

## listen for clicks
chrome.contextMenus.onClicked.addListener (  menu.select_image )

# Add menu on extension install
chrome.runtime.onInstalled.addListener( =>

	chrome.contextMenus.create({
		"title": "GifMe",
		"contexts": ["image"],
		"id": "GifMeContextMenu"
	})

	chrome.contextMenus.create({
		"title": "GifMe",
		"contexts": ["video"],
		"id": "GifMeContextMenuVideo"
	})
)

# Check Storage debugging
chrome.storage.onChanged.addListener( (changes, namespace) =>

	for key in changes
		storageChange = changes[key]
		u = storageChange.newValue
		console.log storageChange

	chrome.tabs.getSelected(null, (tab) =>
		code = 'window.location.reload();';
		chrome.tabs.executeScript(tab.id, {code: code});
	)
)