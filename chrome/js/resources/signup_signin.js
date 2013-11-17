/////////////////////////////////////////////////////
//
//	GIFME
//	Author: Drew Dahlman ( www.drewdahlman.com )
//	Version: 3.0
//	Date: 08.19.2013
//	File: signup_signin.js
//	
//	Copyright 2013 Gifme.io
//
/////////////////////////////////////////////////////
(function() {
	signup_signin = function() {
		var self = this;

		self.init = function() {
			$("#signup").show();
			$('body,html').height(350);

			$("#account").click(function(event) {
				event.preventDefault();

				$("#signup").hide();
				$("#signin").show();

			});

			// sign up
			$(".submit").click(function(event) {
				event.preventDefault();
				var email = $("#signup .email").val();
				var pass = $("#signup .pass").val();

				_gifme.api.get("/user/create/" + email + "/" + pass, function(data) {
					if (data == "501") {
						$("#modal").html("Sorry that username is being used, try another one.");
						$("#modal").show();
						setTimeout(function() {
							$("#modal").fadeOut();
						}, 1000);
					} else {
						_gifme.user = data;

						chrome.storage.sync.set({
							'gifme_uuid': data.user.id
						}, function(msg) {
							_gifme.content.html("");
							_gifme.content.width('100%');
							_gifme.api.get("/user/" + data.user.id + "/gifs/" + self.page, function(data) {
								_gifme.new_data(data);
							});
							chrome.tabs.reload();
						});

					}

				});
			});

			// sign in
			$(".submit_b").click(function(event) {
				event.preventDefault();
				var email = $("#signin .email").val();
				var pass = $("#signin .pass").val();

				_gifme.api.get("/user/login/" + email + "/" + pass, function(data) {
					if (data == "401" || data == "404") {
						$("#modal").html("Oops! Try Again.");
						$("#modal").show();
						setTimeout(function() {
							$("#modal").fadeOut();
						}, 500);
					} else {
						_gifme.user = data;

						chrome.storage.sync.set({
							'gifme_uuid': data
						}, function(msg) {
							_gifme.content.html("");
							$("html,body").height(600);
							_gifme.api.get("/userbeta/" + data + "/gifs/" + _gifme.page, function(data) {
								_gifme.nav.init();
								_gifme.content.width('100%');
								_gifme.new_data(data);
							});
							chrome.tabs.reload();
						});

					}

				});
			});

		}
		return self;
	}
})();