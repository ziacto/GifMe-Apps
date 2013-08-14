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
			$("html,body").height(493);
			$(".gif_holder").imgur({
				img: self.data.link
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
			});

			$("#save").click(function() {
				var tag = $("#gif_tag").val();

				if (tag != "tag" && tag != "") {
					_gifme.send_request("/user/" + _gifme.user + "/tag/" + self.data.gif + "/" + tag, function(data) {
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

			$("#delete").click(function() {
				_gifme.send_request("/gif/" + self.data.gif + "/delete", function(data) {
					$("#tag_edit").fadeOut(function() {
						$(this).remove();
					});
					$("html,body").height(600);
					$("#"+self.data.gif).remove();
				});
			});

			$("#gif_link").on('focus', function() {
				$(this).select();
				document.execCommand('copy');
				$("#modal").html("Copied!");
				$("#modal").show();
				setTimeout(function() {
					$("#modal").fadeOut();
				}, 500)
			});
		}

		self.init();
		return self;
	}
})();