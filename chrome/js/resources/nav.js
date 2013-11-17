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
	nav = function() {
		var self = this;

		self.logo;
		self.search;
		self.search_box;
		self.menu_box;
		self.menu;

		self.init = function() {

			$("#tools").show();

			// Define Elements
			self.logo = $("#logo");
			self.search = $("#search");
			self.menu = $("#menu");
			self.search_box = $("#search_box");
			self.menu_box = $("#menu_box");
			self.settings = $("#settings");
			self.upload = $("#upload");
			self.about = $("#about");
			self.go_to = $("#go_to");

			/////////////////////////////////////////
			//
			//	Attach Listeners
			//
			/////////////////////////////////////////

			// LOGO
			self.logo.click(function() {
				_gifme.api.get("/userbeta/" + _gifme.user + "/gifs/0", function(data) {
					$("#wrapper").scrollTop(0);
					_gifme.page = 0;
					_gifme.content.html('');
					_gifme.new_data(data);
				});
				_gaq.push(['_trackEvent', 'logo', 'clicked']);
			});

			self.go_to.click(function() {
				_gifme.api.get("/user/" + _gifme.user + "/favorites", function(data) {
					$("#wrapper").scrollTop(0);
					_gifme.page = 0;
					_gifme.content.html('');
					_gifme.new_data(data);
				});
				_gaq.push(['_trackEvent', 'goto', 'clicked']);
			});

			// SEARCH
			self.search_box.click(function() {
				self.search_box.width('205px');
				setTimeout(function() {
					self.search.fadeIn(250);
					self.search.focus();
				}, 250)
				_gaq.push(['_trackEvent', 'search_box', 'clicked']);
			});

			self.search.blur(function() {
				self.search.fadeOut(150);
				setTimeout(function() {
					self.search_box.width('37px');
				}, 250);
			});

			self.menu_box.click(function() {
				$("body").toggleClass('menu_open');
				if ($('body').hasClass('menu_open')) {
					self.menu_box.children('.icon').html('x')
				} else {
					self.menu_box.children('.icon').html('/')
				}
				_gaq.push(['_trackEvent', 'menu_box', 'clicked']);
			});

			$('#wrapper,#search_box,#logo,.thumb,.item,#logo').not("#menu_box,#menu_box .icon").click(function() {
				$("body").removeClass('menu_open');
				self.menu_box.children('.icon').html('/')
			});

			$("#search_form").submit(function() {
				$("#wrapper").scrollTop(0);
				_gifme.page = 0;
				var term = $("#search").val();

				if (term == "") {
					_gifme.api.get("/userbeta/" + _gifme.user + "/gifs/" + _gifme.page, function(data) {
						_gifme.content.html("");
						_gifme.new_data(data);
					});
				} else {
					_gifme.api.get("/user/" + _gifme.user + "/tags/" + term, function(data) {
						_gifme.content.html("");
						_gifme.new_data(data);
					});
				}
				_gaq.push(['_trackEvent', 'search?q='+term, 'clicked']);
				return false;
			});

			self.settings.click(function() {
				_gifme.settings.init();
				_gaq.push(['_trackEvent', 'settings', 'clicked']);
			});

			self.about.click(function() {
				_gifme.set_view(_gifme.templates.info, null, function() {

				});
				_gaq.push(['_trackEvent', 'about', 'clicked']);
			});
		}

		return self;
	}
})();