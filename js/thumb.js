/////////////////////////////////////////
//
//	ThumbJS
//
/////////////////////////////////////////
(function() {
	thumb = function(el) {
		var self = this;
		self.el = $(el);
		self.id = $(el).attr('id');

		self.init = function() {
			
			var img = self.el.data('image');

			self.el.imgur({
				img: img
			}, function(el, data) {
				$("#"+self.id).css({
					'backgroundImage': 'url(' + data + ')',
					'backgroundSize': 'cover',
					'backgroundPosition': 'center'
				});
			});

			$("#"+self.id).hover(function(){
				var gif = $(this).data('url');
				$(this).css({
					'backgroundImage': 'url(' + gif + ')',
					'backgroundSize': 'cover',
					'backgroundPosition': 'center'
				});
			},function(){
				var gif = $(this).data('image');
				$(this).css({
					'backgroundImage': 'url(' + gif + ')',
					'backgroundSize': 'cover',
					'backgroundPosition': 'center'
				});
			});
		}

		return self;
	}
})();