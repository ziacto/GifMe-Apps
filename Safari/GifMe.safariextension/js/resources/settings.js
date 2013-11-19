/////////////////////////////////////////////////////
//
//	GIFME
//	Author: Drew Dahlman ( www.drewdahlman.com )
//	Version: 3.0
//	Date: 08.19.2013
//	File: nav.js
//	
//	Copyright 2013 Gifme.io
//
/////////////////////////////////////////////////////
(function() {
	settings = function() {
		var self = this;

		self.stats;
		self.shrink = function() {
			var shrink = safari.extension.settings.url_shrink;
			return shrink;
		}


		self.init = function() {
			_gifme.api.get("/user/" + _gifme.user + "/stats/", function(data) {
				self.stats = {
					user: data.users[1],
					gifs: data.meta.gifs,
					tags: data.meta.tags,
					shares: data.meta.shares,
					url: data.meta.url,
					id: data.users[0]
				}

				_gifme.content.html(_gifme.templates.settings(self.stats));
				_gifme.content.width('95%');

				// logout
				$("#logout").click(function() {
					safari.extension.settings.gifme_uuid = 0;
					_gifme.user = null;
					_gifme.init();
					window.localStorage.removeItem('gifme_uuid')
				});

				// Shrink
				$("#shrink").change(function() {
					if (this.checked) {
						safari.extension.settings.url_shrink = true;
					} else {
						safari.extension.settings.url_shrink = false;
					}
				});
				$("#auto_tag").change(function() {
					if (this.checked) {
						safari.extension.settings.auto_tag = true;
					} else {
						safari.extension.settings.auto_tag = false;
					}
				});

				if (self.shrink() == "true") {
					$("#shrink").prop('checked', true);
				} else {
					$("#shrink").prop('checked', false);
				}


				if (safari.extension.settings.auto_tag == true) {
					$("#auto_tag").prop('checked', true);
				} else {
					$("#auto_tag").prop('checked', false);
				}

			});

		}

		return self;
	}
})();