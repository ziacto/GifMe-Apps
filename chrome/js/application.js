/////////////////////////////////////////////////////
//
//	GIFME
//	Author: Drew Dahlman ( www.drewdahlman.com )
//	Version: 3.0
//	Date: 08.19.2013
//	
//	Copyright 2013 Gifme.io
//
/////////////////////////////////////////////////////
var u = null;
var number = 0;
var downloading = 0;
var auto_tag = false;

var _gifme = {
	api: {
		url: "http://166.78.184.106",
		user: check_user()
	},
	init: function() {
		console.log(_gifme.api.user)
	},
	select_image: function(info, tab) {
		check_user();
		var url = info.srcUrl.replace("http://", "");
		url = url.replace("https://", "");

		if (!url.match(/jpg|gif|GIF|JPEG|JPG|png|PNG/i)) {
			url = url + ".gif";
		}

		if (u) {
			clearInterval(downloading);
			var d = 1;
			downloading = setInterval(function() {
				var image = 'images/downloading/' + d + '.png'
				chrome.browserAction.setIcon({
					'path': image
				}, function() {});
				if (d > 14) {
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

					chrome.browserAction.setBadgeText({
						'text': (number + "")
					});
					chrome.browserAction.setIcon({
						'path': 'images/icon_48.png'
					}, function() {
						number = 0;
					});
					clearInterval(downloading);

					if (auto_tag) {
						var tags = prompt("Tag This Gif:","");
						console.log(msg)
						$.ajax({
							url: _gifme.api.url+"/user/"+u+"/tag/"+msg.gif.id+"/"+tags,
							type: "GET",
							crossDomain: true,
							timeout: 10000,
							success:function(){

							}
						});
					}
				},
				error: function(w, t, f) {
					console.log("Error!");
					chrome.browserAction.setBadgeText({
						'text': ("!")
					});
					chrome.browserAction.setIcon({
						'path': 'images/icon_48.png'
					}, function() {
						number = 0;
					});
					number = 0;
					clearInterval(downloading);
				}
			});
		} else {
			alert("You need to register an account to use GIFME!")
		}
	}
};

/////////////////////////////////////////
//
//	Chrome Stuff
//
/////////////////////////////////////////

function check_user() {

	chrome.storage.sync.get('gifme_uuid', function(msg) {
		u = msg.gifme_uuid
	});

	chrome.storage.sync.get('auto_tag', function(msg) {
		auto_tag = msg.auto_tag
	});

}

/////////////////////////////////////////
//
//	Context Menus
//
/////////////////////////////////////////
chrome.contextMenus.onClicked.addListener(_gifme.select_image);

// Add menu on extension install
chrome.runtime.onInstalled.addListener(function() {
	var str = "abcdefghijklmnopqrstuv";
	var RAN = "gifme_2.6";
	// for(var i = 0; i < 5; i++){
	// 	var rani = Math.floor(Math.random() * str.length);
	// 	RAN = RAN + str[rani] + "";
	// }

	chrome.contextMenus.create({
		"title": "GifMe",
		"contexts": ["image"],
		"id": RAN
	});
});

// Check Storage debugging
chrome.storage.onChanged.addListener(function(changes, namespace) {
	for (key in changes) {
		var storageChange = changes[key];
		console.log('Storage key "%s" in namespace "%s" changed. ' +
			'Old value was "%s", new value is "%s".',
			key,
			namespace,
			storageChange.oldValue,
			storageChange.newValue);

		u = storageChange.newValue;
	}
});