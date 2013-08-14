window._gifme = new Application();

var templates = ['thumb', 'signup_signin', 'tag_page','settings'];

$(function() {

	// measure
	// Create the measurement node
	var scrollDiv = document.createElement("div");
	scrollDiv.className = "scrollbar-measure";
	document.body.appendChild(scrollDiv);

	// Get the scrollbar width
	var scrollbarWidth = scrollDiv.offsetWidth - scrollDiv.clientWidth;


	// Delete the DIV 
	document.body.removeChild(scrollDiv);

	$("body,html,#wrapper").width($("body,html,#wrapper").width()+scrollbarWidth);
	chrome.storage.sync.get('gifme_uuid', function(msg) {
		if (msg) {
			_gifme.user = msg.gifme_uuid;
			_gifme.init();
		} else {
			_gifme.init();
		}
	});

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