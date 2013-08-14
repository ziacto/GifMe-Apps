/////////////////////////////////////////
//
//	GIFME
//
/////////////////////////////////////////
(function() {
	Application = function() {

		var self = this;
		self.api = {
			url: "http://166.78.184.106"
		}
		self.user = null;
		self.page = 0;
		self.limit = 10;

		self.templates = [];

		self.init = function() {
			if (self.user) {
				self.send_request("/user/" + self.user + "/gifs/" + self.page, function(data) {
					self.new_data(data);
				});
			} else {
				$("#wrapper").html(self.templates.signup_signin());

				$("html,body").height(280);
				$("#account").click(function() {
					$("#signup").hide();
					$("html,body").height(210);
				});

				// sign up
				$(".submit").click(function(event) {
					event.preventDefault();
					var email = $("#signup .email").val();
					var pass = $("#signup .pass").val();

					self.send_request("/user/create/" + email + "/" + pass, function(data) {
						if (data == "501") {
							$("#modal").html("Sorry that email is being used");
							$("#modal").show();
							setTimeout(function() {
								$("#modal").fadeOut();
							}, 500);
						} else {
							chrome.storage.sync.set({
								'gifme_uuid': data.user.id
							}, function(msg) {
								$("html,body").height(600);
								self.send_request("/user/" + data.user.id + "/gifs/" + self.page, function(data) {
									self.new_data(data);
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

					self.send_request("/user/login/" + email + "/" + pass, function(data) {
						if (data == "401" || data == "404") {
							$("#modal").html("Oops! Try Again.");
							$("#modal").show();
							setTimeout(function() {
								$("#modal").fadeOut();
							}, 500);
						} else {
							$("#wrapper").html("");
							chrome.storage.sync.set({
								'gifme_uuid': data
							}, function(msg) {
								$("html,body").height(600);
								self.send_request("/user/" + data + "/gifs/" + self.page, function(data) {
									self.new_data(data);
								});
								chrome.tabs.reload();
							});

						}

					});
				});
			}

			$("#search_form").submit(function() {
				var term = $("#search").val();

				if (term == "") {
					self.send_request("/user/" + self.user + "/gifs/" + self.page, function(data) {
						$("#wrapper").html("");
						self.new_data(data);
					});
				} else {
					self.send_request("/user/" + self.user + "/tags/" + term, function(data) {
						$("#wrapper").html("");
						self.new_data(data);
					});
				}

				return false;
			});

			$("#search_box").click(function() {
				$(this).width(139);
				setTimeout(function() {
					$("#search").show();
					$("#search").focus();
				}, 260);
				$("#search").on('blur', function() {
					$("#search").hide();
					$("#search_box").width(15);
				});
			});

			$("#logo").click(function() {
				self.send_request("/user/" + self.user + "/gifs/" + self.page, function(data) {
					$("#wrapper").html("");
					self.new_data(data);
				});
			});

			$("#settings_box").click(function() {
				$("#wrapper").html(self.templates.settings());
				$("#logout").click(function() {
					chrome.storage.sync.remove('gifme_uuid', function() {
						console.log("gone");
						self.user = null;
						self.init();
					});
					window.localStorage.removeItem('gifme_uuid')
				});
			});
		}

		self.new_data = function(data) {
			if (data.users.length > 0) {
				var d = data.users;
				_.each(d, function(gif) {
					var _gif = self.templates.thumb(gif);
					$("#wrapper").append(_gif);

					var _thumb = new thumb(_gif);
					_thumb.init();
				});

				$(".copy_link").on('click', function() {
					$(this).parent().parent().parent().find('.link').select();
					document.execCommand('copy');
					$("#modal").html("Copied!");
					$("#modal").show();
					setTimeout(function() {
						$("#modal").fadeOut();
					}, 500)
				});

				$(".tag_link").on('click', function() {
					var gif = $(this).parent().parent().parent().attr('id');
					var tag = "";
					var link = $(this).parent().parent().parent().data('url');

					self.send_request("/user/" + self.user + "/tags", function(tags) {
						_.find(tags, function(_tag, iterator) {
							if (_tag.gif == gif) {
								tag = _tag.tag;
							}
						});

						var data = {
							gif: gif,
							link: link,
							tag: tag
						}
						var detail = self.templates.tag_page(data);
						$("#wrapper").append(detail);

						var tagPage = new tag_page(data);
					});
				});
			} else {
				$("#wrapper").html("<div id='oh_no'>There's nothing here!<br/>Go collect some gifs!</div>");
			}
		}

		self.send_request = function(request, callback) {
			$("#modal").html("<span class='icon'>$</span>");
			$("#modal").show();
			$.ajax({
				url: self.api.url + request,
				type: "GET",
				success: function(data) {
					callback(data);
					$("#modal").fadeOut();
				}
			});
		}

		self.save_image = function(info) {
			return "YAY!";
		}
		return self;
	}
})();