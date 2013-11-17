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


window._gifme = new Application();
var templates = ['thumb', 'signup_signin', 'tag_page', 'settings', 'info', 'upload'];

$(function() {

	/////////////////////////////////////////
	//
	//	Layout Before Render
	//
	/////////////////////////////////////////
	// Create the measurement node
	var scrollDiv = document.createElement("div");
	scrollDiv.className = "scrollbar-measure";
	document.body.appendChild(scrollDiv);

	// Get the scrollbar width
	var scrollbarWidth = scrollDiv.offsetWidth - scrollDiv.clientWidth;

	// Delete the DIV 
	document.body.removeChild(scrollDiv);
	$("body,html,#wrapper").width($("body,html,#wrapper").width() + scrollbarWidth);

	/////////////////////////////////////////
	//
	//	Chrome Ready Set
	//
	/////////////////////////////////////////
	if (chrome.storage) {
		chrome.storage.sync.get('gifme_uuid', function(msg) {
			if (msg) {
				_gifme.user = msg.gifme_uuid;
				_gifme.init();
			} else {
				_gifme.init();
			}
		});
	} else {
		_gifme.init();
	}

});

_.each(templates, function(template) {
	$.ajax({
		url: 'js/templates/' + template + '.jst',
		dataType: 'HTML',
		type: 'GET',
		async: false,
		success: function(data) {
			_gifme.templates[template] = _.template(data);
		}
	});
});

if (chrome.storage) {
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
}

var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-43186612-1']);
_gaq.push(['_trackPageview']);
