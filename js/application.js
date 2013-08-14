/////////////////////////////////////////
//
//	GIFME Core Application
//	Context Menus and general API
//
/////////////////////////////////////////
var u = null;
var _gifme = {
	api: {
		url: "http://xxx.xx.xxx.xxx",
		user: check_user()
	},
	init: function() {
		console.log(_gifme.api.user)
	},
	select_image: function(info, tab) {
		check_user();
		var url = info.srcUrl.replace("http://", "");
			url = url.replace("https://","");

		if (u) {
			$.ajax({
				url: _gifme.api.url + "/gif/create/" + u + "/" + url ,
				type: "GET",
				crossDomain: true,
				success: function(msg) {
					console.log("created");
				},
				error: function(w, t, f) {
					console.log("Error!");
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
}

/////////////////////////////////////////
//
//	Context Menus
//
/////////////////////////////////////////
chrome.contextMenus.onClicked.addListener(_gifme.select_image);

// Add menu on extension install
chrome.runtime.onInstalled.addListener(function() {
	chrome.contextMenus.create({
		"title": "GIFME THIS",
		"contexts": ["image"],
		"id": "GIFME"
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
	}
});