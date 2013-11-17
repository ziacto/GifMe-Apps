/////////////////////////////////////////////////////
//
//	GIFME
//	Author: Drew Dahlman ( www.drewdahlman.com )
//	Version: 3.0
//	Date: 08.19.2013
//	File: thumb.js
//	
//	Copyright 2013 Gifme.io
//
/////////////////////////////////////////////////////

(function() {
	thumb = function(el, i) {
		var self = this;

		self.el = $(el);
		self.id = $(el).attr('id');
		self.cache = null;

		var i = i,
			timer = 0,
			wait = 0;

		self.init = function() {

			setTimeout(function() {
				$("#" + self.id).css({
					'opacity': '1'
				});
				var img = $("#" + self.id + " .static").data('image');

				self.el.imgur({
					img: img,
					delay: i
				}, function(el, data) {
					$("#" + self.id + " .static").css({
						'backgroundImage': 'url(' + data + ')',
						'backgroundSize': 'cover',
						'backgroundPosition': 'center'
					});
					setTimeout(function() {
						$("#" + self.id).css({
							'backgroundImage': 'none'
						});
					}, 500)
					$("#" + self.id + " .static").fadeIn();
				});
			}, i);

			$("#" + self.id).hover(function() {
				var gif = $(this).children('.animated').data('image'),
					$this = $(this);

				if (!self.cache) {
					self.el.imgur({
						img: gif,
						delay: 0
					}, function(el, data) {
						self.cache = data;
						$this.children('.animated').css({
							'backgroundImage': 'url(' + data + ')',
							'backgroundSize': 'cover',
							'backgroundPosition': 'center'
						});
						setTimeout(function() {
							$this.children('.animated').fadeIn();
						}, 150)
					});
				} else {
					$this.children('.animated').css({
						'backgroundImage': 'url(' + self.cache + ')',
						'backgroundSize': 'cover',
						'backgroundPosition': 'center'
					});
					setTimeout(function() {
						$this.children('.animated').fadeIn();
					}, 150)
				}


			}, function() {
				$(this).children('.animated').css({
					'backgroundImage': 'none'
				});
			});

		}

		return self;
	}
})();