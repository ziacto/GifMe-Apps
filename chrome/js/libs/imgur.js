/*
	Plugin: IMGUR
	Author: Drew Dahlman ( www.drewdahlman.com )
	Version: 0.0.2
*/

jQuery(function($) {

	$.fn.imgur = function(options, loaded) {
		var defaults = {
			img: '',
			delay: 0
		}

		if (loaded) {
			var callback = {
				loaded: loaded
			}
		}

		return this.each(function() {

			var settings = $.extend(defaults, options);
			var callbacks = $.extend(callback, loaded);

			var $this = $(this);

			function init() {
				if (callbacks.loaded != null) {
					var _image = new Image();
					_image.onLoad = loaded();
					_image.src = settings.img;
				}
			}

			function loaded() {
				if (callbacks.loaded != null) {
					setTimeout(function() {
						callbacks.loaded($this, settings.img);
					}, settings.delay);
				}
			}
			init();
		});
	};

});