document.addEventListener("contextmenu", handleContextMenu, false);

function handleContextMenu(event) {
	if (event.target.nodeName === "IMG") {
		safari.self.tab.setContextMenuEventUserInfo(event, {tag: event.target.nodeName,src: event.target.src});
	}
}