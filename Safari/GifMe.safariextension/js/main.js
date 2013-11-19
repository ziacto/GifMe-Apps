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


window._gifme = new App();
var templates = ['thumb', 'signup_signin', 'tag_page', 'settings', 'info', 'upload'];
var user = safari.extension.settings.gifme_uuid;

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
	safari.extension.popovers[0].width = $("body,html,#wrapper").width() + scrollbarWidth;
	$("body,html,#wrapper").width($("body,html,#wrapper").width() + scrollbarWidth);
	

	/////////////////////////////////////////
	//
	//	Chrome Ready Set
	//
	/////////////////////////////////////////
	if (user) {
		_gifme.user = user;
		_gifme.init();
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

var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-43186612-1']);
_gaq.push(['_trackPageview']);