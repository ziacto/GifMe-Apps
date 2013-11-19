(function() {
	Application = function() {
		var self = this;
		var u = null;
		var number = 0;
		var downloading = 0;
		var auto_tag = safari.extension.settings.auto_tag;

		self.user = safari.extension.settings.gifme_uuid;
		self.api = {
			url: "http://166.78.184.106"
		}


		self.save_image = function(target_image) {
			console.log(target_image)
			if (self.user === 0) {
				alert("Oops! You need to be signed into GifMe to save this image!");

			} else {
				var u = safari.extension.settings.gifme_uuid;
				var url = target_image.replace("http://", "");
				url = url.replace("https://", "");
				// var url = target_image;

				console.log(url)
				if (!url.match(/jpg|gif|GIF|JPEG|JPG|png|PNG/i)) {
					url = url + ".gif";
				}

				if (u) {
					clearInterval(downloading);
					var d = 1;
					downloading = setInterval(function() {
						var iconUri = safari.extension.baseURI + 'images/downloading/' + d + '.png';
						safari.extension.toolbarItems[0].image = iconUri;
						if (d > 9) {
							d = 0;
						}
						d = d + 1;
					}, 50);
					$.ajax({
						url: _gifme.api.url + "/gif/create/" + u + "/" + url,
						type: "GET",
						crossDomain: true,
						timeout: 10000,
						success: function(msg) {
							number = number + 1;

							var iconUri = safari.extension.baseURI + 'icon_64.png';
							safari.extension.toolbarItems[0].image = iconUri;

							clearInterval(downloading);
							console.log(msg)
							if (auto_tag) {
								var tags = prompt("Tag This Gif:", "");
								console.log(msg)
								$.ajax({
									url: _gifme.api.url + "/user/" + u + "/tag/" + msg.gif.id + "/" + tags,
									type: "GET",
									crossDomain: true,
									timeout: 10000,
									success: function() {

									}
								});
							}
						},
						error: function(w, t, f) {
							console.log("Error!");
							// chrome.browserAction.setBadgeText({
							// 	'text': ("!")
							// });
							// chrome.browserAction.setIcon({
							// 	'path': 'images/icon_48.png'
							// }, function() {
							// 	number = 0;
							// });
							number = 0;
							clearInterval(downloading);
						}
					});
				} else {
					alert("You need to register an account to use GIFME!")
				}
			}
		}
		return self;
	}
})();