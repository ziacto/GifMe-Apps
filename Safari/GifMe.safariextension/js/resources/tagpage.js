/////////////////////////////////////////
//
//	Tag Page
//
/////////////////////////////////////////
(function() {
	tag_page = function(data) {
		var self = this;

		self.data = data;

		self.init = function() {
			$("html,body").height(444);
			$(".gif_holder").imgur({
				img: self.data.gif.link
			}, function(el, data) {
				el.css({
					'backgroundImage': 'url(' + data + ')',
					'backgroundSize': 'cover',
					'backgroundPosition': 'center'
				});
			});

			$("#cancel").click(function() {
				$("#tag_edit").fadeOut(function() {
					$(this).remove();
				});
				$("html,body").height(600);
				$("#modal").hide();
			});

			$(window).bind('keypress', function(event) {
				if (event.which == 13) {
					$("#save").trigger('click');
				}
			});

			$("#save").click(function() {
				var tag = $("#gif_tag").val();

				if (tag != "tag" && tag != "" && tag != "use spaces between tags") {
					_gifme.api.get("/user/" + _gifme.user + "/tag/" + self.data.gif.id + "/" + tag, function(data) {
						$("#tag_edit").fadeOut(function() {
							$(this).remove();
						});
						$("html,body").height(600);
					});
				} else {
					$("#tag_edit").fadeOut(function() {
						$(this).remove();
					});
					$("html,body").height(600);
				}

			});

			$("#gif_tag").focus(function() {
				if ($("#gif_tag").val().match(/use spaces between tags/i)) {
					$("#gif_tag").val("");
				}
				$("#modal").hide();
			});

			$("#delete").click(function() {
				$("#" + self.data.gif.id).remove();
				_gifme.api.get("/gif/" + self.data.gif.id + "/delete", function(data) {
					$("#tag_edit").fadeOut(function() {
						$(this).remove();
					});
					$("#modal").fadeOut();
					$("html,body").height(600);
				});

			});
			$("#gif_link").mouseup(function(e) {
				e.preventDefault();
			});
			$("#gif_link").on('focus', function() {

				if (_gifme.settings.shrink() == "true") {
					var orig_url = $(this).val();
					var link = $(this);

					$.ajax({
						url: "http://tinyurl.com/api-create.php?url=" + orig_url,
						type: "GET",
						dataType: "text",
						success: function(data) {
							link.val(data);
							link.select();
						}
					});
				} else {
					$(this).select();
				}

				$("#modal").html("command + c<br/>to copy");
				$("#modal").show();


				// send stats
				_gifme.api.silent("/user/" + _gifme.user + "/copy/" + self.data.gif.id, function(data) {
					console.log(data)
				});
			});
		}

		self.init();
		return self;
	}
})();